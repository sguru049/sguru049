import 'dart:html';
import 'package:flutter/material.dart';
import 'package:botox_deals/Services/HtmlEmbed.dart';
import 'package:botox_deals/Constants/StringConstants.dart';

// ignore: must_be_immutable
class Twitter extends StatefulWidget {
  String? twitterRef;
  Twitter(this.twitterRef);
  String htmlId = UniqueKey().toString();

  @override
  _TwitterState createState() => _TwitterState();
}

class _TwitterState extends State<Twitter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(sTwitterScreenTitle),
        centerTitle: true,
      ),
      body: HtmlEmbed().getHtmlPage(widget.htmlId, (int id) {
        return IFrameElement()
          ..width = MediaQuery.of(context).size.width.toString()
          ..height = MediaQuery.of(context).size.height.toString()
          ..srcdoc =
              '<a class="twitter-timeline" href=${widget.twitterRef}>Tweets</a> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>'
          ..style.border = 'none';
      }),
    );
  }
}
