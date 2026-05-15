class User {
  final String id;
  final String email;
  final String fullName;
  final String? phone;
  final String role;
  final bool isActive;
  final DateTime? lastLogin;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.email,
    required this.fullName,
    this.phone,
    this.role = 'staff',
    this.isActive = true,
    this.lastLogin,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      phone: json['phone'] as String?,
      role: json['role'] as String? ?? 'staff',
      isActive: json['isActive'] as bool? ?? true,
      lastLogin: json['lastLogin'] != null
          ? DateTime.parse(json['lastLogin'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'fullName': fullName,
    'phone': phone,
    'role': role,
    'isActive': isActive,
    'lastLogin': lastLogin?.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
  };
}
