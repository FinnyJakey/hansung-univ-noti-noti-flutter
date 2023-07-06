import 'package:equatable/equatable.dart';
import 'package:hansungunivnotinoti/models/nonsubject_model.dart';

class NonSubjectState extends Equatable {
  final List<NonSubjectModel> nonsubjects;
  final bool isLoading;

  const NonSubjectState({
    required this.nonsubjects,
    required this.isLoading,
  });

  factory NonSubjectState.initial() {
    return const NonSubjectState(nonsubjects: [], isLoading: true);
  }

  @override
  List<Object?> get props => [nonsubjects, isLoading];

  NonSubjectState copyWith({
    List<NonSubjectModel>? nonsubjects,
    bool? isLoading,
  }) {
    return NonSubjectState(
      nonsubjects: nonsubjects ?? this.nonsubjects,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
