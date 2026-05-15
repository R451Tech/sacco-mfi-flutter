class Member {
  final String id;
  final String firstName;
  final String lastName;
  final String idNumber;
  final String phone;
  final String email;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? address;
  final String? occupation;
  final String? employer;
  final double? monthlyIncome;
  final String? kraPin;
  final String? status;
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Member({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.idNumber,
    required this.phone,
    required this.email,
    this.dateOfBirth,
    this.gender,
    this.address,
    this.occupation,
    this.employer,
    this.monthlyIncome,
    this.kraPin,
    this.status,
    this.photoUrl,
    required this.createdAt,
    this.updatedAt,
  });

  String get fullName => '$firstName $lastName';

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      idNumber: json['idNumber'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'] as String)
          : null,
      gender: json['gender'] as String?,
      address: json['address'] as String?,
      occupation: json['occupation'] as String?,
      employer: json['employer'] as String?,
      monthlyIncome: (json['monthlyIncome'] as num?)?.toDouble(),
      kraPin: json['kraPin'] as String?,
      status: json['status'] as String?,
      photoUrl: json['photoUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'firstName': firstName,
    'lastName': lastName,
    'idNumber': idNumber,
    'phone': phone,
    'email': email,
    'dateOfBirth': dateOfBirth?.toIso8601String(),
    'gender': gender,
    'address': address,
    'occupation': occupation,
    'employer': employer,
    'monthlyIncome': monthlyIncome,
    'kraPin': kraPin,
    'status': status,
    'photoUrl': photoUrl,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };
}
