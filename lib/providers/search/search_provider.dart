import 'package:state_notifier/state_notifier.dart';

import '../../models/notice_model.dart';
import '../../services/dio_method.dart';
import 'search_state.dart';

class SearchProvider extends StateNotifier<SearchState> {
  SearchProvider() : super(SearchState.initial());

  void clearNotices() {
    state = state.copyWith(notices: [], isLoading: true);
  }

  Future<void> getSpecificNotices({
    required String srchWrd,
    required int page,
  }) async {
    List<NoticeModel> notices = [];

    // Existing Notices
    notices.addAll(state.notices);

    // Notices
    notices.addAll(await hansungNotice(srchWrd, page));

    if (notices.length == state.notices.length) {
      state = state.copyWith(isLoading: false);
    }

    state = state.copyWith(notices: notices);
  }
}
