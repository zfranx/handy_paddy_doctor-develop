import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoader extends StatelessWidget {
  final Color baseColor;
  final Color highlightColor;
  final Widget child;

  const ShimmerLoader({
    Key? key,
    this.baseColor = const Color(0xFFF5F5F5),
    this.highlightColor = const Color(0xFFEEEEEE),
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: child,
    );
  }
}

Future<String> loadAssetTexts(String asset, int index) async {
  String data = await rootBundle.loadString(asset);
  List<String> contents = data.split('\n');
  return contents[index];
}

void imagePickingDialog({required BuildContext context, required Function(ImageSource) onDialogFinish}) {
  showDialog<ImageSource>(
    context: context,
    barrierDismissible: false,
    // false = user must tap button, true = tap outside dialog
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text('Ambil gambar', style: TextStyle(color: Colors.blue)),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              const Divider(height: 1, color: Colors.blue,),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.blue),
                title: const Text('Kamera'),
                onTap: () {
                  Navigator.pop(dialogContext, ImageSource.camera);
                  imageCache.clear();
                },
              ),
              const Divider(height: 1, color: Colors.blue,),
              ListTile(
                leading: const Icon(Icons.image, color: Colors.blue,),
                title: const Text('Galeri'),
                onTap: () {
                  Navigator.pop(dialogContext, ImageSource.gallery);
                  imageCache.clear();
                },
              ),
            ],
          ),
        ),
      );
    },
  ).then((value) {
    if (value != null) {
      onDialogFinish(value);
    }
  });
}