import 'package:hansungunivnotinoti/models/nonsubject_model.dart';
import 'package:hansungunivnotinoti/providers/nonsubject/nonsubject_state.dart';
import 'package:state_notifier/state_notifier.dart';

import '../../services/dio_method.dart';

class NonSubjectProvider extends StateNotifier<NonSubjectState> {
  NonSubjectProvider() : super(NonSubjectState.initial());

  void clearNonSubjects() {
    state = state.copyWith(nonsubjects: [], isLoading: true);
  }

  Future<void> getGeneralNonSubjects({
    required int page,
  }) async {
    List<NonSubjectModel> nonsubjects = [];

    // Existing NonSubjects
    nonsubjects.addAll(state.nonsubjects);

    // NonSubjects
    nonsubjects.addAll(await nonSubjectProgram(page));

    if (nonsubjects.length == state.nonsubjects.length) {
      state = state.copyWith(isLoading: false);
    }

    state = state.copyWith(nonsubjects: nonsubjects);
  }
}
