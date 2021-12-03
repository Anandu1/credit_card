import 'dart:convert';

import 'package:credit_card_project/Constants/constants.dart';
import 'package:credit_card_project/credit_cards_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'SignUpScreen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailTextEditingController = TextEditingController();
  TextEditingController _passwordTextEditingController =
      TextEditingController();
  bool isLoading = false;
  var data;
  var newdata;
  var carddata;
  var userData;
  int vote=0;
  String token;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.brown,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 15,),
            title(),
            form(),
          ],
        ),
      ),
    );
  }

  Widget title() {
    return Expanded(
        flex: 1,
        child: Text(
          "Credit Card",
          style: TextStyle(fontSize: 40, color: Colors.white,fontWeight: FontWeight.bold),
        ));
  }

  Widget _buildEmailTF() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Email',
            style: kLabelStyle,
          ),
          SizedBox(height: 10.0),
          Container(
            alignment: Alignment.centerLeft,
            decoration: kBoxDecorationStyle,
            height: 60.0,
            child: TextField(
              controller: _emailTextEditingController,
              keyboardType: TextInputType.emailAddress,
              cursorColor: Colors.white,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.email,
                  color: Colors.white,
                ),
                hintText: 'Enter your Email',
                hintStyle: kHintTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget form() {
    return Expanded(
      flex: 4,
      child: Column(
        children: [
          _buildEmailTF(),
          SizedBox(
            height: 20,
          ),
          _buildPasswordTF(),
          SizedBox(
            height: 20,
          ),
          _buildLoginBtn(),
          SizedBox(
            height: 20,
          ),
          _buildSignupBtn()
        ],
      ),
    );
  }

  Widget _buildPasswordTF() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Password',
            style: kLabelStyle,
          ),
          SizedBox(height: 10.0),
          Container(
            alignment: Alignment.centerLeft,
            decoration: kBoxDecorationStyle,
            height: 60.0,
            child: TextField(
              controller: _passwordTextEditingController,
              obscureText: true,
              cursorColor: Colors.white,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.white,
                ),
                hintText: 'Enter your Password',
                hintStyle: kHintTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginBtn() {
    return isLoading == true
        ? CircularProgressIndicator(
            color: Colors.white,
          )
        : Container(
            padding: EdgeInsets.symmetric(vertical: 25.0),
            width: MediaQuery.of(context).size.width / 1.5,
            child: RaisedButton(
              elevation: 5.0,
              onPressed: () => {
              setState(() {
              isLoading=true;
              }),
               loginUser(_emailTextEditingController.text,
                   _passwordTextEditingController.text)
              },
              padding: EdgeInsets.all(15.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              color: Colors.white,
              child: Text(
                'LOGIN',
                style: TextStyle(
                  color: Color(0xFF527DAA),
                  letterSpacing: 1.5,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                ),
              ),
            ),
          );
  }
  loginUser(String email,String password,) async{
    final url = "https://flutter-assignment-api.herokuapp.com/v1/auth/login";
    var response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json",'accept': 'application/json'},
        body:jsonEncode(
            {
              "email": email,
              "password": password
            }
        ));
    print(response.statusCode);
    print(response.body);
    setState(() {
      newdata=jsonDecode(response.body);
    });
    if (response.statusCode == 401) {
      Fluttertoast.showToast(msg: "Unauthorized Error");
    } else if (response.statusCode == 200) {
      getCards(context, newdata['tokens']['access']['token']);
      var data = jsonDecode(response.body);
    }

  }
  //eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI2MWE3OTI3ZDVmZjE5MjAwMjEzMTVhYzciLCJpYXQiOjE2Mzg1MTQ0NDUsImV4cCI6MTYzODUxNjI0NSwidHlwZSI6ImFjY2VzcyJ9.e4CXziNO1nw_Qjsl6kxVEh1l_s7lmOPSVGe5-zZB4lE
  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () => print('Sign Up Button Pressed'),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) {
            return SignUpScreen();
          }));
        },
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Don\'t have an Account? ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
              TextSpan(
                text: 'Sign Up',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  getCards(BuildContext context,String token) async{
    final url = "https://flutter-assignment-api.herokuapp.com/v1/cards";
    var response = await http.get(
      Uri.parse(url),
      headers: {"Content-Type": "application/json",
        'accept': 'application/json' ,
        'Authorization': 'Bearer ${token}',},
    );
    print(response.statusCode);
    print(response.body);
    setState(() {
      carddata=jsonDecode(response.body);
    });
    if (response.statusCode == 401) {
      Fluttertoast.showToast(msg: "Unauthorized Error");
    } else if (response.statusCode == 200) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context){
        return CreditCardsPage(token: token,
          cardData:jsonDecode(response.body) ,);
      }));
      var data = jsonDecode(response.body);
      print(data);
      print(newdata);
    }

  }
}
