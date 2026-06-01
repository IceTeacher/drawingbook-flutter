import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/models/common_models.dart';
import '../data/home_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this._repository) : super(const HomeState()) {
    on<HomeStarted>(_onStarted);
    on<HomeTalentMoreRequested>(_onTalentMoreRequested);
  }

  final HomeRepository _repository;

  Future<void> _onStarted(HomeStarted event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.loading, errorMessage: ''));
    try {
      final payload = await _repository.loadInitial();
      emit(
        state.copyWith(
          status: HomeStatus.success,
          goodBooks: payload.goodBooks,
          bookLists: payload.bookLists,
          leaderboards: payload.leaderboards,
          categories: payload.categories,
          talentGoods: payload.talentGoods,
          talentPosition: 0,
          hasMoreTalent: payload.talentGoods.length == 10,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: HomeStatus.failure,
          errorMessage: '首页加载失败：$error',
        ),
      );
    }
  }

  Future<void> _onTalentMoreRequested(
    HomeTalentMoreRequested event,
    Emitter<HomeState> emit,
  ) async {
    if (state.isLoadingMoreTalent || !state.hasMoreTalent) {
      return;
    }
    emit(state.copyWith(isLoadingMoreTalent: true));
    try {
      final nextPosition = state.talentPosition + 10;
      final more = await _repository.fetchTalentGoods(nextPosition);
      emit(
        state.copyWith(
          talentGoods: [...state.talentGoods, ...more],
          talentPosition: nextPosition,
          hasMoreTalent: more.length == 10,
          isLoadingMoreTalent: false,
        ),
      );
    } catch (_) {
      emit(state.copyWith(isLoadingMoreTalent: false));
    }
  }
}
