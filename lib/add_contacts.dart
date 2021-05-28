import 'dart:developer';
import 'package:firebase_database/firebase_database.dart' as firebase;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
//import 'package:intl/intl.dart';
//import "package:googleapis_auth/auth_io.dart";
//import 'package:googleapis/calendar/v3.dart';


class AddContacts extends StatefulWidget {
  @override
  _AddContactsState createState() => _AddContactsState();
}

class _AddContactsState extends State<AddContacts> {

  TextEditingController _nameController;
  TextEditingController _numberController;
  TextEditingController _emailController;
  TextEditingController _addressController;
  TextEditingController _cepController;
  TextEditingController _birthController;

  
  firebase.DatabaseReference _ref;

  PickedFile _imageFile;
  final ImagePicker _picker = ImagePicker();

  _consultaCep() async{

    String cep = _cepController.text;

    http.Response response;
    response = await http.get(Uri.parse("https://viacep.com.br/ws/${cep}/json"));

    Map<String, dynamic> retorno = json.decode(response.body);

    String rua = retorno["logradouro"];
    String cidade = retorno["localidade"];

    String resultado = "${cidade}, ${rua}";

    setState(() {
      _addressController.text = resultado;
    });

  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController = TextEditingController();
    _numberController = TextEditingController();
    _emailController = TextEditingController();
    _addressController = TextEditingController();
    _cepController = TextEditingController();
    _birthController = TextEditingController();
    
    _ref = firebase.FirebaseDatabase.instance.reference().child(('Contacts'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar contato'),
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              imageProfile(),

              SizedBox(height: 15),

              TextFormField(
                controller: _nameController,
                decoration:
                InputDecoration(
                  hintText: 'Nome',
                  prefixIcon: Icon(Icons.account_circle, size: 30,),
                  contentPadding: EdgeInsets.all(15),
                ),
                keyboardType: TextInputType.name,
              ),

              SizedBox(height: 15),

              TextFormField(
                controller: _numberController,
                decoration:
                InputDecoration(
                    hintText: 'Número',
                    prefixIcon: Icon(Icons.phone_android, size: 30,),
                    contentPadding: EdgeInsets.all(15),
                ),
                keyboardType: TextInputType.phone,
              ),

              SizedBox(height: 15),

              TextFormField(
                controller: _cepController,
                decoration:
                InputDecoration(
                  hintText: 'CEP',
                  prefixIcon: Icon(Icons.place, size: 30,),
                  contentPadding: EdgeInsets.all(15),
                ),
                keyboardType: TextInputType.number,
                onEditingComplete: _consultaCep,
              ),

              SizedBox(height: 15),

              TextFormField(
                controller: _emailController,
                decoration:
                InputDecoration(
                  hintText: 'E-mail',
                  prefixIcon: Icon(Icons.email_outlined, size: 30,),
                  contentPadding: EdgeInsets.all(15),
                ),
                keyboardType: TextInputType.emailAddress,
              ),

              SizedBox(height: 15),

              TextFormField(
                controller: _addressController,
                decoration:
                InputDecoration(
                  hintText: 'Endereço',
                  prefixIcon: Icon(Icons.location_city, size: 30,),
                  contentPadding: EdgeInsets.all(15),
                ),
              ),

              SizedBox(height: 15),

              TextFormField(
                controller: _birthController,
                decoration:
                InputDecoration(
                  hintText: 'Nascimento',
                  prefixIcon: Icon(Icons.cake, size: 30,),
                  contentPadding: EdgeInsets.all(15),
                ),
                keyboardType: TextInputType.datetime,
              ),

              SizedBox(height: 15),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.cyan, // background
                  onPrimary: Colors.white, // foreg
                ),
                child: Text('Adicionar'),
                onPressed: (){
                  saveContact();
                },
              )
            ],
        )
        )
      )
    );
  }

  Widget imageProfile(){
      return Stack(
        children: <Widget> [
          CircleAvatar(
            radius: 40,
            backgroundImage: _imageFile == null
            ? AssetImage("assets/default.png")
            : FileImage(File(_imageFile.path)),
            backgroundColor: Colors.cyan,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: InkWell(
              onTap: (){
                showModalBottomSheet(
                    context: context,
                    builder: ((builder) => bottomSheet()),
                );
              },
              child: Icon(Icons.camera_alt,
              color: Colors.white70,
                size: 30
              )
            )
          )
        ],
      );
  }

  Widget bottomSheet(){
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20
      ),
      child: Column(children: <Widget> [
        Text("Adicionar imagem de contato",
        style: TextStyle(
          fontSize: 20
        ),),

        SizedBox(height: 20,),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [

          TextButton(
            onPressed: (){
              takePhoto(ImageSource.camera);
            },
            child: Column(
              children: <Widget> [
                Icon(Icons.camera, color: Colors.cyan),
                Text("Camera", style: TextStyle(color: Colors.cyan),)
              ],
            )
          ),

          SizedBox(width: 60),

          TextButton(
              onPressed: (){
                takePhoto(ImageSource.gallery);
              },
              child: Column(
                children: <Widget> [
                  Icon(Icons.photo_album, color: Colors.cyan),
                  Text("Galeria", style: TextStyle(color: Colors.cyan),)
                ],
              )
          ),
        ],)
      ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(
        source: source,
    );
    setState(() {
      _imageFile = pickedFile;
    });
  }

  void saveContact(){
    String name = _nameController.text;
    String number = _numberController.text;
    String email = _emailController.text;
    String address = _addressController.text;
    String cep = _cepController.text;
    String birthday = _birthController.text;

    String imageFilePath;
    if(_imageFile == null){
      imageFilePath = "NULL";
    }else{
      imageFilePath = _imageFile.path;
    }

    Map<String, String> contact = {
      'name':name,
      'number':number,
      'email':email,
      'address':address,
      'cep':cep,
      'birthday':birthday,
      'image': imageFilePath
    };

    _ref.push().set(contact).then((value){
      Navigator.pop(context);
    });

    /* GOOGLE CALENDAR API
    DateTime dt = DateTime.parse(birthday);
    DateTime today = DateTime.now();


    var thisYearBirthday = new DateTime(today.year, dt.month, dt.day);

    var newDate = new DateTime(thisYearBirthday.year, thisYearBirthday.month, thisYearBirthday.day);
    if(thisYearBirthday.isBefore(DateTime.now())){
      newDate = new DateTime(today.year + 1, dt.month, dt.day);
    }

    const _scopes = const [CalendarApi.calendarScope];
    var _credentials;
    _credentials = new ClientId(
        "598986556763-db3b0mpl3d03cquoi3tbkopl17pra9mj.apps.googleusercontent.com",
        "");

    Event newEvent = Event();
    newEvent.summary = "[LDDM] Aniversário de ${name}"; //Setting summary of object;
    newEvent.start.date = newDate;
    newEvent.description = "Evento criado automaticamente pelo aplicativo de contatos";
    String calendarId = "primary";
    //event = service.events().insert(calendarId, event).execute();

    //var calendar = CalendarApi(client);


    CalendarApi calend = new CalendarApi(_credentials);
    calend.events.insert(newEvent, calendarId);

    */




  }


}
