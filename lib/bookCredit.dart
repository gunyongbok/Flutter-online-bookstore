import 'package:bookreport_project/bookSearch.dart';
import 'package:bookreport_project/main.dart';
import 'package:flutter/material.dart';

class bookCredit extends StatelessWidget {
  final int total;
  const bookCredit({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: const Text('계산', style: TextStyle(color: Colors.amber))),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("$total원이 결제되었습니다.", style: const TextStyle(fontSize: 30)),
            const Text("감사합니다.", style: TextStyle(fontSize: 25)),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Column(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.home,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MyApp()),
                      );
                    },
                    splashColor: Colors.transparent,
                  ),
                  const Text(
                    '홈',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: Column(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BookSearch()),
                      );
                    },
                    splashColor: Colors.transparent,
                  ),
                  const Text(
                    '검색',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              label: '')
        ],
      ),
    );
  }
}
