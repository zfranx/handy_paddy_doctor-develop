import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:handy_paddy_doctor/app/config/app_config.dart';
import 'package:handy_paddy_doctor/app/utils/tensorflow_utils.dart';

import '../../../app/config/themes.dart';
import '../../../data/model/analysis_model.dart';
import '../component/common_widget.dart';

class HomeFloatingActionButton extends StatefulWidget {
  final VoidCallback? onPressed;

  const HomeFloatingActionButton({Key? key, this.onPressed}) : super(key: key);

  @override
  _HomeFloatingActionButtonState createState() {
    return _HomeFloatingActionButtonState();
  }
}

class _HomeFloatingActionButtonState extends State<HomeFloatingActionButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: widget.onPressed,
      child: const Icon(Icons.camera_alt),
    );
  }
}

class HomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  final VoidCallback? onMenuPressed;
  final VoidCallback? onSearchPressed;
  final GlobalKey cameraAppBarKey;

  const HomeAppBar(
      {Key? key,
      this.onMenuPressed,
      this.onSearchPressed,
      required this.cameraAppBarKey})
      : super(key: key);

  @override
  _HomeAppBarState createState() => _HomeAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _HomeAppBarState extends State<HomeAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(AppConfig.appName),
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: widget.onMenuPressed,
      ),
      actions: [
        IconButton(
          key: widget.cameraAppBarKey,
          onPressed: widget.onSearchPressed,
          icon: const Icon(Icons.camera_alt),
          padding: const EdgeInsets.only(right: 16),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class HomeBottomNavigationBar extends StatefulWidget {
  final void Function(int) onItemTapped;

  const HomeBottomNavigationBar({Key? key, required this.onItemTapped})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeBottomNavigationBarState createState() {
    return _HomeBottomNavigationBarState();
  }
}

class _HomeBottomNavigationBarState extends State<HomeBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 0,
      backgroundColor: Theme.of(context).primaryColor.withAlpha(0),
      selectedItemColor: Theme.of(context).colorScheme.onSurface,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Analisis',
        ),
      ],
      onTap: widget.onItemTapped,
    );
  }
}

class RecentImagesListItem extends StatelessWidget {
  final AnalysisModel analysis;
  final VoidCallback? onItemPressed;

  const RecentImagesListItem(
      {Key? key, required this.analysis, this.onItemPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String label = analysis.outputs?.first['label'];
    int index = analysis.outputs?.first['index'];
    return FutureBuilder(
      future: loadAssetTexts(TensorflowUtils.treatments, index ?? 0),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          String treatments = snapshot.data ?? '';
          return InkWell(
              onTap: onItemPressed,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    color: ThemeColors.darkYellow,
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            bottomLeft: Radius.circular(4),
                          ),
                          child: Image.memory(
                            analysis.image!,
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8),
                              Text(
                                label,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Padding(
                                  padding: EdgeInsets.only(right: 8.0),
                                  child: SizedBox(
                                    child: Text(
                                      'Perawatan : ${treatments}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                      maxLines: 5,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ));
        } else {
          return ShimmerLoader(
            child: Container(
              height: 150,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }
      },
    );
  }
}
