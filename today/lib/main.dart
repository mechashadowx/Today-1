import 'dart:convert';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'today',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Quicksand',
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final black = Color(0xFF000000);
  final red = Color(0xFFC33C3C);
  final gray = Color(0xFF939393);

  List<String> title = ["Births", "Deaths", "Events"];
  List<String> info = ["Wait..", "Wait..", "Wait.."];
  List<String> months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  String date = "";
  String url = "";

  @override
  void initState() {
    super.initState();
    var now = DateTime.now();
    date = now.day.toString() + ' - ' + months[now.month - 1];
    url = "http://history.muffinlabs.com/date/" +
        now.month.toString() +
        '/' +
        now.day.toString();
    this.getJsonData();
  }

  Future<void> getJsonData() async {
    var response = await http.get(
      Uri.encodeFull(url),
    );

    setState(() {
      Map<String, dynamic> convertData = jsonDecode(response.body);
      String x = convertData['data']['Births'][0]['text'].toString();
      String y = convertData['data']['Deaths'][0]['text'].toString();
      String z = convertData['data']['Events'][0]['text'].toString();
      for (int i = 0; i < info.length; i++) {
        info[i] = "";
      }
      int i = 0;
      while (x[i] != '[' && i < x.length) {
        info[0] += x[i];
        i++;
      }
      i = 0;
      while (y[i] != '[' && i < y.length) {
        info[1] += y[i];
        i++;
      }
      i = 0;
      while (z[i] != '[' && i < z.length) {
        info[2] += z[i];
        i++;
      }
    });
  }

  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  open() {}

  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return Scaffold(
      key: this.key,
      backgroundColor: this.black,
      body: Stack(
        children: <Widget>[
          Center(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            10.0, data.size.height * 0.1, 10.0, 10.0),
                        child: Center(
                          child: Text(
                            'Today is',
                            style: TextStyle(
                              color: this.gray,
                              fontSize: data.size.width * 0.2,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Center(
                          child: Text(
                            this.date,
                            style: TextStyle(
                              color: this.red,
                              fontSize: data.size.width * 0.15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: this.open,
                    child: Container(
                      margin: EdgeInsets.only(bottom: data.size.height * 0.17),
                      height: data.size.height * 0.1,
                      width: data.size.height * 0.1,
                      color: this.black,
                      child: FlareActor(
                        'assets/Today.flr',
                        animation: 'Today',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: data.size.height - 20,
            width: data.size.width,
            child: DraggableScrollableSheet(
              initialChildSize: 0.3,
              minChildSize: 0.0,
              maxChildSize: 0.95,
              builder: (BuildContext context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: this.red,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35),
                    ),
                  ),
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: this.title.length + 1,
                    itemBuilder: (context, int index) {
                      return index == 0
                          ? Container(
                              margin: EdgeInsets.fromLTRB(
                                  data.size.width * 0.45,
                                  0.0,
                                  data.size.width * 0.45,
                                  20.0),
                              height: data.size.height * 0.005,
                              width: data.size.height * 0.01,
                              decoration: BoxDecoration(
                                color: this.black,
                                borderRadius: BorderRadius.circular(15),
                              ),
                            )
                          : Container(
                              margin: EdgeInsets.only(
                                  bottom: data.size.height * 0.08),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Text(
                                        this.title[index - 1],
                                        style: TextStyle(
                                          color: this.gray,
                                          fontSize: data.size.width * 0.1,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Text(
                                        this.info[index - 1],
                                        style: TextStyle(
                                          color: this.gray,
                                          fontSize: data.size.width * 0.05,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
