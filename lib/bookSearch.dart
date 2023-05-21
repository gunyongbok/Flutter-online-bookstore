import 'dart:async';
import 'dart:convert';
import 'package:bookreport_project/bookCart.dart';
import 'package:bookreport_project/main.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// 애플리케이션의 도서 검색 기능에 대한 최상위 구조 및 라우팅을 제공
class BookSearch extends StatelessWidget {
  const BookSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: HttpApp(),
    );
  }
}

class HttpApp extends StatefulWidget {
  const HttpApp({super.key});

  @override
  _HttpAppState createState() => _HttpAppState();
}

class _HttpAppState extends State<HttpApp> {
  String result = '';
  List bookData = [];
  final TextEditingController _editingController = TextEditingController();

  Future<void> addToCart(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> titles = prefs.getStringList('titles') ?? [];
    List<String> prices = prefs.getStringList('prices') ?? [];
    List<String> thumbnails = prefs.getStringList('thumbnails') ?? [];

    String title = bookData[index]['title'];
    String price = bookData[index]['sale_price'].toString();
    String thumbnail = bookData[index]['thumbnail'];

    bool alreadyExists = titles.contains(title) &&
        prices.contains(price) &&
        thumbnails.contains(thumbnail);

    if (!alreadyExists) {
      // ignore: use_build_context_synchronously
      bool addedToCart = await showAddToCartDialog(context);
      if (addedToCart) {
        titles.add(title);
        prices.add(price);
        thumbnails.add(thumbnail);

        await prefs.setStringList('titles', titles);
        await prefs.setStringList('prices', prices);
        await prefs.setStringList('thumbnails', thumbnails);
      }
    } else {
      // ignore: use_build_context_synchronously
      showAlreadyInCartDialog(context);
    }
  }

  // 중복된 도서를 선택시 경고창
  void showAlreadyInCartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("경고!"),
          content: const Text("이미 장바구니에 추가된 도서입니다."),
          actions: [
            TextButton(
              child: const Text("네"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> showAddToCartDialog(BuildContext context) {
    Completer<bool> completer = Completer<bool>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("알림!"),
          content: const Text("장바구니에 추가하시겠습니까?"),
          actions: [
            TextButton(
              child: const Text("아니요"),
              onPressed: () {
                Navigator.of(context).pop();
                completer.complete(false);
              },
            ),
            TextButton(
              child: const Text("네"),
              onPressed: () {
                Navigator.of(context).pop();
                completer.complete(true);
              },
            ),
          ],
        );
      },
    );

    return completer.future;
  }

  @override
  void initState() {
    super.initState();
    dotenv.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: SizedBox(
          width: 360,
          height: 50,
          child: TextField(
            controller: _editingController,
            style: const TextStyle(color: Colors.black),
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: Colors.grey, width: 4.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: Colors.blue, width: 2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: Colors.grey, width: 1.0),
              ),
              suffixIcon: OutlinedButton(
                onPressed: () async {
                  bookData.clear();
                  getJSONData();
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.transparent),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
                child: const Icon(
                  Icons.search,
                  color: Colors.amber,
                  size: 35,
                ),
              ),
            ),
            textAlign: TextAlign.start,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: bookData.isEmpty
              ? Column(
                  children: [
                    const SizedBox(
                      height: 150,
                    ),
                    Container(
                      color: Colors.white,
                      height: 400,
                      child: Image.asset(
                        'images/logo.png',
                      ),
                    ),
                    const Text(
                      "찾으실 책 이름을 입력해주세요!",
                      style: TextStyle(fontSize: 30),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
              : ListView.builder(
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () async {
                        addToCart(index);
                      },
                      child: Card(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Row(
                            children: [
                              Image.network(
                                bookData[index]['thumbnail'],
                                height: 100,
                                width: 100,
                                fit: BoxFit.contain,
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width - 150,
                                    child: Text(
                                      bookData[index]['title'].toString(),
                                      style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                          color: Color.fromARGB(
                                              255, 246, 178, 77)),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  SizedBox(
                                    width: 290,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${bookData[index]['sale_price'].toString()}원',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Expanded(
                                          // Add Expanded widget
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              bookData[index]['authors']
                                                  .toString()
                                                  .substring(
                                                      1,
                                                      bookData[index]['authors']
                                                              .toString()
                                                              .length -
                                                          1),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: bookData.length,
                ),
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
              label: '')
        ],
      ),
    );
  }

  // 책 검색 api와 통신하기
  Future<String> getJSONData() async {
    await dotenv.load();
    String? kakaoRestApiKey = dotenv.env['KAKAO_REST_API_KEY'];
    var url = Uri.parse(
        'https://dapi.kakao.com/v3/search/book?target=title&query=${_editingController.text}');
    var response = await http.get(url, headers: {
      "Authorization": "KakaoAK $kakaoRestApiKey"
    }); // Print the response to check for any errors
    setState(() {
      var dataConvertedToJSON = json.decode(response.body);
      List result = dataConvertedToJSON["documents"] ?? [];
      bookData.addAll(result);
    });
    return response.body;
  }
}
