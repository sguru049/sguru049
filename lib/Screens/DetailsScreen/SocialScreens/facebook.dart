import 'dart:html';
import 'package:botox_deals/Constants/StringConstants.dart';
import 'package:botox_deals/Services/HtmlEmbed.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Facebook extends StatefulWidget {
  String? fbRef;
  Facebook(this.fbRef);
  String htmlId = UniqueKey().toString();

  @override
  _FacebookState createState() => _FacebookState();
}

class _FacebookState extends State<Facebook> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(sFacebookScreenTitle),
        centerTitle: true,
      ),
      body: HtmlEmbed().getHtmlPage(widget.htmlId, (int id) {
        return IFrameElement()
          ..width = MediaQuery.of(context).size.width.toString()
          ..height = MediaQuery.of(context).size.height.toString()
          ..src =
              'https://www.facebook.com/plugins/page.php?href=${widget.fbRef}&tabs=timeline&width=${MediaQuery.of(context).size.width}&height=${MediaQuery.of(context).size.height}&small_header=false&adapt_container_width=true&hide_cover=false&show_facepile=true&appId'
          ..style.border = 'none';
      }),
    );
  }
}
