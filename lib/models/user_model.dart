class UserModel {
  final String? uid;
  final String email;
  final String? name;

  UserModel({this.uid, required this.email, this.name});

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'email': email,
    'name': name,
  };
}