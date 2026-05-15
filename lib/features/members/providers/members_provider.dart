import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/core_providers.dart';
import '../../../models/member.dart';
import '../repositories/members_repository.dart';

final membersRepositoryProvider = Provider<MembersRepository>((ref) {
  return MembersRepository(ref.watch(apiClientProvider));
});

class MembersListNotifier extends StateNotifier<AsyncValue<List<Member>>> {
  final Ref _ref;

  MembersListNotifier(this._ref) : super(const AsyncValue.data([]));

  Future<void> loadMembers({String? search}) async {
    state = const AsyncValue.loading();
    final repo = _ref.read(membersRepositoryProvider);
    final result = await repo.getMembers(search: search);
    result.when(
      success: (members) => state = AsyncValue.data(members),
      failure: (message, code, data) => state = AsyncValue.error(message, StackTrace.current),
    );
  }

  Future<void> deleteMember(String id) async {
    final repo = _ref.read(membersRepositoryProvider);
    final result = await repo.deleteMember(id);
    result.when(
      success: (_) => loadMembers(),
      failure: (message, code, data) => state = AsyncValue.error(message, StackTrace.current),
    );
  }
}

final membersListNotifierProvider =
    StateNotifierProvider<MembersListNotifier, AsyncValue<List<Member>>>((ref) {
  return MembersListNotifier(ref);
});

class MemberDetailNotifier extends StateNotifier<AsyncValue<Member?>> {
  final Ref _ref;

  MemberDetailNotifier(this._ref) : super(const AsyncValue.data(null));

  Future<void> loadMember(String id) async {
    state = const AsyncValue.loading();
    final repo = _ref.read(membersRepositoryProvider);
    final result = await repo.getMember(id);
    result.when(
      success: (member) => state = AsyncValue.data(member),
      failure: (message, code, data) => state = AsyncValue.error(message, StackTrace.current),
    );
  }
}

final memberDetailNotifierProvider =
    StateNotifierProvider<MemberDetailNotifier, AsyncValue<Member?>>((ref) {
  return MemberDetailNotifier(ref);
});

class MemberFormNotifier extends StateNotifier<AsyncValue<Member?>> {
  final Ref _ref;

  MemberFormNotifier(this._ref) : super(const AsyncValue.data(null));

  Future<void> createMember(Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    final repo = _ref.read(membersRepositoryProvider);
    final result = await repo.createMember(data);
    result.when(
      success: (member) => state = AsyncValue.data(member),
      failure: (message, code, data) => state = AsyncValue.error(message, StackTrace.current),
    );
  }

  Future<void> updateMember(String id, Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    final repo = _ref.read(membersRepositoryProvider);
    final result = await repo.updateMember(id, data);
    result.when(
      success: (member) => state = AsyncValue.data(member),
      failure: (message, code, data) => state = AsyncValue.error(message, StackTrace.current),
    );
  }
}

final memberFormNotifierProvider =
    StateNotifierProvider<MemberFormNotifier, AsyncValue<Member?>>((ref) {
  return MemberFormNotifier(ref);
});
