import 'package:flutter/material.dart';
import 'package:flutter_youtube_ui/data.dart';
import 'package:flutter_youtube_ui/screens/home_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_youtube_ui/screens/video_screen.dart';
import 'package:miniplayer/miniplayer.dart';

final selectedVideoProvider = StateProvider<Video?>((ref) => null);
final miniPlayerControllerProvider =
    StateProvider.autoDispose<MiniplayerController>(
        (ref) => MiniplayerController());

class NavScreen extends StatefulWidget {
  const NavScreen({Key? key}) : super(key: key);

  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  static const double _playerMinHeight = 60.0;
  int _selectedIndex = 0;
  final _screens = [
    HomePage(),
    const Scaffold(
      body: Center(
        child: Text("Explore"),
      ),
    ),
    const Scaffold(
      body: Center(
        child: Text("Add"),
      ),
    ),
    const Scaffold(
      body: Center(
        child: Text("Subscriptions"),
      ),
    ),
    const Scaffold(
      body: Center(
        child: Text("Library"),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context, watch, _) {
          final selectVideo = watch(selectedVideoProvider).state;
          final miniPlayerController = watch(miniPlayerControllerProvider).state;
          print(selectVideo);
          return Stack(
            children: _screens
                .asMap()
                .map((i, screen) => MapEntry(
                      i,
                      Offstage(
                        offstage: _selectedIndex != i,
                        child: screen,
                      ),
                    ))
                .values
                .toList()
              ..add(
                Offstage(
                  offstage: selectVideo == null,
                  child: Miniplayer(
                    controller: miniPlayerController,
                    maxHeight: MediaQuery.of(context).size.height,
                    minHeight: _playerMinHeight,
                    builder: (height, percentage) {
                      if (selectVideo == null) return const SizedBox.shrink();
                      if (height <= _playerMinHeight + 50.0)
                        return Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Image.network(
                                  selectVideo.thumbnailUrl,
                                  height: _playerMinHeight - 4.0,
                                  width: 120.0,
                                  fit: BoxFit.cover,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            selectVideo.title,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w500),
                                          ),
                                        ),
                                        Flexible(
                                          child: Text(
                                            selectVideo.author.username,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.w500),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.play_arrow)),
                                IconButton(
                                    onPressed: () {
                                      context
                                          .read(selectedVideoProvider)
                                          .state = null;
                                    },
                                    icon: Icon(Icons.close)),
                              ],
                            ),
                            const LinearProgressIndicator(
                              value: 0.4,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.red,
                              ),
                            )
                          ],
                        ),
                      );
                      return VideoScreen();
                    },
                  ),
                ),
              ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 10.0,
          unselectedFontSize: 10.0,
          currentIndex: _selectedIndex,
          onTap: (i) => setState(
                () {
                  _selectedIndex = i;
                },
              ),
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: 'Home',
                activeIcon: Icon(Icons.home)),
            BottomNavigationBarItem(
                icon: Icon(Icons.explore_outlined),
                label: 'Explore',
                activeIcon: Icon(Icons.explore)),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_circle_outline),
                label: 'Add',
                activeIcon: Icon(Icons.add_circle)),
            BottomNavigationBarItem(
                icon: Icon(Icons.subscriptions_outlined),
                label: 'Subscriptions',
                activeIcon: Icon(Icons.subscriptions)),
            BottomNavigationBarItem(
                icon: Icon(Icons.video_library_outlined),
                label: 'Library',
                activeIcon: Icon(Icons.video_library)),
          ]),
    );
  }
}
