/// User entity representing a parent or young learner account in JAROOS.
class UserModel {
  final String id;
  final String name;
  final String email;
  final String childName;
  final int childAge;
  final String avatar;
  final String favoriteSubject;
  final String? token;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.childName,
    required this.childAge,
    this.avatar = 'star_hero',
    this.favoriteSubject = 'Alphabet & Phonics 🔤',
    this.token,
    required this.createdAt,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? childName,
    int? childAge,
    String? avatar,
    String? favoriteSubject,
    String? token,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      childName: childName ?? this.childName,
      childAge: childAge ?? this.childAge,
      avatar: avatar ?? this.avatar,
      favoriteSubject: favoriteSubject ?? this.favoriteSubject,
      token: token ?? this.token,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      childName: json['childName'] as String? ?? json['child_name'] as String? ?? 'Little Learner',
      childAge: (json['childAge'] as num? ?? json['child_age'] as num? ?? 5).toInt(),
      avatar: json['avatar'] as String? ?? 'star_hero',
      favoriteSubject: json['favoriteSubject'] as String? ?? 'Alphabet & Phonics 🔤',
      token: json['token'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'childName': childName,
      'childAge': childAge,
      'avatar': avatar,
      'favoriteSubject': favoriteSubject,
      'token': token,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, childName: $childName, age: $childAge)';
  }
}
