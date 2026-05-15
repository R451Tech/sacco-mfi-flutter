class Loan {
  final String id;
  final String memberId;
  final String? memberName;
  final String loanProduct;
  final double principal;
  final double interestRate;
  final int termMonths;
  final double monthlyPayment;
  final double totalRepayable;
  final double amountPaid;
  final double balance;
  final String? purpose;
  final String? collateral;
  final String? status;
  final DateTime? applicationDate;
  final DateTime? approvalDate;
  final DateTime? disbursementDate;
  final DateTime? firstPaymentDate;
  final DateTime? maturityDate;
  final String? approvedBy;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Loan({
    required this.id,
    required this.memberId,
    this.memberName,
    required this.loanProduct,
    required this.principal,
    this.interestRate = 0,
    this.termMonths = 12,
    this.monthlyPayment = 0,
    this.totalRepayable = 0,
    this.amountPaid = 0,
    this.balance = 0,
    this.purpose,
    this.collateral,
    this.status = 'pending',
    this.applicationDate,
    this.approvalDate,
    this.disbursementDate,
    this.firstPaymentDate,
    this.maturityDate,
    this.approvedBy,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  double get progress =>
      totalRepayable > 0 ? (amountPaid / totalRepayable).clamp(0.0, 1.0) : 0.0;

  factory Loan.fromJson(Map<String, dynamic> json) {
    return Loan(
      id: json['id'] as String,
      memberId: json['memberId'] as String,
      memberName: json['memberName'] as String?,
      loanProduct: json['loanProduct'] as String,
      principal: (json['principal'] as num).toDouble(),
      interestRate: (json['interestRate'] as num?)?.toDouble() ?? 0,
      termMonths: json['termMonths'] as int? ?? 12,
      monthlyPayment: (json['monthlyPayment'] as num?)?.toDouble() ?? 0,
      totalRepayable: (json['totalRepayable'] as num?)?.toDouble() ?? 0,
      amountPaid: (json['amountPaid'] as num?)?.toDouble() ?? 0,
      balance: (json['balance'] as num?)?.toDouble() ?? 0,
      purpose: json['purpose'] as String?,
      collateral: json['collateral'] as String?,
      status: json['status'] as String? ?? 'pending',
      applicationDate: json['applicationDate'] != null
          ? DateTime.parse(json['applicationDate'] as String)
          : null,
      approvalDate: json['approvalDate'] != null
          ? DateTime.parse(json['approvalDate'] as String)
          : null,
      disbursementDate: json['disbursementDate'] != null
          ? DateTime.parse(json['disbursementDate'] as String)
          : null,
      firstPaymentDate: json['firstPaymentDate'] != null
          ? DateTime.parse(json['firstPaymentDate'] as String)
          : null,
      maturityDate: json['maturityDate'] != null
          ? DateTime.parse(json['maturityDate'] as String)
          : null,
      approvedBy: json['approvedBy'] as String?,
      notes: json['notes'] as String?,
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
    'loanProduct': loanProduct,
    'principal': principal,
    'interestRate': interestRate,
    'termMonths': termMonths,
    'monthlyPayment': monthlyPayment,
    'totalRepayable': totalRepayable,
    'amountPaid': amountPaid,
    'balance': balance,
    'purpose': purpose,
    'collateral': collateral,
    'status': status,
    'applicationDate': applicationDate?.toIso8601String(),
    'approvalDate': approvalDate?.toIso8601String(),
    'disbursementDate': disbursementDate?.toIso8601String(),
    'firstPaymentDate': firstPaymentDate?.toIso8601String(),
    'maturityDate': maturityDate?.toIso8601String(),
    'approvedBy': approvedBy,
    'notes': notes,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };
}
