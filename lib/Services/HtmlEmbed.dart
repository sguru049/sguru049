import 'dart:html';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class HtmlEmbed {
  Widget getHtmlPage(String htmlId, HtmlElement Function(int id) page) {
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(htmlId, page);

    return HtmlElementView(key: UniqueKey(), viewType: htmlId);
  }
}
