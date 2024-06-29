class UserInformation {
  final String firstName;
  final String lastName;
  final String userName;
  final String email;
  final String uid;

  UserInformation({
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.email,
    required this.uid,
  });

  factory UserInformation.fromMap(Map<String, dynamic> data) {
    return UserInformation(
      firstName: data['first_name'] as String? ?? '',
      lastName: data['last_name'] as String? ?? '',
      email: data['email'] as String? ?? '',
      uid: data['id'] as String? ?? '',
      userName: data['user_name'] as String? ?? '',
    );
  }
}
