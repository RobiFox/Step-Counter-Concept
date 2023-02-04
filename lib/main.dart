import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: NavBar(),
      appBar: AppBar(
          backgroundColor: Colors.white,
          //title: Text(widget.title),
          leading: Container(
            width: 200,
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                    icon: const Icon(Icons.menu_outlined, color: Colors.grey))
              ],
            ),
          )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            Center(
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Row(
                  children: const [
                    SizedBox(
                      width: 16,
                    ),
                    StatsDisplay(
                        topText: "Calories",
                        bottomText: "{0}",
                        values: [444],
                        color: Colors.orangeAccent,
                        delay: 0.2),
                    SizedBox(
                      width: 16,
                    ),
                    StatsDisplay(
                      topText: "Active Time",
                      bottomText: "{0}h {1}m",
                      values: [3, 34],
                      color: Colors.blue,
                      delay: 0.6,
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    StatsDisplay(
                      topText: "Distance",
                      bottomText: "{0} km",
                      values: [7.2],
                      color: Colors.green,
                      decimalDigits: 1,
                      delay: 1,
                    ),
                    SizedBox(
                      width: 16,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            Stack(children: [
              Container(
                  width: 172,
                  height: 172,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.black12,
                    color: Colors.redAccent,
                    value: 0.8,
                    strokeWidth: 8,
                  )),
              Container(
                width: 172,
                height: 172,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "1600/2000",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text("Steps",
                          style: Theme.of(context).textTheme.titleLarge),
                      Text("of goal",
                          style: Theme.of(context).textTheme.labelLarge),
                    ],
                  ),
                ),
              ),
            ]),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: [
          ListView(
            children: [
              SizedBox(
                height: 72,
                child: DrawerHeader(
                  decoration: BoxDecoration(color: Colors.black12),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(CupertinoIcons.back),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        const SizedBox(
                          width: 32,
                        ),
                        Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              "Step Counter",
                              style: Theme.of(context).textTheme.titleLarge,
                            ))
                      ],
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.refresh),
                title: Text("Randomize Values"),
                onTap: () {},
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text("Concept App by Robi @ github.com/RobiFox"),
            ),
          ),
        ],
      ),
    );
  }
}

class StatsDisplay extends StatefulWidget {
  final String topText;
  final String bottomText;
  final List<double> values;
  final Color color;
  final int decimalDigits;
  final double delay;

  const StatsDisplay(
      {Key? key,
      required this.topText,
      required this.bottomText,
      required this.color,
      required this.values,
      this.decimalDigits = 0,
      this.delay = 0});

  @override
  State<StatsDisplay> createState() => _StatsDisplayState();
}

class _StatsDisplayState extends State<StatsDisplay>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _fadeController;
  late AnimationController _slideController;

  List<Animation> _animation = [];
  late Animation _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _fadeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    _slideController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    for (int i = 0; i < widget.values.length; i++) {
      //var tempAnimation = Tween(begin: 0.0, end: widget.values[i]).animate(_controller);
      var tempAnimation = Tween<double>(begin: 0.0, end: widget.values[i])
          .animate(
              CurvedAnimation(parent: _controller, curve: Curves.decelerate));
      _controller.addListener(() {
        setState(() {});
      });
      _animation.add(tempAnimation);
    }

    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);
    _slideAnimation = Tween<Offset>(
            begin: const Offset(0, 0.4), end: const Offset(0, 0))
        .animate(CurvedAnimation(parent: _slideController, curve: Curves.ease));

    Timer(Duration(milliseconds: (widget.delay * 1000).toInt()), () {
      setState(() {
        _controller.forward();
        _fadeController.forward();
        _slideController.forward();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  String convertText(String text, List<double> values) {
    for (int i = 0; i < values.length; i++) {
      text = text.replaceAll(
          "{$i}", values[i].toStringAsFixed(widget.decimalDigits));
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    List<double> animationValues = [];
    for (Animation animation in _animation) {
      animationValues.add(animation.value);
    }

    return Column(
      children: [
        Text(widget.topText, style: Theme.of(context).textTheme.headlineSmall),
        SlideTransition(
          position: _slideAnimation,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 1),
            opacity: _fadeAnimation.value,
            child: Text(convertText(widget.bottomText, animationValues),
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(color: widget.color)),
          ),
        )
      ],
    );
  }
}
