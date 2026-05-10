class Attachment {
  final String fileUrl;
  final String fileType;
  final String fileName;

  Attachment({
    required this.fileUrl,
    required this.fileType,
    required this.fileName,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      fileUrl: json["file_url"] ?? "",
      fileType: json["file_type"] ?? "",
      fileName: json["file_name"] ?? "",
    );
  }
}