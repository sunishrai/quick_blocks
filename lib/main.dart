import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quick_bocks/Chat.dart';
import 'package:quick_bocks/Signup.dart';
import 'package:quick_bocks/UserList.dart';
import 'package:quickblox_sdk/auth/module.dart';
import 'package:quickblox_sdk/models/qb_session.dart';
import 'package:quickblox_sdk/models/qb_user.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:quick_bocks/Constants.dart';
import 'package:toast/toast.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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

void login(name,password,context) async {
  try {
    QBLoginResult result = await QB.auth.login(name, password);
    QBUser qbUser = result.qbUser;
    QBSession qbSession = result.qbSession;
    print(qbUser.toString());
    print(qbSession.toString());
    // Navigator.push(context, MaterialPageRoute(builder: (context)=>Chat()));
    Navigator.push(context, MaterialPageRoute(builder: (context)=>UsetList(currentUserId:qbUser.id,qbSession:qbSession.token)));
  } on PlatformException catch (e) {
    Toast.show("Invalid user name or password ", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
  }
}



class _MyHomePageState extends State<MyHomePage> {
  bool isLoading=false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  @override
  void initState() {
    init();
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
                        login(emailTextController.text,passwordTextController.text,context);
                      }

                    }),
                FlatButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUp()));}, child: Text("Register")),
              ],
            ),
          ),
        )
      ),
    );
  }

}
