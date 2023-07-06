import 'package:equatable/equatable.dart';

class ScoreState extends Equatable {
  final Map<String, dynamic> score;
  final bool isLoading;

  const ScoreState({
    required this.score,
    required this.isLoading,
  });

  factory ScoreState.initial() {
    return const ScoreState(score: {}, isLoading: true);
  }

  ScoreState copyWith({
    Map<String, dynamic>? score,
    bool? isLoading,
  }) {
    return ScoreState(
      score: score ?? this.score,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [score, isLoading];
}
