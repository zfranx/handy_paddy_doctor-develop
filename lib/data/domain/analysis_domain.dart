import '../dao/analysis_dao.dart';
import '../model/analysis_model.dart';

class AnalysisDomain {
  final _analysisDao = AnalysisDao();

  Future<bool> createAnalysis(AnalysisModel analysis) async {
    return await _analysisDao.createAnalysis(analysis);
  }

  Future<bool> updateAnalysis(AnalysisModel analysis) async {
    return await _analysisDao.updateAnalysis(analysis);
  }

  Future<void> deleteAnalysis(AnalysisModel analysis) async {
    return await _analysisDao.deleteAnalysis(analysis);
  }

  Future<List<AnalysisModel>> getAnalysis() async {
    return await _analysisDao.getAnalysis();
  }
}