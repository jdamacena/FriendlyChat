import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:friendlychat/message.dart';
import 'package:http/http.dart' as http;

import 'chat_message.dart';

class ChatScreen extends StatefulWidget {
  @override
  State createState() => new ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  List<Message> _messages = <Message>[];
  final TextEditingController _textController = new TextEditingController();
  bool _isComposing = false;
  Future<List<Message>> post;

  var userId = "f3a183a4-178b-4735-9002-7daee2d0b38f";
  var threadId = "73039990-71d9-4aa1-989d-8a0d673dae0b";

  @override
  void initState() {
    super.initState();
    post = fetchPost();
  }

  Future<List<Message>> fetchPost() async {
    final response = await http.get(
        'https://my-json-server.typicode.com/jdamacena/friendlychat_api/messages');

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON
      var tmpMessagesList = json.decode(response.body);
      List<Message> messagesList = new List<Message>();

      tmpMessagesList.forEach((messageMap) {
        var message = Message.fromJson(messageMap);
        messagesList.add(message);
      });

      return messagesList;
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Row(
            children: <Widget>[
              new CircleAvatar(
                backgroundColor: Colors.white,
                child: new Text("N"),
              ),
              new Container(
                  margin: EdgeInsets.only(left: 8.0),
                  child: new Text("Name Surname")),
            ],
          ),
          elevation:
              Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        ),
        body: FutureBuilder<List<Message>>(
          future: post,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              _messages = snapshot.data;

              return new Container(
                child: new Column(
                  children: <Widget>[
                    new Flexible(
                      child: new ListView.builder(
                        reverse: true,
                        padding: EdgeInsets.all(8.0),
                        itemBuilder: messageBuilder,
                        itemCount: _messages.length,
                      ),
                    ),
                    new Divider(
                      height: 1.0,
                    ),
                    new Container(
                      decoration:
                          new BoxDecoration(color: Theme.of(context).cardColor),
                      child: _buildTextComposer(),
                    )
                  ],
                ),
                decoration: Theme.of(context).platform == TargetPlatform.iOS
                    ? new BoxDecoration(
                        border: new Border(
                          top: new BorderSide(color: Colors.grey[200]),
                        ),
                      )
                    : null,
              );
            } else if (snapshot.hasError) {
              return Center(child: Text("${snapshot.error}"));
            }

            // By default, show a loading spinner
            return new Center(child: new CircularProgressIndicator());
          },
        ));
  }

  Widget messageBuilder(_, int index) {
    _messages.sort((m1, m2) => m2.timestamp.compareTo(m1.timestamp));

    var message = new ChatMessage(
      message: _messages[index],
      userId: this.userId,
    );

    return message;
  }

  _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 100),
                child: new TextField(
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  controller: _textController,
                  onSubmitted: _isComposing ? _handleSubmitted : null,
                  onChanged: (String text) {
                    setState(() {
                      _isComposing = text.trim().length > 0;
                    });
                  },
                  decoration:
                      new InputDecoration.collapsed(hintText: "Send message"),
                ),
              ),
            ),
            new Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: Theme.of(context).platform == TargetPlatform.iOS
                  ? new CupertinoButton(
                      child: new Text("Send"),
                      onPressed: _isComposing
                          ? () => _handleSubmitted(_textController.text)
                          : null,
                    )
                  : new IconButton(
                      icon: new Icon(Icons.send),
                      onPressed: _isComposing
                          ? () => _handleSubmitted(_textController.text)
                          : null,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmitted(String value) {
    _textController.clear();

    var message = new Message(
        message: value, senderId: this.userId, threadId: this.threadId);

    setState(() {
      _isComposing = false;
      _messages.insert(0, message);
    });
  }
}
