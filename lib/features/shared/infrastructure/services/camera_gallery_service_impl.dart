import 'package:image_picker/image_picker.dart';
import 'package:teslo_shop/features/shared/infrastructure/services/camera_gallery_service.dart';

class CameraGalleryServiceImpl extends CamaraGalleryService {
  final ImagePicker _picker = ImagePicker();
  @override
  Future<String?> selectPhoto() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.gallery,
      // Calidad del 80%
      imageQuality: 80,
    );
    if (photo == null) return null;
    print('Tenemos una imgaen ${photo.path}');
    return photo.path;
  }

  @override
  Future<String?> takePhoto() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      // Calidad del 80%
      imageQuality: 80,
      // Camara Trasera
      preferredCameraDevice: CameraDevice.rear,
    );
    if (photo == null) return null;
    print('Tenemos una imgaen ${photo.path}');
    return photo.path;
  }
}
