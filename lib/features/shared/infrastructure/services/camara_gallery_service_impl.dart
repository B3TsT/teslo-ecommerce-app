import 'package:image_picker/image_picker.dart';
import 'camara_gallery_service.dart';

class CamaraGalleryServiceImpl implements CamaraGalleryService {
  final ImagePicker _picker = ImagePicker();

  @override
  Future<String?> selectPhoto() async {
    final XFile? photo = await _picker.pickImage(
      imageQuality: 80,
      source: ImageSource.gallery,
    );
    if (photo == null) return null;
    return photo.path;
  }

  @override
  Future<String?> takePhoto() async {
    final XFile? photo = await _picker.pickImage(
      imageQuality: 80,
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
    );
    if (photo == null) return null;
    return photo.path;
  }
}
