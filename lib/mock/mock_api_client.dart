import '../core/network/api_client.dart';
import '../core/network/api_exception.dart';
import '../models/user.dart';
import '../models/transaction.dart';
import '../models/loan_repayment.dart';

class MockApiClient implements ApiClient {
  final _storage = <String, String>{};
  int _idCounter = 0;
  String _nextId() => (++_idCounter).toString();

  String? _token;

  @override
  Future<Map<String, dynamic>> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    await Future.delayed(const Duration(milliseconds: 400));
    switch (path) {
      case '/dashboard/summary':
        return _dashboardSummary();
      case '/members':
        return {'data': _mockMembers()};
      case var p when p.startsWith('/members/') && !p.endsWith('/edit'):
        final id = p.split('/').last;
        return {'data': _mockMember(id)};
      case '/savings':
        return {'data': _mockSavingsAccounts()};
      case var p when RegExp(r'^/savings/[^/]+$').hasMatch(p):
        final id = p.split('/').last;
        return {'data': _mockSavingsAccount(id)};
      case var p when RegExp(r'^/savings/[^/]+/transactions$').hasMatch(p):
        return {'data': _mockTransactions()};
      case '/loans':
        return {'data': _mockLoans()};
      case var p when RegExp(r'^/loans/[^/]+$').hasMatch(p):
        final id = p.split('/').last;
        return {'data': _mockLoan(id)};
      case var p when RegExp(r'^/loans/[^/]+/repayments$').hasMatch(p):
        return {'data': _mockRepayments()};
      default:
        throw ApiException(message: 'Mock: unknown GET $path');
    }
  }

  @override
  Future<Map<String, dynamic>> post(String path, {dynamic data}) async {
    await Future.delayed(const Duration(milliseconds: 400));
    switch (path) {
      case '/auth/login':
        _token = 'mock_token_${_nextId()}';
        _storage['auth_token'] = _token!;
        return {
          'token': _token,
          'user': _mockUser().toJson(),
        };
      case '/auth/register':
        _token = 'mock_token_${_nextId()}';
        _storage['auth_token'] = _token!;
        return {
          'token': _token,
          'user': _mockUser().toJson(),
        };
      case '/auth/logout':
        _token = null;
        _storage.remove('auth_token');
        return {'data': null};
      case '/members':
        final m = data as Map<String, dynamic>;
        return {'data': _mockMember('new', overrides: m)};
      case var p when p.startsWith('/savings/') && p.endsWith('/deposit'):
        return {
          'data': _mockTransaction('deposit',
                  amount: (data as Map)['amount'] as num)
              .toJson()
        };
      case var p when p.startsWith('/savings/') && p.endsWith('/withdraw'):
        return {
          'data': _mockTransaction('withdrawal',
                  amount: (data as Map)['amount'] as num)
              .toJson()
        };
      case '/loans':
        return {
          'data': _mockLoan('new', overrides: data as Map<String, dynamic>?)
        };
      case var p when RegExp(r'^/loans/[^/]+/repay$').hasMatch(p):
        final d = data as Map<String, dynamic>;
        return {
          'data': _mockRepayment(
            amount: (d['amount'] as num).toDouble(),
            paymentMethod: d['paymentMethod'] as String?,
          ).toJson(),
        };
      default:
        throw ApiException(message: 'Mock: unknown POST $path');
    }
  }

  @override
  Future<Map<String, dynamic>> put(String path, {dynamic data}) async {
    await Future.delayed(const Duration(milliseconds: 400));
    switch (path) {
      case var p when RegExp(r'^/loans/[^/]+/approve$').hasMatch(p):
        return {'data': _mockLoanStatus('approved')};
      case var p when RegExp(r'^/loans/[^/]+/reject$').hasMatch(p):
        return {'data': _mockLoanStatus('rejected')};
      case var p when RegExp(r'^/members/[^/]+$').hasMatch(p):
        return {
          'data': _mockMember(path.split('/').last,
              overrides: data as Map<String, dynamic>?)
        };
      default:
        throw ApiException(message: 'Mock: unknown PUT $path');
    }
  }

  @override
  Future<Map<String, dynamic>> delete(String path) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return {'data': null};
  }

  User _mockUser() => User(
        id: _nextId(),
        email: 'admin@sacco.com',
        fullName: 'Admin User',
        phone: '+254712345678',
        role: 'admin',
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      );

  List<Map<String, dynamic>> _mockMembers() => [
        _mockMember('1', overrides: {
          'firstName': 'John',
          'lastName': 'Kamau',
          'idNumber': '12345678',
          'phone': '+254712345601',
          'email': 'john.kamau@email.com',
          'occupation': 'Teacher',
          'employer': 'Ministry of Education',
          'monthlyIncome': 85000,
          'kraPin': 'A001234567P',
          'status': 'active',
        }),
        _mockMember('2', overrides: {
          'firstName': 'Grace',
          'lastName': 'Wanjiku',
          'idNumber': '23456789',
          'phone': '+254723456702',
          'email': 'grace.wanjiku@email.com',
          'occupation': 'Business Owner',
          'employer': 'Self Employed',
          'monthlyIncome': 120000,
          'kraPin': 'A002345678Q',
          'status': 'active',
        }),
        _mockMember('3', overrides: {
          'firstName': 'Peter',
          'lastName': 'Ochieng',
          'idNumber': '34567890',
          'phone': '+254734567803',
          'email': 'peter.ochieng@email.com',
          'occupation': 'Farmer',
          'employer': 'Self Employed',
          'monthlyIncome': 45000,
          'kraPin': 'A003456789R',
          'status': 'active',
        }),
      ];

  Map<String, dynamic> _mockMember(String id,
      {Map<String, dynamic>? overrides}) {
    final now = DateTime.now();
    return {
      'id': id,
      'firstName': 'Default',
      'lastName': 'Member',
      'idNumber': '00000000',
      'phone': '+254700000000',
      'email': 'member@sacco.com',
      'dateOfBirth': DateTime(1990, 1, 15).toIso8601String(),
      'gender': 'Male',
      'address': '123 Main Street, Nairobi',
      'occupation': 'Employed',
      'employer': 'ABC Company',
      'monthlyIncome': 75000,
      'kraPin': 'A000000000P',
      'status': 'active',
      'photoUrl': null,
      'createdAt': now.subtract(const Duration(days: 60)).toIso8601String(),
      'updatedAt': now.toIso8601String(),
      ...?overrides,
    };
  }

  List<Map<String, dynamic>> _mockSavingsAccounts() => [
        _mockSavingsAccount('1', overrides: {
          'memberName': 'John Kamau',
          'accountNumber': 'SAV-001',
          'balance': 250000,
          'interestRate': 3.5,
        }),
        _mockSavingsAccount('2', overrides: {
          'memberName': 'Grace Wanjiku',
          'accountNumber': 'SAV-002',
          'balance': 500000,
          'interestRate': 4.0,
        }),
        _mockSavingsAccount('3', overrides: {
          'memberName': 'Peter Ochieng',
          'accountNumber': 'SAV-003',
          'balance': 85000,
          'interestRate': 3.0,
        }),
      ];

  Map<String, dynamic> _mockSavingsAccount(String id,
      {Map<String, dynamic>? overrides}) {
    final now = DateTime.now();
    return {
      'id': id,
      'memberId': id,
      'memberName': 'Default Member',
      'accountNumber': 'SAV-000',
      'balance': 100000,
      'interestRate': 3.5,
      'status': 'active',
      'openedDate': now.subtract(const Duration(days: 180)).toIso8601String(),
      'lastTransactionDate':
          now.subtract(const Duration(days: 1)).toIso8601String(),
      'createdAt': now.subtract(const Duration(days: 180)).toIso8601String(),
      'updatedAt': now.toIso8601String(),
      ...?overrides,
    };
  }

  List<Map<String, dynamic>> _mockTransactions() => [
        _mockTransaction('deposit', amount: 50000).toJson(),
        _mockTransaction('withdrawal', amount: 20000).toJson(),
        _mockTransaction('deposit', amount: 100000).toJson(),
        _mockTransaction('withdrawal', amount: 5000).toJson(),
      ];

  Transaction _mockTransaction(String type, {num amount = 10000}) {
    final now = DateTime.now();
    return Transaction(
      id: _nextId(),
      accountId: '1',
      memberId: '1',
      memberName: 'John Kamau',
      type: type,
      amount: amount.toDouble(),
      balanceBefore: 200000,
      balanceAfter: type == 'deposit'
          ? 200000 + amount.toDouble()
          : 200000 - amount.toDouble(),
      description: type == 'deposit' ? 'Salary deposit' : 'ATM withdrawal',
      reference: 'REF-${_nextId().padLeft(6, '0')}',
      paymentMethod: 'MPesa',
      status: 'completed',
      processedBy: 'System',
      date: now,
      createdAt: now,
    );
  }

  List<Map<String, dynamic>> _mockLoans() => [
        _mockLoan('1', overrides: {
          'memberName': 'John Kamau',
          'loanProduct': 'Normal Loan',
          'principal': 500000,
          'interestRate': 12.0,
          'termMonths': 12,
          'monthlyPayment': 46800,
          'totalRepayable': 561600,
          'amountPaid': 140400,
          'balance': 421200,
          'status': 'active',
        }),
        _mockLoan('2', overrides: {
          'memberName': 'Grace Wanjiku',
          'loanProduct': 'Business Loan',
          'principal': 1000000,
          'interestRate': 14.0,
          'termMonths': 24,
          'monthlyPayment': 53000,
          'totalRepayable': 1272000,
          'amountPaid': 0,
          'balance': 1000000,
          'status': 'pending',
        }),
        _mockLoan('3', overrides: {
          'memberName': 'Peter Ochieng',
          'loanProduct': 'Emergency Loan',
          'principal': 50000,
          'interestRate': 10.0,
          'termMonths': 6,
          'monthlyPayment': 8800,
          'totalRepayable': 52800,
          'amountPaid': 52800,
          'balance': 0,
          'status': 'paid',
        }),
      ];

  Map<String, dynamic> _mockLoan(String id, {Map<String, dynamic>? overrides}) {
    final now = DateTime.now();
    return {
      'id': id,
      'memberId': id,
      'memberName': 'Default Member',
      'loanProduct': 'Normal Loan',
      'principal': 200000,
      'interestRate': 12.0,
      'termMonths': 12,
      'monthlyPayment': 18700,
      'totalRepayable': 224400,
      'amountPaid': 0,
      'balance': 200000,
      'purpose': 'School fees',
      'collateral': 'Land deed',
      'status': 'pending',
      'applicationDate':
          now.subtract(const Duration(days: 5)).toIso8601String(),
      'approvalDate': null,
      'disbursementDate': null,
      'firstPaymentDate': null,
      'maturityDate': null,
      'approvedBy': null,
      'notes': null,
      'createdAt': now.subtract(const Duration(days: 5)).toIso8601String(),
      'updatedAt': now.toIso8601String(),
      ...?overrides,
    };
  }

  Map<String, dynamic> _mockLoanStatus(String status) {
    final loan = _mockLoan('1');
    loan['status'] = status;
    if (status == 'approved') {
      loan['approvalDate'] = DateTime.now().toIso8601String();
      loan['approvedBy'] = 'Admin User';
    }
    return loan;
  }

  List<Map<String, dynamic>> _mockRepayments() => [
        _mockRepayment(
                amount: 46800,
                dueDate: DateTime.now().subtract(const Duration(days: 5)),
                status: 'paid',
                paidDate: DateTime.now().subtract(const Duration(days: 3)))
            .toJson(),
        _mockRepayment(
                amount: 46800,
                dueDate: DateTime.now().subtract(const Duration(days: 35)),
                status: 'paid',
                paidDate: DateTime.now().subtract(const Duration(days: 33)))
            .toJson(),
        _mockRepayment(
                amount: 46800,
                dueDate: DateTime.now().subtract(const Duration(days: 65)),
                status: 'paid',
                paidDate: DateTime.now().subtract(const Duration(days: 63)))
            .toJson(),
        _mockRepayment(
                amount: 46800,
                dueDate: DateTime.now().add(const Duration(days: 25)),
                status: 'pending')
            .toJson(),
      ];

  LoanRepayment _mockRepayment({
    double amount = 46800,
    String? paymentMethod,
    DateTime? dueDate,
    String status = 'pending',
    DateTime? paidDate,
  }) {
    final now = DateTime.now();
    return LoanRepayment(
      id: _nextId(),
      loanId: '1',
      amount: amount,
      principalPaid: amount * 0.7,
      interestPaid: amount * 0.3,
      penaltyPaid: null,
      balanceAfter: status == 'paid' ? 500000 - amount : 500000,
      dueDate: dueDate ?? now.add(const Duration(days: 30)),
      paidDate: paidDate,
      status: status,
      paymentMethod: paymentMethod ?? 'MPesa',
      reference: 'REF-${_nextId().padLeft(6, '0')}',
      notes: null,
      createdAt: paidDate ?? now,
    );
  }

  Map<String, dynamic> _dashboardSummary() {
    return {
      'totalMembers': 3,
      'activeLoans': 1,
      'totalSavings': 835000.0,
      'totalLoanPortfolio': 1500000.0,
      'totalDisbursed': 500000.0,
      'totalRepaid': 140400.0,
      'monthlySavings': {
        'Jan': 50000,
        'Feb': 75000,
        'Mar': 60000,
        'Apr': 90000,
        'May': 120000,
        'Jun': 85000,
      },
      'monthlyDisbursements': {
        'Jan': 100000,
        'Feb': 50000,
        'Mar': 200000,
        'Apr': 0,
        'May': 150000,
        'Jun': 0,
      },
    };
  }
}
