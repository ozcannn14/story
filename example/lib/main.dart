import 'dart:math';

import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';

import 'package:story/story_page_view/story_page_view.dart';

void main() {
  runApp(MyApp());
}

class UserModel {
  UserModel(this.stories, this.userName, this.imageUrl);

  final List<StoryModel> stories;
  final String userName;
  final String imageUrl;
  final id = UniqueKey();
}

class StoryModel {
  final storyId = UniqueKey();
  final String title;
  String? imageUrl;

  String get nextVehicleUrl =>
      'https://source.unsplash.com/collection/1989985/${Random().nextInt(20) + 400}x${Random().nextInt(20) + 800}';

  StoryModel({required this.title, this.imageUrl}) {
    imageUrl = nextVehicleUrl;
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

final sampleUsers = [
  UserModel([
    StoryModel(title: "STORY-1"),
    StoryModel(title: "STORY-2"),
    StoryModel(title: "STORY-3"),
    StoryModel(title: "STORY-4"),
  ], "User1",
      "https://images.unsplash.com/photo-1609262772830-0decc49ec18c?ixid=MXwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwzMDF8fHxlbnwwfHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60"),
  UserModel([
    StoryModel(title: "STORY-2.1"),
  ], "User2",
      "https://source.unsplash.com/collection/1989985/${Random().nextInt(20) + 400}x${Random().nextInt(20) + 800}"),
  UserModel([
    StoryModel(title: "STORY-3.1"),
    StoryModel(title: "STORY-3.2"),
    StoryModel(title: "STORY-3.3"),
  ], "User3",
      "https://source.unsplash.com/collection/1989985/${Random().nextInt(20) + 400}x${Random().nextInt(20) + 800}"),
  UserModel([
    StoryModel(title: "STORY-3.1"),
    StoryModel(title: "STORY-3.2"),
    StoryModel(title: "STORY-3.3"),
  ], "User4",
      "https://source.unsplash.com/collection/1989985/${Random().nextInt(20) + 400}x${Random().nextInt(20) + 800}"),
  UserModel([
    StoryModel(title: "STORY-3.1"),
    StoryModel(title: "STORY-3.2"),
    StoryModel(title: "STORY-3.3"),
  ], "User5",
      "https://source.unsplash.com/collection/1989985/${Random().nextInt(20) + 100}x${Random().nextInt(20) + 200}"),
];

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    return Scaffold(
      body: SingleChildScrollView(
        padding: padding,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text('Dismissible', style: TextStyle(fontSize: 24)),
            ),
            SizedBox(
              height: 120,
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, int i) => StoryWidget(index: i),
                separatorBuilder: (_, int i) => SizedBox(width: 10),
                itemCount: sampleUsers.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StoryWidget extends StatelessWidget {
  final int index;

  const StoryWidget({Key? key, required this.index}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          TransparentRoute(
            backgroundColor: Colors.black.withOpacity(0.35),
            builder: (_) => StoryPage(
              startIndex: index,
            ),
          ),
        );
      },
      child: Hero(
        tag: sampleUsers[index].id,
        child: Container(
          height: 120,
          width: 88,
          padding: const EdgeInsets.all(8),
          clipBehavior: Clip.antiAlias,
          alignment: Alignment.bottomLeft,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(sampleUsers[index].imageUrl),
            ),
          ),
        ),
      ),
    );
  }
}

class StoryPage extends StatefulWidget {
  final int startIndex;
  StoryPage({
    Key? key,
    required this.startIndex,
  }) : super(key: key);

  @override
  _StoryPageState createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  late ValueNotifier<IndicatorAnimationCommand> indicatorAnimationController;

  @override
  void initState() {
    super.initState();
    indicatorAnimationController = ValueNotifier<IndicatorAnimationCommand>(
        IndicatorAnimationCommand.resume);
  }

  @override
  void dispose() {
    indicatorAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: StoryPageView(
        initialPage: widget.startIndex,
        indicatorPadding: EdgeInsets.only(top: 30, left: 10, right: 10),
        itemBuilder: (context, pageIndex, storyIndex) {
          return Stack(
            children: [
              Positioned.fill(
                child: Container(color: Colors.black),
              ),
              Positioned.fill(
                child: Image.network(
                  sampleUsers[pageIndex].stories[storyIndex].nextVehicleUrl,
                  fit: BoxFit.cover,
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(top: 50, left: 10, right: 10),
                  child: Row(
                    children: [
                      Hero(
                        tag: sampleUsers[pageIndex].id,
                        child: Container(
                          height: 32,
                          width: 32,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image:
                                  NetworkImage(sampleUsers[pageIndex].imageUrl),
                              fit: BoxFit.cover,
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        sampleUsers[pageIndex].userName,
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        gestureItemBuilder: (context, pageIndex, storyIndex) {
          return SafeArea(
            child: Stack(children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    color: Colors.white,
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              /*  if (pageIndex == 0)
                Center(
                  child: ElevatedButton(
                    child: Text('show modal bottom sheet'),
                    onPressed: () async {
                      indicatorAnimationController.value =
                          IndicatorAnimationCommand.pause;
                      await showModalBottomSheet(
                        context: context,
                        builder: (context) => SizedBox(
                          height: MediaQuery.of(context).size.height / 2,
                          child: Padding(
                            padding: EdgeInsets.all(24),
                            child: Text(
                              'Look! The indicator is now paused\n\n'
                              'It will be coutinued after closing the modal bottom sheet.',
                              style: Theme.of(context).textTheme.headline5,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                      indicatorAnimationController.value =
                          IndicatorAnimationCommand.resume;
                    },
                  ),
                ), */
            ]),
          );
        },
        indicatorAnimationController: indicatorAnimationController,
        initialStoryIndex: (pageIndex) {
          if (pageIndex == 0) {
            return 1;
          }
          return 0;
        },
        pageLength: sampleUsers.length,
        storyLength: (int pageIndex) {
          return sampleUsers[pageIndex].stories.length;
        },
        onPageLimitReached: () {
          Navigator.pop(context);
        },
        indicatorDuration: Duration(seconds: 1000),
      ),
    );
  }
}
