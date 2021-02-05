import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'detailscreen.dart';
import 'donate.dart';
import 'user.dart';

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({Key key, this.user}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  GlobalKey<RefreshIndicatorState> refreshKey;

  List donatelist;
  double screenHeight, screenWidth;
  int quantity = 1;
  String titlecenter = "Loading...";

  @override
  void initState() {
    super.initState();
    _loadDonate();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('Share Loving'),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          Divider(color: Colors.green),
          donatelist == null
              ? Flexible(
                  child: Container(
                      child: Center(
                          child: Text(
                  titlecenter,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ))))
              : Flexible(
                  child: RefreshIndicator(
                      key: refreshKey,
                      color: Colors.red,
                      onRefresh: () async {
                        _loadDonate();
                      },
                      child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: (screenWidth / screenHeight) / 0.65,
                        children: List.generate(donatelist.length, (index) {
                          return Padding(
                              padding: EdgeInsets.all(1),
                              child: Card(
                                  child: InkWell(
                                onTap: () => _loadDonateDetail(index),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Stack(
                                        children: [
                                          Container(
                                              height: screenHeight / 4.5,
                                              width: screenWidth / 1.2,
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    "http://amongusss.com/ShareLoving/image/${donatelist[index]['donateimage']}.jpg",
                                                fit: BoxFit.fill,
                                                placeholder: (context, url) =>
                                                    new CircularProgressIndicator(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        new Icon(
                                                  Icons.broken_image,
                                                  size: screenWidth / 2,
                                                ),
                                              )),
                                          Positioned(
                                            child: Container(
                                                margin: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                      color: Colors.white,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10))),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                        donatelist[index]
                                                            ['donateid'],
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black)),
                                                    Icon(Icons.star,
                                                        color: Colors.black),
                                                  ],
                                                )),
                                            bottom: 10,
                                            right: 10,
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                       Text(
                                        donatelist[index]['donatename'],
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              )));
                        }),
                      )))
        ],
      ),
    ));
  }

  Future<void> _loadDonate() async {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Loading...");
    await pr.show();
    http.post("http://amongusss.com/ShareLoving/php/load_donate.php",
        body: {}).then((res) {
      if (res.body == "nodata") {
        donatelist = null;
        setState(() {
          titlecenter = "No Item Found";
        });
      } else {
        setState(() {
          var jsondata = json.decode(res.body);
          donatelist = jsondata["donate"];
        });
      }
    }).catchError((err) {
      print(err);
    });
    await pr.hide();
  }

  _loadDonateDetail(int index) {
    print(donatelist[index]['donateid']);
     Donate donate = new Donate(
       donateid: donatelist[index]['donateid'],
        donatename: donatelist[index]['donatename'],
        donateimage: donatelist[index]['donateimage'],
        description: donatelist[index]['description'],
        price: donatelist[index]['price']
        );

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => DetailScreen(
                  donate: donate,
                )));
  }
}