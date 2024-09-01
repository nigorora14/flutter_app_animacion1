import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _counter = 0;
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Flutter Demo Home Page'),
        ),
        body: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _counter.toString(),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 30),
              MyHomePage(
                onPressed: _incrementCounter,
                child: const Text(
                  'push with progress',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {super.key,
      required this.child,
      required this.onPressed,
      this.duration = const Duration(milliseconds: 1000)});
  final Widget child;
  final VoidCallback onPressed;
  final Duration duration;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _progressController;
  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _progressController = AnimationController(
      vsync: this,
      duration: widget.duration,
      reverseDuration: widget.duration ~/ 2,
    );
    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onPressed();
        _progressController.reverse();
        _scaleController.reverse();
        _progressController.value = 0;
      }
    });
  }

  @override
  dispose() {
    _scaleController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 2,
      child: ScaleTransition(
        scale: Tween<double>(begin: 1, end: 0.8).animate(
          CurvedAnimation(
            parent: _scaleController,
            curve: Curves.easeInOut,
          ),
        ),
        child: LayoutBuilder(builder: (context, constraints) {
          debugPrint(constraints.maxWidth.toString());
          return AnimatedBuilder(
              animation: _progressController,
              builder: (context, snapshot) {
                return Stack(
                  children: [
                    GestureDetector(
                      onTapDown: (details) {
                        _scaleController.forward();
                        _progressController.forward();
                      },
                      onTapUp: (details) {
                        _scaleController.reverse();
                        _progressController.reverse();
                      },
                      child: DecoratedBox(
                        //width: constraints.maxWidth * 0.4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.black,
                          gradient: const LinearGradient(
                            colors: [
                              Colors.black54,
                              Colors.black87,
                              Colors.black,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          child: widget.child,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      width: constraints.maxWidth *
                          0.4 *
                          _progressController.value,
                      child: IgnorePointer(
                        child: Opacity(
                          opacity: (1 - _progressController.value * 0.5),
                          child: DecoratedBox(
                            //width: constraints.maxWidth * 0.4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.white30,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              });
        }),
      ),
    );
  }
}
