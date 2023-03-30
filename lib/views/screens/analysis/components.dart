import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';

import '../../../app/config/themes.dart';
import '../../../app/utils/tensorflow_utils.dart';
import '../component/common_widget.dart';

class AnalysisResults extends StatefulWidget {
  final List<dynamic> outputs;
  final Function(dynamic) onAnalysisTapped;

  const AnalysisResults(
      {Key? key, required this.outputs, required this.onAnalysisTapped})
      : super(key: key);

  @override
  _AnalysisResultsState createState() => _AnalysisResultsState();
}

class _AnalysisResultsState extends State<AnalysisResults> {
  @override
  Widget build(BuildContext context) {
    final List indexs = widget.outputs.map((e) => e['index']).toList();
    final List labels = widget.outputs.map((e) => e['label']).toList();
    List probabilities = widget.outputs.map((e) => e['confidence']).toList();
    probabilities = probabilities.map((e) => (e * 100)).toList();
    if (probabilities.first >= 95) {
      return Column(
        children: [
          const Text("Tekan hasil untuk melihat perawatan",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 16),
          AnalysisResultCard(
            output: widget.outputs.first,
            onCardTapped: widget.onAnalysisTapped,
          ),
        ],
      );
      // } else if (probabilities.first >= 50 && probabilities.first < 95) {
    } else if (probabilities.first >= 75 && probabilities.first < 95) {
      return Column(
        children: [
          const Text("Tekan hasil untuk melihat perawatan",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 16),
          AnalysisResultCard(
            output: widget.outputs.first,
            probabilityVisible: true,
            onCardTapped: widget.onAnalysisTapped,
          ),
          const SizedBox(height: 8),
          AnalysisResultCard(
            output: widget.outputs.last,
            probabilityVisible: true,
            onCardTapped: widget.onAnalysisTapped,
          ),
        ],
      );
    } else {
      return const Text(
          "Tidak dapat memprediksi penyakit, Silahkan ambil ulang gambar");
    }
  }
}

class AnalysisResultCard extends StatelessWidget {
  final dynamic output;
  final bool probabilityVisible;
  final Function(dynamic) onCardTapped;

  const AnalysisResultCard({
    Key? key,
    required this.output,
    this.probabilityVisible = false,
    required this.onCardTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String probability = (output['confidence'] * 100).toStringAsFixed(2);
    return Card(
      color: ThemeColors.darkYellowAccent,
      child: InkWell(
        onTap: () {
          onCardTapped(output);
        },
        child: Container(
          constraints: const BoxConstraints(minWidth: 150),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                output['label'],
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              probabilityVisible
                  ? Text(
                      'Probabilitas: $probability%',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

class AnalysisModalBottomSheet extends StatefulWidget {
  final dynamic output;

  const AnalysisModalBottomSheet({Key? key, required this.output})
      : super(key: key);

  @override
  _AnalysisModalBottomSheetState createState() =>
      _AnalysisModalBottomSheetState();
}

class _AnalysisModalBottomSheetState extends State<AnalysisModalBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final int index = widget.output['index'];

    return Container(
      padding: const EdgeInsets.all(16),
      color: ThemeColors.darkYellow,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Penyakit : ${widget.output['label']}',
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          const Divider(color: Colors.white),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const Text(
                  'Pencegahan',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 8),
                FutureBuilder(
                  future: loadAssetTexts(TensorflowUtils.preventions, index),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                        snapshot.data!,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 14),
                      );
                    } else {
                      return const ShimmerLoader(
                        child: Text(
                          'Loading...',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'Perawatan',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 8),
                FutureBuilder(
                  future: loadAssetTexts(TensorflowUtils.treatments, index),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                        snapshot.data!,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 14),
                      );
                    } else {
                      return const ShimmerLoader(
                        child: Text(
                          'Loading...',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
