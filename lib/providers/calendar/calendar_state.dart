import 'package:equatable/equatable.dart';

class CalendarState extends Equatable {
  final List schedules;
  final bool isLoading;

  const CalendarState({
    required this.schedules,
    required this.isLoading,
  });

  factory CalendarState.initial() {
    return const CalendarState(schedules: [], isLoading: true);
  }

  CalendarState copyWith({
    List? schedules,
    bool? isLoading,
  }) {
    return CalendarState(
      schedules: schedules ?? this.schedules,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [schedules, isLoading];
}
