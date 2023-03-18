import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:printer/bloc/printer_bloc.dart';
import 'package:printer/welcome/components/navigation.dart';
import 'dart:convert';
import 'dart:html' as html;
import 'package:open_filex/open_filex.dart';


import 'package:universal_io/io.dart';



class FilePage extends StatefulWidget {
  const FilePage({super.key});

  @override
  State<FilePage> createState() => _FilePageState();
}


class _FilePageState extends State<FilePage> {
  List<String> fileNames = [];
  Dio dio = Dio();
  Map<String, dynamic> map = {};
  late Future<List<String>> fileFuture;

  @override
  void initState() {
    // 获取用户文件
    String userName = NavigationService.navigationKey.currentContext!.read<PrinterBloc>().state.userName;
    map['username'] = userName;
    fileFuture = getUserFiles();
    super.initState();
  }

  Future<List<String>> getUserFiles() async {
    FormData formData = FormData.fromMap(map);
    List<String>? result;
    await dio.post<Map<String, dynamic>>(
      'http://192.168.3.20:5050/api/get/files',
      data: formData
    ).then((value) {
      result = (value.data!['data'] as List).map((e) => e.toString()).toList();
      return result;
    // ignore: argument_type_not_assignable_to_error_handler
    }).catchError((){
      BotToast.showText(text: "网络错误, 暂时获取不到文件");
      return ['error: 网络错误'];
    });
    return result ?? [];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(
        title: const Text("我的文件"),
        elevation: 0,
        leading: null,
      ),
      body: Container(
        child: FutureBuilder<List<String>>(
          future: fileFuture,
          builder: (context, snapshot) {
            print("============ ${snapshot.connectionState} =============");
            print(snapshot.data);
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator(color: Colors.blue,));
            } else if(snapshot.hasData && snapshot.data!.isNotEmpty) {
              return Container(
                alignment: Alignment.topLeft,
                child: SingleChildScrollView(
                  child: Column(
                    children: List.generate(
                      snapshot.data!.length,
                      ((index) {
                        String fileFull = snapshot.data![index].toString();
                        String fileTime = fileFull.split("-").first;
                        String fileName = fileFull.split("-").last;
                        return ListTile(
                          title: Text(fileName),
                          subtitle: Text(fileTime),
                          trailing: const Icon(Icons.file_download),
                          onTap: () async {
                            // download from flask web
                            await _downLoadFileByTime(fileTime, fileName);
                          },
                        );
                      })
                    ),
                  ),
                ),
              );
            } else{
              return const Center(
                child: Text("no files"),// TODO : image
              );
            }
          },
        ),
      ),
    );
  }

  _downLoadFileByTime(String timeWord, String fileName) async {
    // map['username'] = 
    print('====================================');
    map['timeword'] = timeWord;
    FormData formData = FormData.fromMap(map);
    await dio.post<Map<String, dynamic>>(
      'http://192.168.3.20:5050/api/auth/files',
      data: formData
    ).then((value) async {
      String filePath = value.data!['data'];
      html.window.open(
        'http://192.168.3.20:5050/api/download/files?filepath=$filePath', 
        './$fileName'
      );
    });
  }

}