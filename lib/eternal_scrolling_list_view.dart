import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

abstract class IndexRepository {
  Future<List<String>> getIndices(int cursor);
}

class IndexRepositoryImpl extends IndexRepository {
  @override
  Future<List<String>> getIndices(int cursor) {
    final List<String> items = [];
    for (int i = 0; i < 20; i++) {
      items.add("Item Position is ${(cursor - 1) * 20 + i}");
    }
    return Future.delayed(Duration(seconds: 3), () {
      return items;
    });
  }
}

class EternalScrollingListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            // TODO i18n
            AppBar(title: Text("External Scrolling List Page")),
        body: Provider<IndexRepository>(
            create: (_) => IndexRepositoryImpl(),
            child: EternalScrollingListView()));
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
    // TODO refactoring. maybe async or sync processing a bit buggy.
    _isLoading = true;
    Provider.of<IndexRepository>(context)
        .getIndices(nextCursor)
        .then((onValue) {
      setState(() {
        _items.addAll(onValue);
      });
      _nextCursor++;
      _isLoading = false;
      isSameRequest = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext buildContext) {
    // TODO remove this to domain operation.
    getItems(_nextCursor);
    return ListView.builder(
        controller: _scrollController,
        itemBuilder: (context, index) {
          return Container(height: 100, child: Text("${_items[index]}"));
        },
        itemCount: _items.length);
  }
}
