import 'dart:convert';

import 'package:credit_card_project/Auth/LoginPage.dart';
import 'package:credit_card_project/Constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../credit_cards_page.dart';
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var data;
  var newdata;
  var userData;
  int vote=0;
  String token;
  bool isLoading = false;
  TextEditingController _emailTextEditingController = TextEditingController();
  TextEditingController _passwordTextEditingController = TextEditingController();
  TextEditingController _confirmPasswordTextEditingController = TextEditingController();
  TextEditingController _nameTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20,),
              title(),
              SizedBox(height: 20,),
              _buildFirstNameTF(),
              SizedBox(height: 20,),
              _buildEmailTF(),
              SizedBox(height: 20,),
              _buildPasswordTF(),
              SizedBox(height: 20,),
              _buildConfirmPasswordTF(),
              SizedBox(height: 20,),
              _buildLoginBtn()
            ],
          ),
        ),
      ),
    );
  }
  Widget title() {
    return Text(
      "Credit Card",
      style: TextStyle(fontSize: 28, color: Colors.white),
    );
  }
  Future fetchAPI() async {

    print("Fetching Api....");
    final url = "https://hoblist.com/movieList";
    var response = await http.get(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 401) {
      Fluttertoast.showToast(msg: "Unauthorized Error");
    } else if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      print(data);
    }
  }
  registerUser(String name,String email,String password,) async{
    final url = "http://192.168.43.8/auth/register";
    final apiurl = "https://flutter-assignment-api.herokuapp.com/v1/auth/register";
    var response = await http.post(
        Uri.parse(apiurl),
        headers: {"Content-Type": "application/json",'accept': 'application/json'},
        body:jsonEncode(
            {
              "name": name,
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
    } else if (response.statusCode == 201) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context){
        return LoginPage();
      }));
      var data = jsonDecode(response.body);
      print(newdata['Token']);
    }

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
  Widget _buildFirstNameTF() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Name',
            style: kLabelStyle,
          ),
          SizedBox(height: 10.0),
          Container(
            alignment: Alignment.centerLeft,
            decoration: kBoxDecorationStyle,
            height: 60.0,
            child: TextField(
              controller: _nameTextEditingController,
              keyboardType: TextInputType.text,
              cursorColor: Colors.white,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                hintText: 'Enter your Name',
                hintStyle: kHintTextStyle,
              ),
            ),
          ),
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
  Widget _buildConfirmPasswordTF() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Confirm Password',
            style: kLabelStyle,
          ),
          SizedBox(height: 10.0),
          Container(
            alignment: Alignment.centerLeft,
            decoration: kBoxDecorationStyle,
            height: 60.0,
            child: TextField(
              controller: _confirmPasswordTextEditingController,
              obscureText: false,
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
                hintText: 'Confirm your Password',
                hintStyle: kHintTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildLoginBtn() {
    return isLoading==true ? CircularProgressIndicator(color: Colors.white,) :
    Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: MediaQuery.of(context).size.width/1.5,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () => {
        setState(() {
        isLoading=true;
        }),
          registerUser(_nameTextEditingController.text,
              _emailTextEditingController.text,
              _passwordTextEditingController.text)
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'Sign Up',
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

}
