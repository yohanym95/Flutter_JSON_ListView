import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());


Future<List<Post>> fetchPost() async{
  final response  = await http.get("https://jsonplaceholder.typicode.com/posts");
  if(response.statusCode == 200){
    // return Post.fromJson(json.decode(response.body));
    return compute(parseList,response.body);
  }else{
    throw Exception("Failed to load the post, try again late");
  }
}

List<Post>  parseList (String responseBody){
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Post>((json)=>Post.fromJson(json)).toList();
}


class Post{
   final int userID;
   final int id;
   final String title;
   final String body;
   
   Post({this.userID,this.id,this.title,this.body});

   factory Post.fromJson(Map<String,dynamic> json){
     return Post(
       userID: json['userId'],
       id: json['id'],
       title: json['title'],
       body : json['body']
     );
   }



}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Networking Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Fetch data'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Future<List<Post>> post= fetchPost();

  

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder<List<Post>>(
          future:post,
          builder: (context,snapshot){
            if (snapshot.hasData){
            //   // return Text(snapshot.data.);   
             return ListView.builder(
               padding: EdgeInsets.all(10.0),
                itemCount: snapshot.data.length,
                itemBuilder: (context,i){
                  return new ListTile(
                    title: Text(snapshot.data[i].title),
                    subtitle: Text(snapshot.data[i].body),
                  );
                },
              ); 
            }else if(snapshot.hasError){
              return Text("${snapshot.error}");
              
            }
            return CircularProgressIndicator();
          }
          
        ),
      ),
    );
  }
}
