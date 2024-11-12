import 'package:flutter/material.dart';
import 'package:flutter_application_interface/imageList.dart';
import 'package:flutter_application_interface/videoWidget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  ///value at which the picture 'slaskie' should change
  int valueOffsetLimit = 90;
  final ScrollController _scrollController = ScrollController();

  ///track changes for button 'Platne'
  ValueNotifier<bool> tapPlatne = ValueNotifier<bool>(true);

  ///track changes for button 'Bezplatne'
  ValueNotifier<bool> tapBezplatne = ValueNotifier<bool>(false);

  ///track notifire scroll for active another scroll list
  ValueNotifier<bool> canScrollDown = ValueNotifier<bool>(false);

  ///value that when checked to be greater than 2 allows the value of canScrollDown to change
  int counterScroll = 0;

  /// check if the FloatingActionButton is show or not
  ValueNotifier<bool> showFloatingActionButton = ValueNotifier<bool>(false);

  ///height for list image box
  double heightImageList = 0;

  bool checkisLandscape = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// interface for buttons 'platne' and 'bezplatne'
  Widget buttonCostInterface(bool platne) {
    return ValueListenableBuilder(
        valueListenable: platne ? tapPlatne : tapBezplatne,
        builder: (context, valueTap, child) {
          return Container(
            width: 90,
            height: MediaQuery.of(context).size.height < 400
                ? MediaQuery.of(context).size.height * 0.08
                : MediaQuery.of(context).size.height * 0.04,
            decoration: BoxDecoration(
              color: valueTap ? Colors.purple[200] : Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: Text(
                platne ? 'Płatne' : 'Bezpłatne',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: valueTap ? Colors.white : Colors.black),
              ),
            ),
          );
        });
  }

  ///interface for list image box, call ImageList and create button 'up' in the end
  Widget interfaceList() {
    return Stack(
      children: [
        Container(
          color: Colors.grey[300],
          child: Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: const ImageList(),
          ),
        ),
        ValueListenableBuilder(
            valueListenable: showFloatingActionButton,
            builder: (context, valueAction, child) {
              return Visibility(
                visible: valueAction,
                child: const Positioned(
                  bottom: 20,
                  right: 20,
                  child: FloatingActionButton(
                    onPressed: null,
                    backgroundColor: Colors.blue,
                    shape: CircleBorder(
                      side: BorderSide(width: 2, color: Colors.transparent),
                    ),
                    child: Icon(
                      size: 30,
                      Icons.keyboard_arrow_up_sharp,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            }),
      ],
    );
  }

  ///interface for all buttons on footer
  Widget buttonFooter(String textTitle, IconData icon) {
    return InkWell(
      onTap: null,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            size: 30,
            icon,
            color: Colors.black,
          ),
          Text(
            textTitle,
            style: const TextStyle(fontSize: 10),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    heightImageList = MediaQuery.of(context).size.height * 0.6;
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    if (checkisLandscape != isLandscape) {
      checkisLandscape = isLandscape;
      canScrollDown.value = false;
    }
    return Scaffold(
      // listener for scrolling video
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (mounted) {
            if (!canScrollDown.value) {
              if (scrollInfo.metrics.pixels >=
                      scrollInfo.metrics.maxScrollExtent &&
                  counterScroll > 2) {
                Future.delayed(const Duration(milliseconds: 500), () {
                  counterScroll = 0;
                  canScrollDown.value = true;
                });
              } else if (scrollInfo.metrics.pixels >=
                      scrollInfo.metrics.maxScrollExtent &&
                  counterScroll <= 2) {
                counterScroll++;
              } else {
                counterScroll = 0;
              }
            }
            if (scrollInfo.metrics.pixels >=
                scrollInfo.metrics.maxScrollExtent) {
              showFloatingActionButton.value = true;
            } else {
              showFloatingActionButton.value = false;
            }
            if (canScrollDown.value) {
              canScrollDown.value = false;
            }
          }
          return true;
        },
        child: CustomScrollView(
          controller: isLandscape ? _scrollController : null,
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Colors.white,
              leading: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white.withOpacity(0.5),
                      child: Icon(
                        size: 30,
                        Icons.menu,
                        color: Colors.blue[800],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white.withOpacity(0.5),
                        child: Icon(
                          size: 30,
                          Icons.favorite_border,
                          color: Colors.blue[800],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(right: 10),
                      ),
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white.withOpacity(0.5),
                        child: Icon(
                          size: 30,
                          Icons.search,
                          color: Colors.blue[800],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              expandedHeight: MediaQuery.of(context).size.height * 0.4,
              floating: false,
              pinned: true,
              flexibleSpace: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final double offset = constraints.maxHeight - kToolbarHeight;
                  return Container(
                    transform: Matrix4.translationValues(0, 5, 0.0),
                    color: Colors.white,
                    child: FlexibleSpaceBar(
                      title: Container(
                        padding: const EdgeInsets.only(right: 50),
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        height: 35,
                        child: Image(
                          image: AssetImage(offset < valueOffsetLimit
                              ? 'assets/logo_slaskie.png'
                              : 'assets/logo_white.png'),
                        ),
                      ),
                      background: const VideoWidget(),
                    ),
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: 50,
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(100),
                                  bottomRight: Radius.circular(100),
                                ),
                              ),
                              child: ValueListenableBuilder(
                                  valueListenable: canScrollDown,
                                  builder: (context, arrowPosition, child) {
                                    return Icon(
                                      size: 30,
                                      arrowPosition
                                          ? Icons.keyboard_arrow_up_outlined
                                          : Icons.keyboard_arrow_down_outlined,
                                      color: Colors.white,
                                    );
                                  }),
                            ),
                          ],
                        ),
                        const Text(
                          'Polecane',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        const Padding(padding: EdgeInsets.only(bottom: 15)),
                        Row(
                          children: [
                            InkWell(
                                onTap: () {
                                  tapPlatne.value = !tapPlatne.value;
                                },
                                child: buttonCostInterface(true)),
                            const Padding(
                              padding: EdgeInsets.only(right: 15),
                            ),
                            InkWell(
                                onTap: () {
                                  tapBezplatne.value = !tapBezplatne.value;
                                },
                                child: buttonCostInterface(false)),
                          ],
                        ),
                        const Padding(padding: EdgeInsets.only(bottom: 15)),
                      ]),
                ),
              ),
            ),
            SliverToBoxAdapter(
              //verification orientation if yes scroll all list with video together
              child: LayoutBuilder(builder: (context, constraints) {
                return !isLandscape
                    ? SizedBox(
                        height: heightImageList,
                        // listener for scroll list image
                        child: NotificationListener<ScrollNotification>(
                          onNotification: (ScrollNotification scrollInfo) {
                            if (mounted) {
                              if (canScrollDown.value) {
                                if (scrollInfo.metrics.pixels == 0 &&
                                    counterScroll > 2) {
                                  Future.delayed(
                                      const Duration(milliseconds: 500), () {
                                    canScrollDown.value = false;
                                    counterScroll = 0;
                                  });
                                } else if (scrollInfo.metrics.pixels == 0 &&
                                    counterScroll <= 2) {
                                  counterScroll++;
                                } else {
                                  counterScroll = 0;
                                }
                              }
                              if (scrollInfo.metrics.pixels >=
                                  scrollInfo.metrics.maxScrollExtent) {
                                showFloatingActionButton.value = true;
                              } else {
                                showFloatingActionButton.value = false;
                              }
                              if (!canScrollDown.value) {
                                canScrollDown.value = true;
                              }
                            }

                            return true;
                          },
                          child: ValueListenableBuilder(
                              valueListenable: canScrollDown,
                              builder: (context, canScrollingValue, child) {
                                return LayoutBuilder(
                                    builder: (context, constraints) {
                                  return SingleChildScrollView(
                                    controller: _scrollController,
                                    physics: canScrollingValue
                                        ? const AlwaysScrollableScrollPhysics()
                                        : const NeverScrollableScrollPhysics(),
                                    child: interfaceList(),
                                  );
                                });
                              }),
                        ),
                      )
                    : interfaceList();
              }),
            ),
          ],
        ),
      ),
      // footer
      bottomNavigationBar: Container(
        height: 70,
        color: Colors.grey[350],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buttonFooter('Śląskie.', Icons.home),
            buttonFooter('Aktualności', Icons.list_alt_rounded),
            buttonFooter('Wydarzenia', Icons.calendar_month),
            buttonFooter('Eksploruj', Icons.map),
          ],
        ),
      ),
    );
  }
}
