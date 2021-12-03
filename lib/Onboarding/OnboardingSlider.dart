import 'package:credit_card_project/Auth/LoginPage.dart';
import 'package:credit_card_project/Constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OnboardingSlider extends StatefulWidget {
  const OnboardingSlider({Key key}) : super(key: key);

  @override
  _OnboardingSliderState createState() => _OnboardingSliderState();
}

class _OnboardingSliderState extends State<OnboardingSlider> {
  int index=0;
  List<Widget> children = [
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(child: Image.asset("assets/images/avery-evans-RJQE64NmC_o-unsplash.jpg")),
          Expanded(
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 15,height: 15,
                  decoration: BoxDecoration(
                    color:Colors.purple ,
                    shape: BoxShape.circle,
                      border: Border.all(color: Colors.purple)
                  ),),Container(
                  width: 15,height: 15,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                      border: Border.all(color: Colors.purple)
                  ),),Container(
                  width: 15,height: 15,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                      border: Border.all(color: Colors.purple)
                  ),),
              ],
            ),
          ),
        ],
      ),
    ),
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(child: Image.asset("assets/images/clay-banks-c2a0TydMlAs-unsplash.jpg")),
          Expanded(
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 15,height: 15,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.purple)
                  ),),Container(
                  width: 15,height: 15,
                  decoration: BoxDecoration(
                      color:Colors.purple ,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.purple)
                  ),),Container(
                  width: 15,height: 15,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.purple)
                  ),),
              ],
            ),
          ),
        ],
      ),
    ),
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(child: Image.asset("assets/images/mark-oflynn-bqjswIxbhEE-unsplash.jpg")),
          Expanded(
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 15,height: 15,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.purple)
                  ),),Container(
                  width: 15,height: 15,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.purple)
                  ),),Container(
                  width: 15,height: 15,
                  decoration: BoxDecoration(
                      color:Colors.purple ,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.purple)
                  ),),
              ],
            ),
          ),
        ],
      ),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 50,),
            Text("Credit Card",style: TextStyle(color: Colors.deepPurple[900],fontSize: 40,fontWeight: FontWeight.bold),),
            SizedBox(height: 50,),
            Container(
              height: MediaQuery.of(context).size.height/2,
              child: PageView.builder(
                  itemCount: children.length,
                  itemBuilder: (context,index){
                return children[index];
              }),
            ),
        GestureDetector(
          onTap: (){
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context){
                return LoginPage();
              }),
            );
          },
          child: Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.arrow_forward_ios,color: Colors.white,),
              ),
        ),
          ],
        ),
      ),
    );
  }
}
