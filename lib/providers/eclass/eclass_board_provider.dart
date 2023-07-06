import 'package:hansungunivnotinoti/providers/eclass/eclass_board_state.dart';
import 'package:hansungunivnotinoti/providers/login/login_state.dart';
import 'package:hansungunivnotinoti/services/dio_method.dart';
import 'package:state_notifier/state_notifier.dart';

class EclassBoardProvider extends StateNotifier<EclassBoardState>
    with LocatorMixin {
  EclassBoardProvider() : super(EclassBoardState.initial());

  void clearBoards() {
    state = state.copyWith(eclassnotices: [], isLoading: true);
  }

  Future<void> getEclassNotices(String link) async {
    String moodlesession = read<LoginState>().moodlesession;
    List boardContents = await getBoardContents(
        await getNoticeBoard(link, moodlesession), moodlesession);
    state = state.copyWith(eclassnotices: boardContents, isLoading: false);
  }
}
