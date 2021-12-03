import 'dart:convert';
import 'dart:io';

import 'package:credit_card_project/Constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../credit_cards_page.dart';
class UploadCard extends StatefulWidget {
  final String token;
  final cardData;
  const UploadCard({Key key, this.token, this.cardData}) : super(key: key);

  @override
  _UploadCardState createState() => _UploadCardState();
}

class _UploadCardState extends State<UploadCard> {
  File fileMedia;
  File imageFile;
  bool isLoading = false;
  var newdata;
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController _cardHolderTextEditingController = TextEditingController();
  TextEditingController _expiryTextEditingController = TextEditingController();
  TextEditingController _cardNoTextEditingController = TextEditingController();
  TextEditingController _cardTypeTextEditingController = TextEditingController();
  int id = 1;
  int _visaRadio = 1;
  int _Mcradio = 0;
  int _aEradio = 0;
  String cardType="VISA";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text("Add Card"),
      ),
      backgroundColor: Colors.grey[800],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  getImage();
                },
                child: Padding(
                    padding: const EdgeInsets.only(
                        top: 0, right: 8.0, left: 8, bottom: 0),
                    child: fileMedia == null
                        ? Container(
                            color: Colors.white,
                            child: Center(
                              child: Container(
                                  height: MediaQuery.of(context).size.height / 3,
                                  width: MediaQuery.of(context).size.width / 3,
                                  child: Icon(
                                    Icons.add_a_photo,
                                    size: 50,
                                    color: Colors.grey,
                                  )),
                            ),
                          )
                        : Image.file(
                            fileMedia,
                      height: MediaQuery.of(context).size.height / 3,
                      width: MediaQuery.of(context).size.width / 3,
                          )),

                // ),
              ),
              _buildTF("Card Name", nameTextEditingController),
              _buildTF("Card Holder", _cardHolderTextEditingController),
              _buildTF("Card Expiry", _expiryTextEditingController),
              cardRow(),
              _buildTF("Card Number", _cardNoTextEditingController),
              _buildLoginBtn(),
            ],
          ),
        ),
      ),
    );
  }

  Future getImage() async {
    var tempImage = await ImagePicker().getImage(source: ImageSource.camera);
    setState(() {
      fileMedia = File(tempImage.path);
    });
  }

  _cropImage(filePath) async {
    File croppedImage = await ImageCropper.cropImage(
        sourcePath: filePath,
        maxWidth: 1080,
        maxHeight: 1080,
        aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0));
    if (croppedImage != null) {
      imageFile = croppedImage;
      setState(() {
        fileMedia = imageFile;
      });
    }
  }

  Widget _buildLoginBtn() {
    return
      // isLoading == true
      //   ? CircularProgressIndicator(
      //       color: Colors.white,
      //     )
      //   :
      Container(
            padding: EdgeInsets.symmetric(vertical: 25.0),
            width: MediaQuery.of(context).size.width / 1.5,
            child: RaisedButton(
              elevation: 5.0,
              onPressed: () => {
                setState(() {
                  addCard(nameTextEditingController.text,_expiryTextEditingController.text,
                      _cardHolderTextEditingController.text,_cardNoTextEditingController.text,
                    cardType,imageFile
                  );
                  isLoading = true;
                })
              },
              padding: EdgeInsets.all(15.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              color: Colors.white,
              child: Text(
                'Upload',
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
  _asyncFileUpload(String name, File file,String expiry,String holder,
      String number,String category,) async{
    //create multipart request for POST or PATCH method
    var request = http.MultipartRequest("POST",
        Uri.parse("https://flutter-assignment-api.herokuapp.com/v1/cards"));
    request.headers['Content-Type']="application/json";
    request.headers['accept']="application/json";
    request.headers['Authorization']='Bearer ${widget.token}';
    //add text fields
    // request.fields["name"] = name;
    // request.fields["cardExpiration"] = expiry;
    // request.fields["cardHolder"] = holder;
    // request.fields["cardNumber"] = number;
    // request.fields["category"] = category;
    //create multipart using filepath, string or bytes
    var pic = await http.MultipartFile.fromPath("cardImage", fileMedia.path);
    //add multipart to request
    request.files.add(pic);
    var response = await request.send();

    //Get the response from the server
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print(responseString);
    print(response.statusCode);
  }
  addCard(String name,String expiry,String holder,
      String number,String category,File file) async{
    final url = "http://192.168.43.8/auth/register";
    final apiurl = "https://flutter-assignment-api.herokuapp.com/v1/cards";
    var response = await http.post(
        Uri.parse(apiurl),
        headers: {"Content-Type": "application/json",
          'accept': 'application/json',
          'Authorization': 'Bearer ${widget.token}',},
        body:jsonEncode(
            {
              "name": name,
              "cardExpiration": expiry,
              "cardHolder": holder,
              "cardNumber": number,
              "category": category
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
      _asyncFileUpload(name, file, expiry, holder, number, category);
      Fluttertoast.showToast(msg: "Card Saved Successfully");
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context){
        return CreditCardsPage(token: widget.token,cardData: widget.cardData,);
      }));
      var data = jsonDecode(response.body);
      print(newdata['Token']);
    }
    else  Fluttertoast.showToast(msg: "something wrong ${response.body}");

  }
  Widget _buildTF(String label,TextEditingController textEditingController) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              label,
              style: kLabelStyle,
            ),
          ),
          SizedBox(height: 10.0),
          Container(
            alignment: Alignment.centerLeft,
            decoration: kBoxDecorationStyle,
            height: 60.0,
            child: TextField(
              controller: textEditingController,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 14),
                hintText: 'Enter your ${label}',
                hintStyle: kHintTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget cardRow(){
    return   Row(
      children: [
        Expanded(
          flex: 3,
          child: RadioListTile(
            groupValue: id,
            title: Text('VISA',style: TextStyle(color: Colors.white),),
            value: _visaRadio,
            onChanged: (val) {
              setState(() {
                cardType = 'VISA';
                _aEradio = 0;
                _visaRadio = 1;
                _Mcradio=0;
              });
            },
          ),
        ),
        Expanded(
          flex: 3,
          child: RadioListTile(
            groupValue: id,
            title: Text('MC',style: TextStyle(color: Colors.white),),
            value: _Mcradio,
            onChanged: (val) {
              setState(() {
                cardType = 'MC';
                _aEradio = 0;
                _visaRadio = 0;
                _Mcradio=1;
              });
            },
          ),
        ),
        Expanded(
          flex: 3,
          child: RadioListTile(
            groupValue: id,
            title: Text('AE',style: TextStyle(color: Colors.white),),
            value: _aEradio,
            onChanged: (val) {
              setState(() {
                cardType = 'AE';
                _aEradio = 1;
                _visaRadio = 0;
                _Mcradio=0;
              });
            },
          ),
        ),
      ],
    );
  }
}
