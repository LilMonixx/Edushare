class AttachmentModel {

  final String attachmentId;
  final String fileName;
  final String fileType;
  final String fileUrl;
  final int fileSize;
  final String postId;

  AttachmentModel({
    required this.attachmentId,
    required this.fileName,
    required this.fileType,
    required this.fileUrl,
    required this.fileSize,
    required this.postId,
  });

  factory AttachmentModel.fromMap(Map<String, dynamic> map) {

    return AttachmentModel(
      attachmentId: map["attachmentId"] ?? "",
      fileName: map["file_name"] ?? "",
      fileType: map["file_type"] ?? "",
      fileUrl: map["file_url"] ?? "",
      fileSize: map["file_size"] ?? 0,
      postId: map["postId"] ?? "",
    );
  }
}