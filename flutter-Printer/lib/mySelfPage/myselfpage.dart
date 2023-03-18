import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:camera/camera.dart';
// import 'package:printer/mySelfPage/cameraScreen/taskpicture.dart';
import 'package:image_picker/image_picker.dart';
import 'package:printer/bloc/printer_bloc.dart';
import 'package:printer/welcome/components/navigation.dart';



class MySelfPage extends StatefulWidget {
  const MySelfPage({super.key});

  @override
  State<MySelfPage> createState() => _MySelfPageState();
}

class _MySelfPageState extends State<MySelfPage> {
  // CameraDescription? firstCamera;
  // late Future<List<CameraDescription>> cameras;
  // final bool _logged = NavigationService.navigationKey.currentContext.read<PrinterBloc>;
  // final bool _logged = false;
  late double height;

  @override
  void initState() {
    super.initState();
    print(NavigationService.navigationKey.currentContext!.read<PrinterBloc>().state.userName);
    // doSyncTask();
    // cameras = availableCameras();
  }

  doSyncTask() async {

  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.green[100],
      body: context.read<PrinterBloc>().state.isLogged ? loggedWidget() : unLoggedWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          
        },
        child: const Icon(Icons.camera),
      )
    );
  }

  Widget loggedWidget() {
    return Container(
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          SizedBox(height: height * 1/6,),
          GestureDetector(
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              child: Image.network(
                "data:image/jpeg;base64,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"
                
              ),
            ),
          ),
          const Divider(color: Colors.green,),
          Text(NavigationService.navigationKey.currentContext!.read<PrinterBloc>().state.userName.toString()),
        ]),
    );
  }

  Widget unLoggedWidget() {
    return Container(
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          SizedBox(height: height * 1/6,),
          GestureDetector(
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              child: Image.network(
                "data:image/jpeg;base64,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"
              ),
            ),
          ),
          Text("-----------------"),
          Text("未登录")
        ]),
    );
  }


  Future <void> loadImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    //只允许pick 图片, 不允许gif
    XFile? image = await (picker.pickImage(source: ImageSource.gallery));
      return;
    }
}