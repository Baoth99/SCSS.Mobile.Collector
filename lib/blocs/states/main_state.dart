part of '../main_bloc.dart';

class MainState extends Equatable {
  const MainState({this.screenIndex = 0});

  final int screenIndex;

  MainState copyWith({int? screenIndex}) {
    return MainState(
      screenIndex: screenIndex ?? this.screenIndex,
    );
  }

  @override
  List<int> get props => [screenIndex];
}
