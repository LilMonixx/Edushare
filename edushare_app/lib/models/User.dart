class UserModel {
  final String userId;
  final String? name;
  final String? email;
  final String? avatar;       // URL
  final String? localAvatar;   // FILE PATH
  final String createdAt;
  final String role;
  final String status;

  UserModel({
    required this.userId,
    this.name,
    this.email,
    this.avatar,
    this.localAvatar,
    required this.createdAt,
    this.role = "NORMALUSER",
    this.status = "APPROVED",
  });

  Map<String, dynamic> toMap() {
    return {
      "UserID": userId,
      "Name": name,
      "Email": email,
      "Avatar": avatar,
      "LocalAvatar": localAvatar,
      "CreatedAt": createdAt,
      "Role": role,
      "Status": status,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map["UserID"],
      name: map["Name"],
      email: map["Email"],
      avatar: map["Avatar"],
      localAvatar: map["LocalAvatar"],
      createdAt: map["CreatedAt"],
      role: map["Role"] ?? "NORMALUSER",
      status: map["Status"] ?? "APPROVED",
    );
  }
}