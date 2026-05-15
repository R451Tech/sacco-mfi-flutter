class SavingsAccount {
  final String id;
  final String memberId;
  final String? memberName;
  final String accountNumber;
  final double balance;
  final double interestRate;
  final String status;
  final DateTime openedDate;
  final DateTime? lastTransactionDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const SavingsAccount({
    required this.id,
    required this.memberId,
    this.memberName,
    required this.accountNumber,
    this.balance = 0.0,
    this.interestRate = 0.0,
    this.status = 'active',
    required this.openedDate,
    this.lastTransactionDate,
    this.createdAt,
    this.updatedAt,
  });

  factory SavingsAccount.fromJson(Map<String, dynamic> json) {
    return SavingsAccount(
      id: json['id'] as String,
      memberId: json['memberId'] as String,
      memberName: json['memberName'] as String?,
      accountNumber: json['accountNumber'] as String,
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      interestRate: (json['interestRate'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? 'active',
      openedDate: DateTime.parse(json['openedDate'] as String),
      lastTransactionDate: json['lastTransactionDate'] != null
          ? DateTime.parse(json['lastTransactionDate'] as String)
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'memberId': memberId,
    'memberName': memberName,
    'accountNumber': accountNumber,
    'balance': balance,
    'interestRate': interestRate,
    'status': status,
    'openedDate': openedDate.toIso8601String(),
    'lastTransactionDate': lastTransactionDate?.toIso8601String(),
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };
}
