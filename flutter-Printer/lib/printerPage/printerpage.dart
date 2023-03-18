// import 'package:file_preview/file_preview.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:printer/bloc/printer_bloc.dart';
import 'package:universal_io/io.dart';

import '../welcome/components/navigation.dart';


class PrinterPage extends StatefulWidget {
  const PrinterPage({super.key});

  @override
  State<PrinterPage> createState() => _PrinterPageState();
}

class _PrinterPageState extends State<PrinterPage> {
  late int printerNums;
  late List<bool> printerList;
  late List<bool> initPrinterList;
  Map<String, dynamic> formMap = {};

  List<Color> nColors = const [
    Color.fromARGB(255, 156, 189, 119),
    Color.fromARGB(255, 205, 207, 67),
    Color.fromARGB(255, 215, 138, 125),
    Color.fromARGB(255, 202, 193, 151),
    Color.fromARGB(255, 87, 105, 110),
    Color.fromARGB(255, 52, 102, 113),
    Color.fromARGB(255, 71, 79, 113),
    Color.fromARGB(255, 241, 205, 172), 
  ];

  @override
  void initState() {
    super.initState();
    doSyncTask();
    printerNums = _getPrinterNums();
    printerList = List.generate(printerNums, (index) => false);
    initPrinterList = List.generate(printerNums, (index) => false);
    bool isLogged = NavigationService.navigationKey.currentContext!.read<PrinterBloc>().state.isLogged;
    
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (!isLogged){
        NavigationService().navigateTo('/loginPage');
      } else {
        formMap['username'] = NavigationService.navigationKey.currentContext!.read<PrinterBloc>().state.userName;
      }
    });
  }

  doSyncTask() async {
    // await FilePreview.initTBS();
  }


  String filename = "no file";
  String? tempFilePathToPreview;
  bool selected = false;
  int? selectedIndex;
  bool uploaded = false;
  Response? response;


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 8/9;
    double height = MediaQuery.of(context).size.height * 1/2;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        printerStorage(),
        SizedBox(height: width * 1/16),
        uploadWidget(width, height),
      ]
    );
  }

  // 上传文件组件
  Widget uploadWidget(double width, double height) {
    return Material(
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.blue[100],
          borderRadius: const BorderRadius.all(Radius.circular(12))
        ),
        child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(12)), 
        onTap: response == null ? _clickUpload : (){},
        child: Container(
          width: width,
          height: height,
          child: response == null ? 
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.upload_file_sharp, 
                  color: Colors.blue[200],
                  size: height * 1/2,
                ),
                promptText("点击上传文件")
              ],
            ): 
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check, 
                  color: Colors.green[200],
                  size: height * 1/2,
                ),
                promptText((response!.data as Map<String,dynamic>)['fileNameOld'].toString())
              ],
            )
          ),
        ),
      ),
    );
  }


  
  // 提示文字
  Widget promptText(String content) {
    return Text(
      content,
      style: const TextStyle(
        color: Colors.black,
        fontStyle: FontStyle.italic,
      ),
    );
  }

  // 打印仓信息
  Widget printerStorage() {
    int counts = 3; //
    double eachWidth = MediaQuery.of(context).size.width / counts;
    double height = MediaQuery.of(context).size.height * 1/4;
    double eachHeight = height / 3;

    return IgnorePointer(
      ignoring: response != null,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12))
        ),
        height: height,
        child: ListView.builder(
          itemCount: printerNums,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: (){
                setState(() {
                  printerList = List<bool>.from(initPrinterList);
                  printerList[index] = !printerList[index];
                  selectedIndex = index;
                });
                BotToast.showText(text: "选择了${index+1}号打印机");
              },
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: nColors[index % nColors.length],
                      borderRadius: const BorderRadius.all(Radius.circular(8))
                    ),
                    width: eachWidth,
                    padding: const EdgeInsets.all(23),
                    child: Wrap(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        runSpacing: 2,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: List.generate(
                          6, (j) => ListTile(
                            // tileColor: Color.fromARGB(48, 158, 158, 158),
                            title: Text("$index $j", ),
                            trailing: const Icon(Icons.abc),
                          )
                        ),
                    ),
                  ),
                  Visibility(
                    visible: printerList[index],
                    child: Container(
                      height: height,
                      width: eachWidth,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: Color.fromARGB(88, 0, 0, 0),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }

  Widget eachStorage(double eachHeight) {
    return Container(
      color: Colors.grey, 
      height: eachHeight,
    );
  }

  Future<void> fileUpload(Uint8List fileValue,int selectedIndex) async {
    BotToast.showLoading();

    String netUploadUrl = "http://192.168.3.20:5050/api/send/file";
    Dio dio = Dio();
    formMap['auth'] = '12345';
    // map['file'] = await MultipartFile.fromFile(tempFilePath, filename: filename);
    formMap['selectedPrinter'] = selectedIndex;
    formMap['file'] = MultipartFile.fromBytes(Uint8List.fromList(fileValue), filename: filename);
    FormData formData = FormData.fromMap(formMap);
    try {
      response = await dio.post(
        netUploadUrl, 
        data: formData,
        onSendProgress: ((count, total) {
          print("当前进度 $count / $total");
          // BotToast.closeAllLoading();
          // CircularProgressIndicator(
          //   backgroundColor: Colors.grey[200],
          //   valueColor: const AlwaysStoppedAnimation(Colors.blue),
          //   value: count / total,
          // );
        })
      );
      print(response!.data);
      print(response!.extra);
      print(response!.statusCode);
      setState(() {
        
      });
    } catch (e) {
      BotToast.showText(text: "网络错误");
      print(e);
    }
    BotToast.closeAllLoading();
  }

  void _clickUpload() async {
    // 先选择打印机
    if(selectedIndex == null){
      BotToast.showText(text: "请先选择一台打印机");
      return;
    }
    
    FilePickerResult? result;
    try {
      result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'pdf', 'doc', 'docx', 'xls', 'xlsx', 'txt'],
      );
    } catch(e){
      // print(e);
    }
    if(result != null) {
      try{
        Uint8List uploadfile = result.files.single.bytes!;
        filename = result.files.single.name; // web path always null !
        await fileUpload(uploadfile, selectedIndex!); // upload file
      }catch(e) {
        print('error:   $e');
      }
      print("文件名称:" + result.files.single.name);
    }
  }

  int _getPrinterNums() {
    return 34;
  }
}