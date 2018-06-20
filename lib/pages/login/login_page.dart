import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../home/home_page.dart';
import '../../utils/shared_preferences.dart';

enum AccountType { ANONYMOUS, USER, ADMIN }

AccountType gWhoAmI = AccountType.ANONYMOUS;
List<String> gAdminsList = new List<String>();

void fAddAdminToList(aAdminId, aAdminInfo) {
  print("fAddAdminToList");
  gAdminsList.add(aAdminInfo["email"]);
}

class LoginPageWidget extends StatefulWidget {
  const LoginPageWidget({Key aKey}) : super(key: aKey);
  @override
  LoginPage createState() => new LoginPage();
}

class LoginPage extends State<LoginPageWidget> {
  final FirebaseAuth mAuth = FirebaseAuth.instance;
  static FirebaseUser mUser;
  TextEditingController mEmailTextEditingController = TextEditingController();
  TextEditingController mPasswordTextEditingController =
      TextEditingController();

  void fLoginAsGuest() {
    print("fLoginAsGuest");
    gHomePage.mIsLogged = true;
    gHomePage.setState(() {});
  }

  void fLoginUsingEmail() async {
    print("fLoginUsingEmail");
    try {
      String email = mEmailTextEditingController.text;
      String password = mPasswordTextEditingController.text;
      mUser = await mAuth.signInWithEmailAndPassword(
          email: email, password: mPasswordTextEditingController.text);
      HomePage.fShowAlert(context, "Login succes!", "Welcome in Agora app!");
      gPrefs.setString("login_email", email);
      gPrefs.setString("login_password", password);
      gWhoAmI = AccountType.USER;
      gAdminsList.forEach((aAdminEmail) {
        if (email == aAdminEmail) {
          gWhoAmI = AccountType.ADMIN;
        }
      });
      print("fLoginUsingEmail:gWhoAmI=" + gWhoAmI.toString());
      gHomePage.mIsLogged = true;
      gHomePage.setState(() {});
    } catch (e) {
      print(e.toString());
      HomePage.fShowAlert(context, "Login fail!", "Wrong email or password!");
    }
  }

  @override
  void initState() {
    super.initState();
    mEmailTextEditingController.text = gPrefs.getString("login_email") ?? "";
    mPasswordTextEditingController.text =
        gPrefs.getString("login_password") ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Center(
            child: new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new SizedBox(
          width: 250.0,
          height: 60.0,
          child: new ListTile(
              leading: const Icon(Icons.email),
              title: new TextField(
                controller: mEmailTextEditingController,
                decoration: new InputDecoration(
                  hintText: "Email",
                ),
              )),
        ),
        new SizedBox(
          width: 250.0,
          height: 60.0,
          child: new ListTile(
              leading: const Icon(Icons.security),
              title: new TextField(
                controller: mPasswordTextEditingController,
                obscureText: true,
                decoration: new InputDecoration(
                  hintText: "Password",
                ),
              )),
        ),
        new Padding(padding: new EdgeInsets.all(10.0)),
        new RaisedButton(
            child: new Text("Login using e-mail"), onPressed: fLoginUsingEmail),
        new Padding(padding: new EdgeInsets.all(10.0)),
        new RaisedButton(
            child: new Text("Login as guest"), onPressed: fLoginAsGuest),
      ],
    )));
  }
}
