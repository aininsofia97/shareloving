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
  double screenHeight = 0.00, screenWidth = 0.00;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.donate.donatename),
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    height: screenHeight / 2.5,
                    width: screenWidth / 0.5,
                    child: SingleChildScrollView(
                      child: CachedNetworkImage(
                        imageUrl:
                            "http://amongusss.com/ShareLoving/image/${widget.donate.donateimage}.jpg",
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            new CircularProgressIndicator(),
                        errorWidget: (context, url, error) => new Icon(
                          Icons.broken_image,
                          size: screenWidth / 2,
                        ),
                      ),
                    )),
                Divider(color: Colors.black),
                Text('Description',
                textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(height: 6),
                Text(widget.donate.description),
                Divider(color: Colors.black),   
              ],
            ),
          ),
        ),
      ),
    );
  }
}