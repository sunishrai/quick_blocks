import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quick_bocks/UserList.dart';
import 'package:quickblox_sdk/models/qb_user.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:toast/toast.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Signup"),),
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
                        'SignUp',
                      ),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          createUser(emailTextController.text,passwordTextController.text,context);
                        }
                      }),
                  FlatButton(onPressed: (){Navigator.pop(context);}, child: Text("Login")),
                ],
              ),
            ),
          )

      ),
    );
  }

  Future<void> createUser(name,password,BuildContext context) async {
    try {
      QBUser user = await QB.users.createUser(name, password);
      Navigator.push(context, MaterialPageRoute(builder: (context)=>UsetList(currentUserId:user.id)));
    } on PlatformException catch (e) {
      Toast.show(e.message, context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
    }
  }
}
