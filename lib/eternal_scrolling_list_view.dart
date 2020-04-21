import 'dart:developer';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EternalScrollingListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            // TODO i18n
            AppBar(title: Text("External Scrolling List Page")),
        body: EternalScrollingListView());
  }
}

class EternalScrollingListView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ExternalScrollState();
}

class _ExternalScrollState extends State<EternalScrollingListView> {
  ScrollController _scrollController;
  bool _isLoading = false;

  // TODO use filtering operation and treat them as the same request.
  bool isSameRequest = false;
  int _nextCursor = 1;
  List<String> _items = [];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    getItems(_nextCursor);
  }

  void _scrollListener() {
    double currentPositionRatio =
        _scrollController.offset / _scrollController.position.maxScrollExtent;
    debugPrint("current offset ${_scrollController.offset}");
    debugPrint(
        "maxScroll extent ${_scrollController.position.maxScrollExtent}");
    const threshold = 0.8;
    if (currentPositionRatio > threshold && !isSameRequest) {
      isSameRequest = true;
      debugPrint("over thredhold");
      if (_isLoading) {
        debugPrint("loading now");
        return;
      }
      debugPrint("enable to get data");
      getItems(_nextCursor);
    }
  }

  // TODO make it to a repository and inject with provider.
  void getItems(int nextCursor) {
    _isLoading = true;
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        for (int i = 0; i < 20; i++) {
          _items.add("Item Position is ${(nextCursor - 1) * 20 + i}");
        }
        _nextCursor++;
        _isLoading = false;
        isSameRequest = false;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        controller: _scrollController,
        itemBuilder: (context, index) {
          return Container(height: 100, child: Text("${_items[index]}"));
        },
        itemCount: _items.length);
  }
}
