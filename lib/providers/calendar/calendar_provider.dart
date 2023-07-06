import 'package:hansungunivnotinoti/providers/calendar/calendar_state.dart';
import 'package:hansungunivnotinoti/services/dio_method.dart';
import 'package:state_notifier/state_notifier.dart';

class CalendarProvider extends StateNotifier<CalendarState> {
  CalendarProvider() : super(CalendarState.initial());

  void clearSchedules() {
    state = state.copyWith(schedules: [], isLoading: true);
  }

  Future<void> getSchedules({required String year}) async {
    state = state.copyWith(
        schedules: await academicSchedule(year), isLoading: false);
  }
}
