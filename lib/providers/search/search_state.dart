import 'package:equatable/equatable.dart';
import 'package:hansungunivnotinoti/models/notice_model.dart';

class SearchState extends Equatable {
  final List<NoticeModel> notices;
  final bool isLoading;

  const SearchState({
    required this.notices,
    required this.isLoading,
  });

  factory SearchState.initial() {
    return const SearchState(notices: [], isLoading: true);
  }

  @override
  List<Object?> get props => [notices, isLoading];

  SearchState copyWith({
    List<NoticeModel>? notices,
    bool? isLoading,
  }) {
    return SearchState(
      notices: notices ?? this.notices,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
