// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:html';
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WebcamMjpegView extends StatefulWidget {
  const WebcamMjpegView({
    super.key,
    required this.streamUrl,
    this.fit = BoxFit.cover,
  });

  final String streamUrl;
  final BoxFit fit;

  @override
  State<WebcamMjpegView> createState() => _WebcamMjpegViewState();
}

class _WebcamMjpegViewState extends State<WebcamMjpegView> {
  static int _counter = 0;
  late String _viewType;

  @override
  void initState() {
    super.initState();
    _registerFactory();
  }

  @override
  void didUpdateWidget(covariant WebcamMjpegView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.streamUrl != widget.streamUrl ||
        oldWidget.fit != widget.fit) {
      _registerFactory();
      setState(() {});
    }
  }

  void _registerFactory() {
    _viewType = 'webcam-mjpeg-${_counter++}';
    final objectFit = _toObjectFit(widget.fit);
    final url = widget.streamUrl;

    ui_web.platformViewRegistry.registerViewFactory(_viewType, (viewId) {
      final element = ImageElement()
        ..src = url
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.objectFit = objectFit
        ..style.border = '0';
      return element;
    });
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: _viewType);
  }

  String _toObjectFit(BoxFit fit) {
    switch (fit) {
      case BoxFit.contain:
        return 'contain';
      case BoxFit.fill:
        return 'fill';
      case BoxFit.fitHeight:
        return 'scale-down';
      case BoxFit.fitWidth:
        return 'scale-down';
      case BoxFit.none:
        return 'none';
      case BoxFit.scaleDown:
        return 'scale-down';
      case BoxFit.cover:
        return 'cover';
    }
  }
}
