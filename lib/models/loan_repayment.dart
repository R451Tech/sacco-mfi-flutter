class LoanRepayment {
  final String id;
  final String loanId;
  final double amount;
  final double principalPaid;
  final double interestPaid;
  final double? penaltyPaid;
  final double? balanceAfter;
  final DateTime dueDate;
  final DateTime? paidDate;
  final String status;
  final String? paymentMethod;
  final String? reference;
  final String? notes;
  final DateTime? createdAt;

  const LoanRepayment({
    required this.id,
    required this.loanId,
    this.amount = 0,
    this.principalPaid = 0,
    this.interestPaid = 0,
    this.penaltyPaid,
    this.balanceAfter,
    required this.dueDate,
    this.paidDate,
    this.status = 'pending',
    this.paymentMethod,
    this.reference,
    this.notes,
    this.createdAt,
  });

  bool get isOverdue => status == 'pending' && dueDate.isBefore(DateTime.now());

  factory LoanRepayment.fromJson(Map<String, dynamic> json) {
    return LoanRepayment(
      id: json['id'] as String,
      loanId: json['loanId'] as String,
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      principalPaid: (json['principalPaid'] as num?)?.toDouble() ?? 0,
      interestPaid: (json['interestPaid'] as num?)?.toDouble() ?? 0,
      penaltyPaid: (json['penaltyPaid'] as num?)?.toDouble(),
      balanceAfter: (json['balanceAfter'] as num?)?.toDouble(),
      dueDate: DateTime.parse(json['dueDate'] as String),
      paidDate: json['paidDate'] != null
          ? DateTime.parse(json['paidDate'] as String)
          : null,
      status: json['status'] as String? ?? 'pending',
      paymentMethod: json['paymentMethod'] as String?,
      reference: json['reference'] as String?,
      notes: json['notes'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'loanId': loanId,
    'amount': amount,
    'principalPaid': principalPaid,
    'interestPaid': interestPaid,
    'penaltyPaid': penaltyPaid,
    'balanceAfter': balanceAfter,
    'dueDate': dueDate.toIso8601String(),
    'paidDate': paidDate?.toIso8601String(),
    'status': status,
    'paymentMethod': paymentMethod,
    'reference': reference,
    'notes': notes,
    'createdAt': createdAt?.toIso8601String(),
  };
}
