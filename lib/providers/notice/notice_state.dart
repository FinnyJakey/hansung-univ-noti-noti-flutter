import 'package:equatable/equatable.dart';
import 'package:hansungunivnotinoti/models/notice_model.dart';

class NoticeState extends Equatable {
  final List<NoticeModel> notices;
  final bool isLoading;

  const NoticeState({
    required this.notices,
    required this.isLoading,
  });

  factory NoticeState.initial() {
    return const NoticeState(notices: [], isLoading: true);
  }

  @override
  List<Object?> get props => [notices, isLoading];

  NoticeState copyWith({
    List<NoticeModel>? notices,
    bool? isLoading,
  }) {
    return NoticeState(
      notices: notices ?? this.notices,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
