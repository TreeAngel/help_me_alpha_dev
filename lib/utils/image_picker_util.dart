import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../configs/app_colors.dart';

class ImagePickerUtil {
  final ImagePicker picker = ImagePicker();

  Future<XFile?> cameraCapture() async {
    try {
      final XFile? pickedImage =
          await picker.pickImage(source: ImageSource.camera);
      if (pickedImage != null) {
        final CroppedFile? croppedImage = await cropImage(pickedImage);
        if (croppedImage != null) {
          return XFile(croppedImage.path, name: pickedImage.name);
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<XFile?> imageFromGallery() async {
    try {
      final XFile? pickedImage =
          await picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        final CroppedFile? croppedImage = await cropImage(pickedImage);
        if (croppedImage != null) {
          return XFile(croppedImage.path, name: pickedImage.name);
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<CroppedFile?> cropImage(XFile image) async {
    return await ImageCropper.platform.cropImage(
      sourcePath: image.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: image.name,
          toolbarColor: AppColors.primary,
          toolbarWidgetColor: AppColors.lightTextColor,
          initAspectRatio: CropAspectRatioPreset.original,
          showCropGrid: true,
          backgroundColor: AppColors.surface,
          cropGridColor: AppColors.grey,
        ),
      ],
    );
  }
}
