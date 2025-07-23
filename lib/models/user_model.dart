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

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'],
      email: map['email'],
      name: map['name'],
      photoUrl: map['photoUrl'],
      followers: map['followers'] ?? 0,
      following: map['following'] ?? 0,
      isGoogleUser: map['isGoogleUser'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
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
