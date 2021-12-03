import 'dart:convert';

import 'package:credit_card_project/Auth/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'Screens/UploadCard.dart';

class CreditCardsPage extends StatefulWidget {
  final String token;
final cardData;
  const CreditCardsPage({Key key, this.token, this.cardData}) : super(key: key);
  @override
  State<CreditCardsPage> createState() => _CreditCardsPageState();
}

class _CreditCardsPageState extends State<CreditCardsPage> {
  var newdata;
  @override
  void initState() {
    print(widget.cardData);
    // getCards(context);
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Text(widget.cardData.toString()),
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildTitleSection(
                        title: "Payment Details",
                        subTitle: "How would you like to pay ?"),
                    cardListView(),
                    // _buildCreditCard(
                    //     color: Color(0xFF090943),
                    //     cardExpiration: "08/2022",
                    //     cardHolder: "HOUSSEM SELMI",
                    //     cardNumber: "3546 7532 XXXX 9742"),
                    // SizedBox(
                    //   height: 15,
                    // ),
                    // _buildCreditCard(
                    //     color: Color(0xFF000000),
                    //     cardExpiration: "05/2024",
                    //     cardHolder: "HOUSSEM SELMI",
                    //     cardNumber: "9874 4785 XXXX 6548"),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) {
                            return UploadCard(token: widget.token,cardData: widget.cardData,);
                          }),
                        );
                      },
                      child: _buildAddCardButton(
                        icon: Icon(Icons.add),
                        color: Color(0xFF081603),
                      ),
                    ),
                    _buildLogoutBtn(context)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutBtn(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 25.0),
        width: MediaQuery.of(context).size.width / 1.5,
        child: RaisedButton(
          elevation: 5.0,
          onPressed: () => {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (BuildContext context) {
              return LoginPage();
            }))
          },
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: Colors.white,
          child: Text(
            'Logout',
            style: TextStyle(
              color: Color(0xFF527DAA),
              letterSpacing: 1.5,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
          ),
        ),
      ),
    );
  }

  // Build the title section
  Column _buildTitleSection({@required title, @required subTitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 16.0),
          child: Text(
            '$title',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 16.0),
          child: Text(
            '$subTitle',
            style: TextStyle(fontSize: 21, color: Colors.black45),
          ),
        )
      ],
    );
  }

  // Build the credit card widget
  Card _buildCreditCard(
      {@required Color color,
      @required String cardNumber,
      @required String cardHolder,
      @required String cardExpiration}) {
    return Card(
      elevation: 4.0,
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Container(
        height: 200,
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 22.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildLogosBlock(),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                '$cardNumber',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontFamily: 'CourrierPrime'),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildDetailsBlock(
                  label: 'CARDHOLDER',
                  value: cardHolder,
                ),
                _buildDetailsBlock(label: 'VALID THRU', value: cardExpiration),
              ],
            ),
          ],
        ),
      ),
    );
  }

  getCards(BuildContext context) async{
    final url = "https://flutter-assignment-api.herokuapp.com/v1/cards";
    var response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json",
          'accept': 'application/json' ,
          'Authorization': 'Bearer ${widget.token}',},
        );
    print(response.statusCode);
    print(response.body);
    setState(() {
      newdata=jsonDecode(response.body);
    });
    if (response.statusCode == 401) {
      Fluttertoast.showToast(msg: "Unauthorized Error");
    } else if (response.statusCode == 200) {
      // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context){
      //   return CreditCardsPage();
      // }));
      var data = jsonDecode(response.body);
      print(data);
      print(newdata);
    }

  }

  // Build the top row containing logos
  Row _buildLogosBlock() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Image.asset(
          "assets/images/contact_less.png",
          height: 20,
          width: 18,
        ),
        Image.asset(
          "assets/images/mastercard.png",
          height: 50,
          width: 50,
        ),
      ],
    );
  }

// Build Column containing the cardholder and expiration information
  Column _buildDetailsBlock({@required String label, @required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '$label',
          style: TextStyle(
              color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold),
        ),
        Text(
          '$value',
          style: TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
        )
      ],
    );
  }

// Build the FloatingActionButton
  Container _buildAddCardButton({
    @required Icon icon,
    @required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 24.0),
      alignment: Alignment.center,
      child: FloatingActionButton(
        elevation: 2.0,
        backgroundColor: color,
        mini: false,
        child: icon,
      ),
    );
  }
  Widget cardListView(){
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
        itemCount: widget.cardData.length,
        itemBuilder: (context,index){
      return
        _buildCreditCard(
          cardHolder:widget.cardData['results'][index]['name'],
          cardExpiration: widget.cardData['results'][index]['cardExpiration'],
          cardNumber: widget.cardData['results'][index]['cardNumber'],
          color: Colors.blue[900],

        );
        // Text(widget.cardData['results'][index]['name']);
    });
  }
}
