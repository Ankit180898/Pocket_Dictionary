import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dictionary',
      theme: ThemeData(

      ),
      home: SearchScreen(),
    );
  }
}

class SearchScreen extends StatefulWidget {

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  //fetching by given api
  final String _url = "https://owlbot.info/api/v4/dictionary/";

  //token intiated by owlbot
  String _token = "4c049c54fe012fda3d6b18e64ea3efe9c8681288";
  TextEditingController _controller = TextEditingController();
  late StreamController _streamController;
  late Stream _stream;

  _search() async {
    if (_controller.text == null || _controller.text.isEmpty) {
      _streamController.add("");
    }
    final response = await http.get(Uri.parse(_url + _controller.text),
        headers: {"Authorization": "Token " + _token});
    _streamController.add(json.decode(response.body));
  }

  @override
  void initState() {
    super.initState();
    _streamController = StreamController();
    _stream = _streamController.stream;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Find It'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 12.0, bottom: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  child: TextFormField(
                    onChanged: (String text) {

                    },
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Search for a word',
                      contentPadding: const EdgeInsets.only(left: 24.0),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              IconButton(onPressed: () {
                _search();
              }, icon: Icon(Icons.search, color: Colors.white,))
            ],
          ),
        ),
      ),
      body: StreamBuilder(
        stream: _stream,
        builder: (BuildContext ctx, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: Text("Enter a search word"),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data['definitions'].length,
              itemBuilder: (BuildContext context, int index) {
                return ListBody(
                  children: [
                Container(
                color: Colors.grey[300],
                  child: ListTile(
                    leading: snapshot.data["definitions"][index]["image_url"] ==
                        null ? null : CircleAvatar(
                      backgroundImage: NetworkImage(
                          snapshot.data["definitions"][index]["image_url"]),
                    ),
                    title: Text(_controller.text.trim() + "(" +
                        snapshot.data["definitions"][index]["type"] + ")",style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24
                    ),),
                  ),
                ),
                Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                width: double.infinity,
                height: 130,

                decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.grey[200],
                ),
                child:Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Definition: ",style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),),
                        ),
                        SizedBox(height: 10,),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(snapshot.data["definitions"][index]["definition"],style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                          ),
                          ),
                        ),


                      ],

                    ),
                  ),
                ),
    ),
    ),
    ],


          );
        },
    );
    },
      ),
    );
  }
}



