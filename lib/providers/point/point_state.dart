import 'package:equatable/equatable.dart';

class PointState extends Equatable {
  final String year;
  final String yearPoints;
  final String allPoints;
  final String cancelPoints;

  final List points;
  final bool isLoading;

  const PointState({
    required this.year,
    required this.yearPoints,
    required this.allPoints,
    required this.cancelPoints,
    required this.points,
    required this.isLoading,
  });

  factory PointState.initial() {
    return const PointState(
      year: '',
      yearPoints: '',
      allPoints: '',
      cancelPoints: '',
      points: [],
      isLoading: true,
    );
  }

  PointState copyWith({
    String? year,
    String? yearPoints,
    String? allPoints,
    String? cancelPoints,
    List? points,
    bool? isLoading,
  }) {
    return PointState(
      year: year ?? this.year,
      yearPoints: yearPoints ?? this.yearPoints,
      allPoints: allPoints ?? this.allPoints,
      cancelPoints: cancelPoints ?? this.cancelPoints,
      points: points ?? this.points,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props =>
      [year, yearPoints, allPoints, cancelPoints, points, isLoading];
}
