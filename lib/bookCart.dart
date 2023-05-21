import 'package:bookreport_project/credit.dart';
import 'main.dart';
import 'package:flutter/material.dart';
import './listmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bookSearch.dart';

class Cart extends StatelessWidget {
  const Cart({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'BOOK CART', home: CheckBoxListTileDemo());
  }
}

class CheckBoxListTileDemo extends StatefulWidget {
  const CheckBoxListTileDemo({super.key});

  @override
  CheckBoxListTileDemoState createState() => CheckBoxListTileDemoState();
}

class CheckBoxListTileDemoState extends State<CheckBoxListTileDemo> {
  List<CheckBoxListTileModel> checkBoxListTileModel = [];
  int total = 0;

  // 잘 저장되었는지 확인하기 위함
  Future<void> printSharedPreferenceValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> titles = prefs.getStringList('titles') ?? [];
    List<String> prices = prefs.getStringList('prices') ?? [];
    List<String> thumbnails = prefs.getStringList('thumbnails') ?? [];

    for (int i = 0; i < titles.length; i++) {
      // i가 0부터 i(SharedPreferences 리스트)의 크기만큼 하나씩 증가하면서
      checkBoxListTileModel.add(
        CheckBoxListTileModel(
          title: titles[i],
          subtitle: prices[i],
          img: thumbnails[i],
          isCheck: false,
          isAllCheck: false,
        ),
      );
    }
    setState(() {});
    // 불러온 내용들 CheckBoxListTileModel에 저장해서 실시간으로 장바구니에 뜨게 해야하기 때문에 상태변화 반영
  }

  void itemChange(bool val, int index) {
    setState(() {
      checkBoxListTileModel[index].isCheck = val;
    });
  }

  @override
  void initState() {
    super.initState();
    printSharedPreferenceValue();
    // 초기화해서 첨 시작할 때 printSharedPreferenceValue 불러오고 시작
  }

  void removeCheckedItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> titles = prefs.getStringList('titles') ?? [];
    List<String> prices = prefs.getStringList('prices') ?? [];
    List<String> thumbnails = prefs.getStringList('thumbnails') ?? [];

    List<String> updatedTitles = [];
    List<String> updatedPrices = [];
    List<String> updatedThumbnails = [];

    for (int i = 0; i < checkBoxListTileModel.length; i++) {
      if (!checkBoxListTileModel[i].isCheck!) {
        updatedTitles.add(titles[i]);
        updatedPrices.add(prices[i]);
        updatedThumbnails.add(thumbnails[i]);
      }
    }

    await prefs.setStringList('titles', updatedTitles);
    await prefs.setStringList('prices', updatedPrices);
    await prefs.setStringList('thumbnails', updatedThumbnails);

    checkBoxListTileModel.removeWhere((item) => item.isCheck!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Column(
          children: [
            Row(
              children: [
                Image.asset(
                  'images/logo1.png',
                  width: 80,
                ),
                // const Text('장바구니', style: TextStyle(color: Colors.amber)),
              ],
            ),
            const SizedBox(
              height: 0,
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Checkbox(
                  value: checkBoxListTileModel.every((item) => item.isCheck!),
                  activeColor: Colors.amber,
                  onChanged: (value) {
                    setState(() {
                      for (var item in checkBoxListTileModel) {
                        item.isCheck = value!;
                      }
                      for (var item in checkBoxListTileModel) {
                        item.isAllCheck = value;
                      }
                    });
                  },
                ),
                const Text('전체 선택'),
                Expanded(
                  child: Container(),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.amber,
                  ),
                  onPressed: () {
                    int total = 0;
                    for (var item in checkBoxListTileModel) {
                      if (item.isCheck!) {
                        total += int.parse(item.subtitle!);
                      }
                    }
                    setState(() {
                      this.total = total;
                    });
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return AlertDialog(
                          content: Text("총 $total원 입니다.\n결제하시겠습니까?"),
                          actions: <Widget>[
                            Container(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          BookCredit(total: total),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.amber,
                                  backgroundColor: Colors.white,
                                  side: const BorderSide(
                                      color: Colors.grey, width: 1),
                                ),
                                child: const Text("네"),
                              ),
                            ),
                            Container(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.amber,
                                  backgroundColor: Colors.white,
                                  side: const BorderSide(
                                      color: Colors.grey, width: 1),
                                ),
                                child: const Text("아니요"),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text("계산"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.amber,
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () {
                    for (var item in checkBoxListTileModel) {
                      if (item.isCheck!) {
                        removeCheckedItems();
                      }
                    }
                  },
                  child: const Text('삭제'),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: checkBoxListTileModel.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.black, width: 1.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    elevation: 4.0,
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: <Widget>[
                          Checkbox(
                            value: checkBoxListTileModel[index].isCheck,
                            activeColor: Colors.amber,
                            onChanged: (bool? val) {
                              itemChange(val!, index);
                            },
                          ),
                          SizedBox(
                            width: 70,
                            height: 100,
                            child: Image.network(
                              checkBoxListTileModel[index].img!,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  checkBoxListTileModel[index].title!,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  '${checkBoxListTileModel[index].subtitle!}원',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color.fromARGB(255, 235, 180, 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
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
            label: '',
          ),
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
            label: '',
          ),
        ],
      ),
    );
  }
}
