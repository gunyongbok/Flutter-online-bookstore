import 'package:bookreport_project/bookCart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'bookSearch.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  final List<String> assetPaths = [
    'images/image1.png',
    'images/image2.png',
    'images/image3.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Container(
            color: Colors.white,
            width: 100,
            margin: const EdgeInsets.all(5),
            child: Image.asset(
              'images/logo1.png',
              fit: BoxFit.contain,
            ),
          ),
          Container(
            color: Colors.black,
            width: double.infinity,
            height: 5,
            margin: const EdgeInsets.all(1),
          ),
          Container(
            color: Colors.black,
            width: double.infinity,
            height: 2,
            margin: const EdgeInsets.all(1),
          ),
          Container(
            color: Colors.white,
            height: 660,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Swiper(
                control: const SwiperControl(),
                pagination: const SwiperPagination(),
                itemCount: assetPaths.length,
                itemBuilder: (BuildContext context, int index) {
                  return Image.asset(assetPaths[index]);
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
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
                  '도서 검색',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Column(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.shopping_cart,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Cart()),
                    );
                  },
                  splashColor: Colors.transparent,
                ),
                const Text(
                  '장바구니',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
