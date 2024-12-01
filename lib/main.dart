import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '할 일 빙고',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> _tasks = []; // 할 일 목록
  List<bool> _completedTasks = List.filled(25, false); // 빙고판의 완료 여부
  List<String?> _bingoBoard = List.filled(25, null); // 5x5 빙고판

  void _addTask(String task) {
    setState(() {
      _tasks.add(task);
    });
  }

  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String newTask = '';
        return AlertDialog(
          title: Text('할 일 추가'),
          content: TextField(
            onChanged: (text) {
              newTask = text;
            },
            decoration: InputDecoration(hintText: '할 일을 입력하세요'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _addTask(newTask);
                Navigator.of(context).pop();
              },
              child: Text('추가'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('취소'),
            ),
          ],
        );
      },
    );
  }

  bool _checkBingo() {
    List<List<int>> bingoLines = [
      [0, 1, 2, 3, 4], [5, 6, 7, 8, 9], [10, 11, 12, 13, 14], [15, 16, 17, 18, 19], [20, 21, 22, 23, 24], // 가로
      [0, 5, 10, 15, 20], [1, 6, 11, 16, 21], [2, 7, 12, 17, 22], [3, 8, 13, 18, 23], [4, 9, 14, 19, 24], // 세로
      [0, 6, 12, 18, 24], [4, 8, 12, 16, 20] // 대각선
    ];

    for (var line in bingoLines) {
      if (line.every((index) => _completedTasks[index])) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('할 일 빙고'),
      ),
      body: Column(
        children: [
          // 할 일 목록
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                return Draggable<String>(
                  data: _tasks[index],
                  child: ListTile(
                    title: Text(_tasks[index]),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _removeTask(index),
                    ),
                  ),
                  feedback: Material(
                    child: Text(
                      _tasks[index],
                      style: TextStyle(fontSize: 16, color: Colors.blue),
                    ),
                  ),
                  childWhenDragging: ListTile(
                    title: Text(
                      _tasks[index],
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                );
              },
            ),
          ),
          // 빙고판 UI
          SizedBox(
            width: 300,
            height: 300,
            child: GridView.builder(
              itemCount: 25,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemBuilder: (context, index) {
                return DragTarget<String>(
                  onAccept: (data) {
                    setState(() {
                      _bingoBoard[index] = data;
                    });
                  },
                  builder: (context, candidateData, rejectedData) {
                    return GestureDetector(
                      onTap: () {
                        if (_bingoBoard[index] != null && !_completedTasks[index]) {
                          setState(() {
                            _completedTasks[index] = true;
                          });
                          if (_checkBingo()) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('빙고!'),
                                content: Text('축하합니다! 빙고를 완성했어요!'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('확인'),
                                  ),
                                ],
                              ),
                            );
                          }
                        }
                      },
                      onLongPress: () {
                        // 길게 눌러 항목 삭제
                        setState(() {
                          _bingoBoard[index] = null;
                          _completedTasks[index] = false;
                        });
                      },
                      child: Container(
                        color: Colors.blueGrey[100],
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            if (_bingoBoard[index] != null)
                              Text(
                                _bingoBoard[index]!,
                                style: TextStyle(fontSize: 16),
                              ),
                            if (_completedTasks[index])
                              Icon(
                                Icons.circle_outlined, // "O"를 나타내는 아이콘
                                size: 40,
                                color: Colors.red,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        tooltip: '할 일 추가',
        child: Icon(Icons.add),
      ),
    );
  }
}
