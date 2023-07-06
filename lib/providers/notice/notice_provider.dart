import 'package:state_notifier/state_notifier.dart';

import '../../models/notice_model.dart';
import '../../services/dio_method.dart';
import 'notice_state.dart';

class NoticeProvider extends StateNotifier<NoticeState> {
  NoticeProvider() : super(NoticeState.initial());

  void clearNotices() {
    state = state.copyWith(notices: [], isLoading: true);
  }

  Future<void> getGeneralNotices({required int page}) async {
    List<NoticeModel> notices = [];

    // Existing Notices
    notices.addAll(state.notices);

    // Fixed Notices
    if (page == 1) {
      notices.addAll(await hansungFixedNotice());
    }

    // Notices
    notices.addAll(await hansungNotice("", page));

    if (notices.length == state.notices.length) {
      state = state.copyWith(isLoading: false);
    }

    state = state.copyWith(notices: notices);
  }
}
