import 'dart:typed_data';

// Stop image if image exceeds 5MB
int checkImageSize(List<Uint8List> images) {
  int count = 0;
  for (var image in images) {
    if (image.lengthInBytes > 10000 * 1024) {
      count++;
    }
  }
  return count;
}