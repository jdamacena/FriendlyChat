import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:friendlychat/message.dart';

class ChatMessage extends StatelessWidget {
  final AnimationController animationController;
  final Message message;

  ChatMessage({this.message, this.animationController});

  @override
  Widget build(BuildContext context) {
    var row = new Row(
      children: <Widget>[
        message.incoming
            ? new SizedBox(
                width: 0,
                height: 0,
              )
            : new Spacer(
                flex: 1,
              ),
        new Container(
          margin: message.incoming
              ? EdgeInsets.only(right: 50.0)
              : EdgeInsets.only(left: 50.0),
          child: new Card(
            color: message.incoming ? Colors.green[400] : Colors.indigo[100],
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
                        child: new Text(message.text),
                      ),
                      new Text(
                        message.timestamp,
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
