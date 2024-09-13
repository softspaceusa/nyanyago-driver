import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/nanny_core.dart';

class FirebaseMessagingHandler {
  static void init() {
    FirebaseMessaging.onMessage.listen((msg) {
      Logger().w("Got message from firebase:\n${msg.data}\nNotification data:${msg.notification?.title}\n${msg.notification?.body}");
    });
    FirebaseMessaging.onMessageOpenedApp.listen((msg) {
      // if(msg.notification == null) return;
      if(msg.data["action"] == null) return;
      var action = NotificationAction.values.firstWhere((e) => e.name == msg.data["action"]);

      _handleAction(action, msg);
    });

    Logger().i("Inited firebase messages handler");
  }

  static void checkInitialMessage() async {
    var msg = await FirebaseMessaging.instance.getInitialMessage();
    if(msg == null) return;

    if(msg.data["action"] == null) return;
    var action = NotificationAction.values.firstWhere((e) => e.name == msg.data["action"]);

    _handleAction(action, msg);
  }

  static void _handleAction(NotificationAction action, RemoteMessage msg) {
    switch(action) {
      case NotificationAction.message:
        if(NannyGlobals.currentContext.widget.runtimeType == DirectView) {
          Navigator.pop(NannyGlobals.currentContext);
        }
      
        Navigator.push(
          NannyGlobals.currentContext, 
          MaterialPageRoute(builder: (context) => DirectView(idChat: int.parse( msg.data["id"] )))
        );
      break;

      case NotificationAction.order:
      break;

      case NotificationAction.orderFeedback:
      break;

      case NotificationAction.orderRequest:
      break;

      case NotificationAction.orderRequestSuccess:
      break;

      case NotificationAction.orderRequestDenied:
      break;

      case NotificationAction.fine:
      break;

      case NotificationAction.replyOrder:
      break;
    }
  }
}