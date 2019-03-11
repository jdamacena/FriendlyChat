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
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = new TextEditingController();
  bool _isComposing = false;
  Future<List<Message>> post;

  @override
  void initState() {
    super.initState();
    post = fetchPost();
  }

  Future<List<Message>> fetchPost() async {
    final response = await http
        .get('https://next.json-generator.com/api/json/get/NJovWsL8I');

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
                child: Icon(
                  Icons.favorite,
                  color: Colors.indigo,
                ),
              ),
              new Container(
                  margin: EdgeInsets.only(left: 8.0),
                  child: new Text("Junior Damacena")),
            ],
          ),
          elevation:
              Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        ),
        body: FutureBuilder<List<Message>>(
          future: post,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var _messagesData = snapshot.data;
              _messagesData.forEach((messageData) {
                var message = new ChatMessage(
                  message:
                      messageData, /*
                  animationController: new AnimationController(
                      duration: new Duration(milliseconds: 700), vsync: this),*/
                );

                _messages.add(message);
              });

              return new Container(
                child: new Column(
                  children: <Widget>[
                    new Flexible(
                      child: new ListView.builder(
                        reverse: true,
                        padding: EdgeInsets.all(8.0),
                        itemBuilder: (_, int index) => _messages[index],
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
    setState(() {
      _isComposing = false;
    });

    ChatMessage chatMessage = new ChatMessage(
      message: new Message(text: value),
      animationController: new AnimationController(
          duration: new Duration(milliseconds: 300), vsync: this),
    );

    setState(() {
      _messages.insert(0, chatMessage);
    });

    chatMessage.animationController.forward();
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages)
      message.animationController.dispose();
    super.dispose();
  }
}
