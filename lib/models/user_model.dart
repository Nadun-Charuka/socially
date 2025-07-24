class AppUser {
  final String uid;
  final String email;
  final String name;
  final String photoUrl;
  final int followers;
  final int following;
  final bool isGoogleUser;

  AppUser({
    required this.uid,
    required this.email,
    required this.name,
    required this.photoUrl,
    this.followers = 0,
    this.following = 0,
    this.isGoogleUser = false,
  });

  factory AppUser.fromMap(Map<String, dynamic> json) {
    return AppUser(
      uid: json['uid'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      photoUrl: json['photoUrl'] as String,
      followers: json['followers'] as int? ?? 0,
      following: json['following'] as int? ?? 0,
      isGoogleUser: json['isGoogleUser'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'followers': followers,
      'following': following,
      'isGoogleUser': isGoogleUser,
    };
  }
}
