// import 'package:flutter/material.dart';
// import 'package:scoped_model/scoped_model.dart';
// import './AllChatsPage.dart';
// import './ChatModel.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ScopedModel(
//       model: ChatModel(),
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         home: AllChatsPage(),
//       ),
//     );
//   }
// }
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';

void main() => runApp(MaterialApp(
      home: MyApp(),
    ));

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // IO.Socket socket = IO.io('http://localhost:5050', <String, dynamic>{
  //   'transports': ['websocket'],
  //   'autoConnect': true,
  //   'allowUpgrades': false
  // });

  Socket socket = io('http://127.0.0.1:5050');

//   const List EVENTS = [
//   'connect',
//   'connect_error',
//   'connect_timeout',
//   'connecting',
//   'disconnect',
//   'error',
//   'reconnect',
//   'reconnect_attempt',
//   'reconnect_failed',
//   'reconnect_error',
//   'reconnecting',
//   'ping',
//   'pong'
// ];

  // _MyAppState() {
  //   print('called');

  //   // socket.on('refresh', (data) => print(data));

  //   // socket.on('connect', (_) {
  //   //   print('connect');
  //   //   socket.emit('msg', 'test');
  //   // });
  //   // // socket.onConnect((data) => print('Connected'));
  //   // //socket.connect();
  //   // socket.onConnecting((data) {
  //   //   print("Connecting");
  //   // });
  //   // socket.on('event', (data) => print(data));
  //   // // socket.on('disconnect', (_) => print('Jason disconnect'));
  //   // socket.onDisconnect((data) => print('Test data ${data}'));
  //   // socket.on('fromServer', (_) => print(_));
  //   Socket socket = io(
  //       'http://localhost:5050',
  //       OptionBuilder()
  //           .setTransports(['websocket']) // for Flutter or Dart VM
  //           .disableAutoConnect() // disable auto-connection
  //           //.setExtraHeaders({'foo': 'bar'}) // optional
  //           .build());
  //   socket.connect();
  //   // socket.onConnect((_) {
  //   //   print('connect');
  //   //   socket.emitWithAck('msg', 'init', ack: (data) {
  //   //     print('ack $data');
  //   //     if (data != null) {
  //   //       print('from server $data');
  //   //     } else {
  //   //       print("Null");
  //   //     }
  //   //   });
  //   // });
  // }

  void connectToServer() {
    try {
      // IO.Socket socket1 = IO.io('http://localhost:5050', <String, dynamic>{
      //   'transports': ['websocket'],
      //   'autoConnect': false,
      // });
      Socket socket1 = io('http://localhost:5050');
      print('called');
      // Connect to websocket
      socket1.connect();

      // Handle socket events
      socket1.on('connect', (data) => print('Connected to socket server'));
      socket1.on('disconnect', (reason) => print('disconnected $reason'));
      socket1.on('error', (err) => print('Error: $err'));
    } catch (e) {
      print(e.toString());
    }
  }

  void _listenNewOrderOnSocket() {
    // Socket socket = io('http://localhost:5050',
    //     OptionBuilder().setTransports(['websocket']).build());
    // socket.onConnect((_) {
    //   print('connect');
    // });
    // socket.onError((e) {
    //   print(e);
    // });
    // socket.on('refresh', (data) {
    //   print(data);
    //   // var order = (data as Map)['order'];
    //   // var method = (data as Map)['method'];
    //   // if (method == "ADD")
    //   //   context.read<EventBus>().fire(NewOrderEvent(OrderModel.fromMap(order)));
    // });
    // socket.onDisconnect((_) => print('disconnect'));
    Socket socket = io(
        'http://localhost:5000',
        OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .disableAutoConnect() // disable auto-connection
            //.setExtraHeaders({'foo': 'bar'}) // optional
            .build());
    socket.connect();
  }

  @override
  void initState() {
    // TODO: implement initState
    // socket.onConnect((_) {
    //   print('connect');
    //   socket.emit('msg', 'test');
    // });
    // socket.on('event', (data) => print(data));
    // socket.onDisconnect((_) => print('disconnect'));
    // socket.on('fromServer', (_) => print(_));
    // connectAndListen();
    _listenNewOrderOnSocket();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    HttpOverrides.global = new MyHttpOverrides();
    return Scaffold(
      appBar: AppBar(
        title: Text("Socketio"),
      ),
    );
  }
}

class StreamSocket {
  final _socketResponse = StreamController<String>();

  void Function(String) get addResponse => _socketResponse.sink.add;

  Stream<String> get getResponse => _socketResponse.stream;

  void dispose() {
    _socketResponse.close();
  }
}

StreamSocket streamSocket = StreamSocket();

//STEP2: Add this function in main function in main.dart file and add incoming data to the stream
void connectAndListen() {
  Socket socket = io('http://localhost:5050',
      OptionBuilder().setTransports(['websocket']).build());
  print('called');

  socket.onConnect((_) {
    print('connect');
    socket.emit('msg', 'test');
  });

  //When an event recieved from server, data is added to the stream
  socket.on('event', (data) => streamSocket.addResponse);
  socket.onDisconnect((_) => print('abc disconnect'));
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
