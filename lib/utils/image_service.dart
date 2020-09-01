import 'package:cloudinary_client/cloudinary_client.dart';

import '../credentials.dart';

class ImageService {
  final Image client;
  ImageService()
      : client = Image(
          Credentials(
            CLOUDINARY_KEY,
            CLOUDINARY_SECRET,
            CLOUDINARY_NAME,
          ),
        );

  Future<String> upload(String path, [String filename]) async {
    final response = await client.upload(path, filename: filename);
    return response['url'];
  }

  Future<String> uploadfromUrl(String url, [String filename]) async {
    final response = await client.uploadFromUrl(url, filename: filename);
    return response['url'];
  }
}
