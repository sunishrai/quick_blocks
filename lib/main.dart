import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:quick_bocks/Chat.dart';
import 'package:quick_bocks/ChatRoom.dart';
import 'package:quick_bocks/MyChatList.dart';
import 'package:quick_bocks/Signup.dart';
import 'package:quick_bocks/UserList.dart';
import 'package:quick_bocks/notification_plugin.dart';
import 'package:quickblox_sdk/auth/module.dart';
import 'package:quickblox_sdk/models/qb_session.dart';
import 'package:quickblox_sdk/models/qb_subscription.dart';
import 'package:quickblox_sdk/models/qb_user.dart';
import 'package:quickblox_sdk/push/constants.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:quick_bocks/Constants.dart';
import 'package:toast/toast.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'QuickBlox Login'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

void init() async {
  try {
    await QB.settings.init(APP_ID, AUTH_KEY, AUTH_SECRET, ACCOUNT_KEY,
        apiEndpoint: API_ENDPOINT, chatEndpoint: CHAT_ENDPOINT);
  } on PlatformException catch (e) {
    // Some error occured, look at the exception message for more details
  }
}

void login(name,password,context,push_token) async {
  try {
    QBLoginResult result = await QB.auth.login(name, password);
    QBUser qbUser = result.qbUser;
    QBSession qbSession = result.qbSession;
    print('User ${qbUser.toString()}');
    print(qbSession.toString());
    // Navigator.push(context, MaterialPageRoute(builder: (context)=>Chat()));
    // Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatList(currentUserId:qbUser.id,qbSession:qbSession.token)));
    await subscribePush(push_token);
    Navigator.push(context, MaterialPageRoute(builder: (context)=>UsetList(currentUserId:qbUser.id,qbSession:qbSession.token)));
  } on PlatformException catch (e) {
    Toast.show("Invalid user name or password ", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
  }
}


Future<void> subscribePush(String token) async {
  try {
    List<QBSubscription> subscriptions = await QB.subscriptions.create(
        token,
        QBPushChannelNames.GCM
    );
    subscriptions.forEach((element) {
      print('subscriptions');
    });
    print('subscriptions');
    // _notificationPlugin.showNotification();
  } on PlatformException catch (e) {
    print(e.message);
    print('subscriptionserror');
    // Some error occured, look at the exception message for more details
  }
  return;
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];

    print("Firebase Background");
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }
  // Or do other work.
}


class _MyHomePageState extends State<MyHomePage> {
  bool isLoading=false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String push_token;

  @override
  void initState() {
    init();
    initFirebase();
    initNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child:Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller:emailTextController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    fillColor: Colors.grey[200],
                    filled: true,
                    hintText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 0,
                      ),
                    ),
                  ),
                  validator: (value) =>
                  value.trim().isEmpty ? 'Name required' : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: passwordTextController,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: InputDecoration(
                    fillColor: Colors.grey[200],
                    filled: true,
                    hintText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 0,
                      ),
                    ),
                  ),
                  validator: (value) =>
                  value.trim().isEmpty ? 'Password required' : null,
                ),
                SizedBox(height: 16),

                MaterialButton(
                    color: Colors.deepOrangeAccent,
                    splashColor: Colors.white,
                    height: 45,
                    minWidth: 100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'LOGIN',
                    ),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        login(emailTextController.text,passwordTextController.text,context,push_token);
                      }

                    }),
                FlatButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUp()));
                  }, child: Text("Register")),
              ],
            ),
          ),
        )
      ),
    );
  }

  void initFirebase() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showNotificationWithSound('onMessage');
        // fcmMessageHandler(message, navigatorKey, context);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        showNotificationWithSound('onLaunch');
        // fcmMessageHandler(message, navigatorKey, context);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        showNotificationWithSound('onResume');
        // fcmMessageHandler(message, navigatorKey, context);
      },
      onBackgroundMessage: myBackgroundMessageHandler
    );

    //Needed by iOS only
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });

    //Getting the token from FCM
    _firebaseMessaging.getToken().then((String token) {
      // assert(token != null);
      print("Firebase Token:  $token");
      push_token = token;
    });
  }



  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  void initNotification() {
    var initializationSettingsAndroid =
    new AndroidInitializationSettings('launch_background');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (payload) {
          return onSelectNotification(payload);
        });
  }

  Future showNotificationWithSound(message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);

    var iOSPlatformChannelSpecifics =
    new IOSNotificationDetails(sound: "slow_spring_board.aiff");
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'New Follower',
      'Hi chat',
      platformChannelSpecifics,
      payload: 'Custom_Sound',
    );
  }

  Future onSelectNotification(String payload) async {
    print("Play is ${payload}");
  }


}
