import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:friendlychat/message.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatMessage extends StatelessWidget {
  final AnimationController animationController;
  final Message message;
  final String userId;

  ChatMessage({this.userId, this.message, this.animationController});

  @override
  Widget build(BuildContext context) {
    var incoming = userId != message.senderId;

    var row = new Row(
      children: <Widget>[
        incoming
            ? new SizedBox(
                width: 0,
                height: 0,
              )
            : new Spacer(
                flex: 1,
              ),
        new Container(
          margin: incoming
              ? EdgeInsets.only(right: 50.0)
              : EdgeInsets.only(left: 50.0),
          child: new Card(
            color: incoming ? Colors.green[400] : Colors.indigo[100],
            child: new Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Container(
                        constraints: BoxConstraints(maxWidth: 200),
                        margin: EdgeInsets.only(top: 5.0),
                        child: new Text(message.message),
                      ),
                      new Text(
                        timeago.format(DateTime.fromMillisecondsSinceEpoch(message.timestamp), locale: 'en', allowFromNow: true),
                        style: Theme.of(context).textTheme.caption,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );

    return animationController == null
        ? row
        : new SizeTransition(
            sizeFactor: new CurvedAnimation(
              parent: animationController,
              curve: Curves.easeOut,
            ),
            axisAlignment: 0.0,
            child: row,
          );
  }
}
