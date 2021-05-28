import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


class EditContact extends StatefulWidget {

  String contactKey;
  EditContact({this.contactKey});


  @override
  _EditContactState createState() => _EditContactState();
}

class _EditContactState extends State<EditContact> {

  TextEditingController _nameController;
  TextEditingController _numberController;
  TextEditingController _emailController;
  TextEditingController _addressController;
  TextEditingController _cepController;
  TextEditingController _birthController;
  TextEditingController _imagePath;

  PickedFile _imageFile;
  final ImagePicker _picker = ImagePicker();



  DatabaseReference _ref;

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
    _imagePath = TextEditingController();





    _ref = FirebaseDatabase.instance.reference().child(('Contacts'));


    getContactDetail();



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Editar contato'),
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
                  child: Text('Salvar'),
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

  void getContactDetail() async{
    DataSnapshot snapshot = await _ref.child(widget.contactKey).once();

    Map contact = snapshot.value;

    setState(() {
      _imagePath.text = contact['image'];
    });

    _nameController.text = contact['name'];
    _numberController.text = contact['number'];
    _emailController.text = contact['email'];
    _addressController.text = contact['address'];
    _cepController.text = contact['cep'];
    _birthController.text = contact['birthday'];

    (context as Element).reassemble();

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
      imageFilePath = _imagePath.text;
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

    _ref.child(widget.contactKey).update(contact).then((value){
      Navigator.pop(context);
    });

  }

  Widget imageProfile(){
    return Stack(
      children: <Widget> [
        CircleAvatar(
          radius: 40,
          backgroundImage: FileImage(File(_imagePath.text)),
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


}
