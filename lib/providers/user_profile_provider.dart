import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../models/user_profile.dart';
import 'isar_provider.dart';

class UserProfileNotifier extends AutoDisposeAsyncNotifier<UserProfile?> {
  @override
  Future<UserProfile?> build() async {
    final isar = await ref.watch(isarProvider.future);
    return isar.userProfiles.where().findFirst();
  }

  Future<void> saveProfile(UserProfile profile) async {
    state = const AsyncValue.loading();
    try {
      final isar = await ref.read(isarProvider.future);
      await isar.writeTxn(() async {
        await isar.userProfiles.put(profile);
      });
      state = AsyncValue.data(profile);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final userProfileNotifierProvider = AutoDisposeAsyncNotifierProvider<UserProfileNotifier, UserProfile?>(() {
  return UserProfileNotifier();
});
