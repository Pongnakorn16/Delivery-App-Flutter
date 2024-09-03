import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'dart:math' hide log;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mobile_miniproject_app/config/config.dart';
import 'package:mobile_miniproject_app/models/response/GetCart_Res.dart';
import 'package:mobile_miniproject_app/models/response/GetLotteryNumbers_Res.dart';
import 'package:mobile_miniproject_app/models/response/GetOneUser_Res.dart';
import 'package:mobile_miniproject_app/pages/Home.dart';
import 'package:mobile_miniproject_app/pages/Shop.dart';
import 'package:mobile_miniproject_app/pages/TEST.dart';
import 'package:mobile_miniproject_app/pages/Ticket.dart';
import 'package:mobile_miniproject_app/pages/Profile.dart';

class AdminPage extends StatefulWidget {
  int uid = 0;
  int wallet = 0;
  String username = '';
  int selectedIndex = 0;
  AdminPage(
      {super.key,
      required this.uid,
      required this.wallet,
      required this.username,
      required this.selectedIndex});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  String url = '';
  List<GetCartRes> all_cart = [];
  List<GetLotteryNumbers> win_lotterys = [];
  late Future<void> loadData;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
    loadData = loadDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Welcome ',
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black), // สีของข้อความที่เหลือ
                    ),
                    TextSpan(
                      text: widget.username,
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.blue,
                          fontWeight:
                              FontWeight.bold), // สีของ ${widget.username}
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 25),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 150, // กำหนดความกว้างของปุ่ม
                              height: 50, // กำหนดความสูงของปุ่ม
                              child: FilledButton(
                                onPressed: () async {
                                  await randomPrize_sold();
                                  await loadDataAsync(); // รอให้ loadDataAsync ทำงานเสร็จ

                                  setState(() {
                                    log("Updated win_lotterys length: " +
                                        win_lotterys.length.toString());
                                  });
                                  log("Final win_lotterys length: " +
                                      win_lotterys.length.toString());
                                },
                                child: const Text(
                                  'สุ่มรางวัลจาก lotterys ที่ขายไปแล้ว',
                                  textAlign: TextAlign
                                      .center, // จัดข้อความให้อยู่ตรงกลางแนวนอน
                                  style: TextStyle(fontSize: 12),
                                ),
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all(Colors.blue),
                                  padding: WidgetStateProperty.all<EdgeInsets>(
                                    EdgeInsets.symmetric(
                                        horizontal: 15.0,
                                        vertical:
                                            8.0), // ปรับ padding ภายในปุ่ม
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 150, // กำหนดความกว้างของปุ่ม
                              height: 50, // กำหนดความสูงของปุ่ม
                              child: FilledButton(
                                onPressed: () async {
                                  await randomPrize(); // รอให้ randomPrize ทำงานเสร็จ
                                  await loadDataAsync(); // รอให้ loadDataAsync ทำงานเสร็จ

                                  setState(() {
                                    log("Updated win_lotterys length: " +
                                        win_lotterys.length.toString());
                                  });
                                  log("Final win_lotterys length: " +
                                      win_lotterys.length.toString());
                                },
                                child: const Text(
                                  'สุ่มรางวัลจาก lotterys ทั้งหมด',
                                  textAlign: TextAlign
                                      .center, // จัดข้อความให้อยู่ตรงกลางแนวนอน
                                  style: TextStyle(fontSize: 12),
                                ),
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(
                                      Color.fromARGB(255, 254, 134, 69)),
                                  padding: WidgetStateProperty.all<EdgeInsets>(
                                    EdgeInsets.symmetric(
                                        horizontal: 15.0,
                                        vertical:
                                            8.0), // ปรับ padding ภายในปุ่ม
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: FutureBuilder(
                          future: loadData,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState !=
                                ConnectionState.done) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return SingleChildScrollView(
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: win_lotterys.map((lottery) {
                                      List<String> numberList =
                                          lottery.numbers.toString().split('');
                                      return Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Builder(
                                                builder: (context) {
                                                  Icon? icon;
                                                  Color textColor = Colors
                                                      .black; // สีเริ่มต้นของตัวหนังสือ

                                                  return Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      // แสดงไอคอนเฉพาะเมื่อไม่เป็น null
                                                      Text(
                                                        "${lottery.status_prize}.  ",
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: textColor,
                                                        ),
                                                      ),
                                                      Row(
                                                        children: numberList
                                                            .map(
                                                              (number) =>
                                                                  Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        2.0,
                                                                    vertical:
                                                                        15),
                                                                child: Center(
                                                                  child: Text(
                                                                    number,
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          21,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                            .toList(),
                                                      ),

                                                      if (icon != null)
                                                        Padding(
                                                          padding: const EdgeInsets
                                                              .only(
                                                              right:
                                                                  8.0), // เว้นระยะห่างระหว่างไอคอนกับข้อความ
                                                          child: icon,
                                                        ),
                                                    ],
                                                  );
                                                },
                                              ),
                                              Builder(
                                                builder: (context) {
                                                  // กำหนดตัวแปร status ตามค่า lottery.status
                                                  String prize;
                                                  if (lottery.status_prize ==
                                                      1) {
                                                    prize = '10,000';
                                                  } else if (lottery
                                                          .status_prize ==
                                                      2) {
                                                    prize = '5,000';
                                                  } else if (lottery
                                                          .status_prize ==
                                                      3) {
                                                    prize = '1,000';
                                                  } else if (lottery
                                                          .status_prize ==
                                                      4) {
                                                    prize = '500';
                                                  } else if (lottery
                                                          .status_prize ==
                                                      5) {
                                                    prize = '150';
                                                  } else {
                                                    prize =
                                                        'unknown'; // หรือค่าอื่น ๆ หาก status ไม่ตรงตามที่ระบุ
                                                  }

                                                  return Text(
                                                    "รางวัล $prize  บาท",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 150, // กำหนดความกว้างของปุ่ม
                      height: 50, // กำหนดความสูงของปุ่ม
                      child: FilledButton(
                        onPressed: () {
                          randomNumbers();
                        },
                        child: const Text(
                          'สุ่มตัวเลขใหม่ทั้งหมด',
                          textAlign: TextAlign
                              .center, // จัดข้อความให้อยู่ตรงกลางแนวนอน
                          style: TextStyle(fontSize: 13),
                        ),
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(Colors.blue),
                          padding: WidgetStateProperty.all<EdgeInsets>(
                            EdgeInsets.symmetric(
                                horizontal: 15.0,
                                vertical: 8.0), // ปรับ padding ภายในปุ่ม
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 250, // กำหนดความกว้างของปุ่ม
                      height: 60, // กำหนดความสูงของปุ่ม
                      child: FilledButton(
                        onPressed: () async {
                          await reset();
                          await loadDataAsync(); // รอให้ loadDataAsync ทำงานเสร็จ

                          setState(() {
                            log("Updated win_lotterys length: " +
                                win_lotterys.length.toString());
                          });
                          log("Final win_lotterys length: " +
                              win_lotterys.length.toString());
                        },
                        child: const Text(
                          'รีเซ็ทระบบใหม่ทั้งหมด',
                          textAlign: TextAlign
                              .center, // จัดข้อความให้อยู่ตรงกลางแนวนอน
                          style: TextStyle(fontSize: 19),
                        ),
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(Colors.red),
                          padding: WidgetStateProperty.all<EdgeInsets>(
                            EdgeInsets.symmetric(
                                horizontal: 15.0,
                                vertical: 8.0), // ปรับ padding ภายในปุ่ม
                          ),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10.0), // กำหนด border radius
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 25),
                    child: SizedBox(
                      width: 50, // ความกว้างเดิมของปุ่ม
                      height: 60, // กำหนดความสูงของปุ่ม
                      child: FilledButton(
                        onPressed: () {
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        },
                        child: Icon(
                          Icons.logout, // ไอคอนออกจากระบบ
                          size: 24, // กำหนดขนาดของไอคอน
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(Colors.black),
                          padding: WidgetStateProperty.all<EdgeInsets>(
                            EdgeInsets.symmetric(
                                horizontal:
                                    5.0, // ลด horizontal padding ให้ปุ่มแคบลง
                                vertical: 8.0), // ปรับ padding ภายในปุ่ม
                          ),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10.0), // กำหนด border radius
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> loadDataAsync() async {
    var value = await Configuration.getConfig();
    String url = value['apiEndpoint'];

    var response = await http.get(Uri.parse("$url/db/get_WinLottery"));
    if (response.statusCode == 200) {
      win_lotterys = getLotteryNumbersFromJson(response.body);
      log(win_lotterys.toString());
      for (var lottery in win_lotterys) {
        log(lottery.numbers.toString());
      }
    } else {
      log('Failed to load lottery numbers. Status code: ${response.statusCode}');
    }
  }

  Future<void> randomPrize() async {
    var value = await Configuration.getConfig();
    String url = value['apiEndpoint'];

    try {
      var randomPrize = await http.put(
        Uri.parse('$url/db/lotterys/randomPrize'),
        headers: {"Content-Type": "application/json; charset=utf-8"},
      );

      if (randomPrize.statusCode == 200) {
        print('Insert success');
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(
              'แจ้งเตือน',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            content: Text(
              'ท่านได้ทำการสุ่มรางวัลไปแล้ว',
              style: TextStyle(fontSize: 15),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0), // Padding ภายนอก
                    child: FilledButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'ปิด',
                        style: TextStyle(fontSize: 19),
                      ),
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.red),
                        padding: WidgetStateProperty.all<EdgeInsets>(
                          EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 5), // Padding ภายใน
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> randomPrize_sold() async {
    var value = await Configuration.getConfig();
    String url = value['apiEndpoint'];

    try {
      var randomPrize = await http.put(
        Uri.parse('$url/db/lotterys/randomPrize_sold'),
        headers: {"Content-Type": "application/json; charset=utf-8"},
      );

      if (randomPrize.statusCode == 200) {
        print('Insert success');
      } else {
        print('ERRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(
              'แจ้งเตือน',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            content: Text(
              'ท่านได้ทำการสุ่มรางวัลไปแล้ว',
              style: TextStyle(fontSize: 15),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0), // Padding ภายนอก
                    child: FilledButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'ปิด',
                        style: TextStyle(fontSize: 19),
                      ),
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.red),
                        padding: WidgetStateProperty.all<EdgeInsets>(
                          EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 5), // Padding ภายใน
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void randomNumbers() async {
    Set<String> uniqueNumbers = Set();

    while (uniqueNumbers.length < 10) {
      String number = Random().nextInt(999999).toString().padLeft(6, '0');
      uniqueNumbers.add(number);
    }
    var value = await Configuration.getConfig();
    String url = value['apiEndpoint'];

    List<String> numbers = uniqueNumbers.toList();

    try {
      var response = await http.post(Uri.parse("$url/db/random"),
          headers: {"Content-Type": "application/json; charset=utf-8"},
          body: jsonEncode({'numbers': numbers}));

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(
              'แจ้งเตือน',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            content: Text(
              'สุ่มตัวเลขเรียบร้อยแล้ว',
              style: TextStyle(fontSize: 15),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0), // Padding ภายนอก
                    child: FilledButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'ปิด',
                        style: TextStyle(fontSize: 19),
                      ),
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.red),
                        padding: WidgetStateProperty.all<EdgeInsets>(
                          EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 5), // Padding ภายใน
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      } else {
        print('Failed to insert. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> reset() async {
    var value = await Configuration.getConfig();
    String url = value['apiEndpoint'];

    try {
      var response = await http.delete(
        Uri.parse("$url/db/reset"),
        headers: {"Content-Type": "application/json; charset=utf-8"},
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(
              'แจ้งเตือน',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            content: Text(
              'รีเซ็ทระบบเรียบร้อยแล้ว',
              style: TextStyle(fontSize: 15),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0), // Padding ภายนอก
                    child: FilledButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'ปิด',
                        style: TextStyle(fontSize: 19),
                      ),
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.red),
                        padding: WidgetStateProperty.all<EdgeInsets>(
                          EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 5), // Padding ภายใน
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      } else {
        print('Failed to delete. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}