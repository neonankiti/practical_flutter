import 'package:flutter/material.dart';
import 'package:practical_flutter/eternal_scrolling_list_view.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Practical Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Practical Flutter Page")),
      body: ListView(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return EternalScrollingListPage();
              }));
            },
            // TODO i18n
            child: Text("Eternal Scrolling"),
          )
        ],
      ),
    );
  }
}
