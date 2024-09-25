import 'package:image_picker/image_picker.dart';

class ImagePickerUtil {
  final ImagePicker picker = ImagePicker();

  Future<XFile?> cameraCapture() async {
    final XFile? file = await picker.pickImage(source: ImageSource.camera);
    return file;
  }

  Future<XFile?> imageFromGallery() async {
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    return file;
  }
}