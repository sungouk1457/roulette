import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(RouletteApp());

class RouletteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random Roulette',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RoulettePage(),
    );
  }
}

class RoulettePage extends StatefulWidget {
  @override
  _RoulettePageState createState() => _RoulettePageState();
}

class _RoulettePageState extends State<RoulettePage>
    with TickerProviderStateMixin {
  AnimationController? _animationController;
  List<String> _items = [];
  String _selectedItem = '';
  bool _isSpinning = false;

  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  void _spinWheel() {
    if (!_isSpinning) {
      setState(() {
        _selectedItem = '';
        _isSpinning = true;
      });
      _animationController?.forward(from: 0.0).then((_) {
        setState(() {
          final random = Random();
          final index = random.nextInt(_items.length);
          _selectedItem = _items[index];
          _isSpinning = false;
        });
      });
    }
  }

  void _addItem() {
    final newItem = _textEditingController.text;
    if (newItem.isNotEmpty) {
      setState(() {
        _items.add(newItem);
      });
      _textEditingController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Random Roulette'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _animationController!,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _animationController!.value * 2.0 * pi,
                  child: Container(
                    width: 200.0,
                    height: 200.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                    child: Center(
                      child: Text(
                        _selectedItem,
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 30.0),
            ElevatedButton(
              onPressed: _spinWheel,
              child: Text(
                _isSpinning ? 'Spinning...' : '뽑기',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            SizedBox(height: 30.0),
            Text(
              'Enter an item:',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 200.0,
                  child: TextField(
                    controller: _textEditingController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: 'Enter item name',
                    ),
                  ),
                ),
                SizedBox(width: 10.0),
                ElevatedButton(
                  onPressed: _addItem,
                  child: Text('추가'),
                ),
              ],
            ),
            SizedBox(height: 30.0),
            Text(
              'Items:',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 10.0),
            Expanded(
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_items[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
