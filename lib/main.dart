import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '할 일 목록',
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
  // 할 일 목록을 저장할 리스트
  List<String> _tasks = [];
  List<String?> _bingoBoard = List.filled(25, null); // 5x5 빙고판 (null로 초기화)

  // 할 일 추가하는 함수
  void _addTask(String task) {
    setState(() {
      _tasks.add(task); // 새 할 일을 리스트에 추가
    });
  }

  // 할 일 삭제하는 함수
  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index); // 리스트에서 해당 항목 삭제
    });
  }

  // 할 일 추가 화면을 띄우는 함수
  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                _addTask(newTask); // 입력한 할 일 추가
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: Text('추가'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: Text('취소'),
            ),
          ],
        );
      },
    );
  }

  // 빙고판에 할 일 배치하는 함수
  void _placeTaskOnBingoBoard(String task) {
    // 빈 칸에 할 일 배치
    for (int i = 0; i < _bingoBoard.length; i++) {
      if (_bingoBoard[i] == null) {
        setState(() {
          _bingoBoard[i] = task; // 첫 번째 빈 칸에 할 일 배치
        });
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('할 일 목록'),
      ),
      body: Column(
        children: [
          // 할 일 목록
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_tasks[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _removeTask(index), // 삭제 버튼 눌렀을 때
                  ),
                  onTap: () => _placeTaskOnBingoBoard(_tasks[index]), // 할 일 클릭 시 빙고판에 배치
                );
              },
            ),
          ),
          // 빙고판 UI
          SizedBox(
            width: 300, // 그리드의 가로 크기를 제한
            height: 300, // 그리드의 세로 크기를 제한
            child: GridView.builder(
              itemCount: 25, // 5x5 그리드
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5, // 5개의 열
                crossAxisSpacing: 4, // 열 간의 간격
                mainAxisSpacing: 4, // 행 간의 간격
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // 클릭 시 할 일을 넣을 수 있는 로직 추가 가능
                  },
                  child: Container(
                    color: Colors.blueGrey[100],
                    child: Center(
                      child: Text(
                        _bingoBoard[index] ?? '', // 할 일이 있을 때 그 내용을 표시
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog, // '+' 버튼 눌렀을 때 할 일 추가 화면
        tooltip: '할 일 추가',
        child: Icon(Icons.add),
      ),
    );
  }
}
