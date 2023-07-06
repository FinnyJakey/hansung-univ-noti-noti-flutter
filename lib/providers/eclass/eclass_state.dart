import 'package:equatable/equatable.dart';

class EclassState extends Equatable {
  final List eclass;
  final bool isLoading;

  const EclassState({
    required this.eclass,
    required this.isLoading,
  });

  factory EclassState.initial() {
    return const EclassState(eclass: [], isLoading: true);
  }

  EclassState copyWith({
    List? eclass,
    bool? isLoading,
  }) {
    return EclassState(
      eclass: eclass ?? this.eclass,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [eclass, isLoading];
}
