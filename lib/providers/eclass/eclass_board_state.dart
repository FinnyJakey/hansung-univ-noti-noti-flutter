import 'package:equatable/equatable.dart';

class EclassBoardState extends Equatable {
  final List eclassnotices;
  final bool isLoading;

  const EclassBoardState({
    required this.eclassnotices,
    required this.isLoading,
  });

  factory EclassBoardState.initial() {
    return const EclassBoardState(eclassnotices: [], isLoading: true);
  }

  EclassBoardState copyWith({
    List? eclassnotices,
    bool? isLoading,
  }) {
    return EclassBoardState(
      eclassnotices: eclassnotices ?? this.eclassnotices,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [eclassnotices, isLoading];
}
