import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'donate.dart';
import 'user.dart';
import 'package:http/http.dart' as http;

class DetailScreen extends StatefulWidget {
  final Donate donate;
  final User user;


  const DetailScreen({Key key, this.donate, this.user}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  double screenHeight, screenWidth;
  List donatelist;
  String titlecenter = "Loading donate...";
  String type = "donate";
  GlobalKey<RefreshIndicatorState> refreshKey;

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
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        title: Text('Donation List'),
        backgroundColor: Colors.black,  
      ),

     body: Column(
        children: [
        Row(
          children: List.generate(donatelist.length, (index) {
          return Padding(
              padding: EdgeInsets.all(1),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                              height: screenHeight / 2,
                              width: screenWidth / 1,
                    child: CachedNetworkImage(
                                       imageUrl:
                                               "http://amongusss.com/ShareLoving/image/${widget.donate.donateimage}.jpg",
                                                fit: BoxFit.fill,
                                                placeholder: (context, url) =>
                                                    new CircularProgressIndicator(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        new Icon(
                                                  Icons.broken_image,
                                                  size: screenWidth/2,
                                                  
                                                ),
                                              )),
                      Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Donate Id: " +
                            donatelist[index]
                            ['donateid'],
                            style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                         Text(
                            donatelist[index]
                            ['donatename'],
                            style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),   
                        Text("RM " +
                            donatelist[index]['price']
                             ),  
                         ],
                    ),
                  ],
                ),
              ));
          }), 
        ),
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
        body: {
          
        }).then((res) {
      if (res.body == "nodata") {
        donatelist = null;
        setState(() {
          titlecenter = "No Donation Found";
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

  }

}