class Transaction {
  final String id;
  final String accountId;
  final String memberId;
  final String? memberName;
  final String type;
  final double amount;
  final double balanceBefore;
  final double balanceAfter;
  final String? description;
  final String? reference;
  final String? paymentMethod;
  final String? status;
  final String? processedBy;
  final DateTime date;
  final DateTime? createdAt;

  const Transaction({
    required this.id,
    required this.accountId,
    required this.memberId,
    this.memberName,
    required this.type,
    required this.amount,
    this.balanceBefore = 0,
    this.balanceAfter = 0,
    this.description,
    this.reference,
    this.paymentMethod,
    this.status,
    this.processedBy,
    required this.date,
    this.createdAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      accountId: json['accountId'] as String,
      memberId: json['memberId'] as String,
      memberName: json['memberName'] as String?,
      type: json['type'] as String,
      amount: (json['amount'] as num).toDouble(),
      balanceBefore: (json['balanceBefore'] as num?)?.toDouble() ?? 0,
      balanceAfter: (json['balanceAfter'] as num?)?.toDouble() ?? 0,
      description: json['description'] as String?,
      reference: json['reference'] as String?,
      paymentMethod: json['paymentMethod'] as String?,
      status: json['status'] as String?,
      processedBy: json['processedBy'] as String?,
      date: DateTime.parse(json['date'] as String),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'accountId': accountId,
    'memberId': memberId,
    'memberName': memberName,
    'type': type,
    'amount': amount,
    'balanceBefore': balanceBefore,
    'balanceAfter': balanceAfter,
    'description': description,
    'reference': reference,
    'paymentMethod': paymentMethod,
    'status': status,
    'processedBy': processedBy,
    'date': date.toIso8601String(),
    'createdAt': createdAt?.toIso8601String(),
  };
}
