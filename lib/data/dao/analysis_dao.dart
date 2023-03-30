import 'package:flutter/cupertino.dart';
import 'package:handy_paddy_doctor/app/utils/hive_utills.dart';
import 'package:hive_flutter/adapters.dart';

import '../model/analysis_model.dart';

class AnalysisDao {
  final HiveUtils dbProvider;
  AnalysisDao() : dbProvider = HiveUtils(HiveBox.analysis);

  Future<bool> createAnalysis(AnalysisModel analysis) async {
    final Box db = await dbProvider.dataBox;
    await db.add(analysis);
    return true;
  }

  Future<bool> updateAnalysis(AnalysisModel analysis) async {
    final Box db = await dbProvider.dataBox;
    await db.put(analysis.key, analysis);
    return true;
  }

  Future<void> deleteAnalysis(AnalysisModel analysis) async {
    final Box db = await dbProvider.dataBox;
    await db.delete(analysis.key);
  }

  Future<List<AnalysisModel>> getAnalysis() async {
    final Box db = await dbProvider.dataBox;
    final maps = db.values;
    return maps.toList().cast<AnalysisModel>();
  }
}