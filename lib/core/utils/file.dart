import 'package:cross_file/cross_file.dart';

extension XFileType on XFile {
  bool isImage() {
    final extension = name.split('.').last.toLowerCase();
    const imageExtensions = [
      'jpg',
      'jpeg',
      'png',
      'gif',
      'bmp',
      'webp',
      'tiff'
    ];
    return imageExtensions.contains(extension);
  }

  bool isDocument() {
    final extension = name.split('.').last.toLowerCase();
    const documentExtensions = [
      'pdf',
      'doc',
      'docx',
      'xls',
      'xlsx',
      'ppt',
      'pptx',
      'txt'
    ];
    return documentExtensions.contains(extension);
  }

  bool isAudio() {
    final extension = name.split('.').last.toLowerCase();
    const audioExtensions = ['mp3', 'wav', 'aac', 'ogg', 'flac'];
    return audioExtensions.contains(extension);
  }

  bool isVideo() {
    final extension = name.split('.').last.toLowerCase();
    const videoExtensions = ['mp4', 'avi', 'mov', 'wmv', 'mkv', 'flv'];
    return videoExtensions.contains(extension);
  }
}
