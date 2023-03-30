import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handy_paddy_doctor/data/model/analysis_model.dart';

import '../../../data/domain/analysis_domain.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeFetch>(_onHomeFetch);
  }
  final AnalysisDomain _analysisDomain = AnalysisDomain();

  Future<void> _onHomeFetch(HomeFetch event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
      try {
        List<AnalysisModel> recentAnalysis = await _analysisDomain.getAnalysis();
        emit(HomeLoaded(recentAnalysis));
     } catch (e) {
        emit(HomeFailure(message: e.toString()));
     }
  }
}