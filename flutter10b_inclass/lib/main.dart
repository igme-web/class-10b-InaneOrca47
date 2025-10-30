import 'package:flutter/material.dart';

// 1) You need to install this so it works 'flutter pub add http'
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';

//This is where we will fetch some sample JSON (have a look at it please)
final String postURL = "https://jsonplaceholder.typicode.com/posts";

// 2) ADD your JItem class below (we'll do in class or grab from 10b notes)
class JItem {
  final int id;
  final String title;

  JItem({required this.id, required this.title});
}

class JItemsProvider extends ChangeNotifier {
  // We'll fill this in step by step
  List<JItem> items = [];
  final String postURL = 'https://jsonplaceholder.typicode.com/posts';

  Future<void> getData() async {
    var response = await http.get(Uri.parse(postURL));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      for (var item in data) {
        items.add(JItem(id: item['id'], title: item['title']));
      }
    }
    notifyListeners();
  }

  void clear() {
    items.clear();
    notifyListeners();
  }
}

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => JItemsProvider(),
      child: MaterialApp(title: 'Future Provider Example', home: DemoPage()),
    );
  }
}

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  // At the top of your State class
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Example'), backgroundColor: Colors.orange),
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Consumer<JItemsProvider>(
                  builder: (context, myProvider, child) {
                    return ElevatedButton(
                      onPressed: () {
                        myProvider.getData();
                      },
                      child: Text('Get Data'),
                    );
                  },
                ),
                Consumer<JItemsProvider>(
                  builder: (context, myProvider, child) {
                    return ElevatedButton(
                      onPressed: () {
                        myProvider.clear();
                      },
                      child: Text('Clear Data'),
                    );
                  },
                ),
              ],
            ),
            Expanded(
              child: Consumer<JItemsProvider>(
                builder: (context, myProvider, child) {
                  return ListView.builder(
                    itemCount: myProvider.items.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(myProvider.items[index].id.toString()),
                        subtitle: Text(myProvider.items[index].title),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//4) Create the getData Function here!
Future<List<JItem>> getData() async {
  List<JItem> posts = [];

  var response = await http.get(Uri.parse(postURL));

  if (response.statusCode == 200) {
    var data = json.decode(response.body);

    for (var item in data) {
      posts.add(JItem(id: item['id'], title: item['title']));
    }
  }

  return posts;
}
