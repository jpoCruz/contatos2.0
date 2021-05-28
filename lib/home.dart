import 'package:contacts/add_contacts.dart';
import 'package:contacts/edit_contact.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'dart:io';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Query _ref;
  DatabaseReference reference = FirebaseDatabase.instance.reference().child('Contacts');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _ref = FirebaseDatabase.instance.reference()
        .child('Contacts')
        .orderByChild('name');
  }



  Widget _buildContactItem({Map contact}){

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(15),
      //height: 150,
      color: Colors.black26,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(children: [
            Container(
              width: 60,
              height: 60,
              alignment: Alignment.topRight,
              decoration: BoxDecoration(
                  color: Colors.cyan,
                  image: DecorationImage(
                    image: contact['image'] == "NULL"
                        ? AssetImage("assets/default.png")
                        : FileImage(File(contact['image'])),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(30.0)
              ),
            ),

            SizedBox(width: 12,),
            Text(contact['name'], style: TextStyle(fontSize: 18,
            color: Colors.cyan,
            fontWeight: FontWeight.bold),),
          ],),
          SizedBox(height: 10,),
          Row(children: [
            Icon(Icons.email,
              //color: Theme.of(context).primaryColor,
              size: 18,),
            SizedBox(width: 6,),
            Text(contact['email'], style: TextStyle(fontSize: 14,
                //color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w400),),
          ],),
          SizedBox(height: 10,),
          Row(children: [
            Icon(Icons.phone_android,
              //color: Theme.of(context).primaryColor,
              size: 18,),
            SizedBox(width: 6,),
            Text(contact['number'], style: TextStyle(fontSize: 14,
                //color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w400),),
          ],),
          SizedBox(height: 10,),
          Row(children: [
            Icon(Icons.location_city,
              //color: Theme.of(context).primaryColor,
              size: 18,),
            SizedBox(width: 6,),
            Text(contact['address'], style: TextStyle(fontSize: 14,
                //color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w400),),

          ],),
          SizedBox(height: 10,),
          Row(children: [
            Icon(Icons.place,
              //color: Theme.of(context).primaryColor,
              size: 18,),
            Text(contact['cep'], style: TextStyle(fontSize: 14,
                //color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w400),),
            SizedBox(width: 20,),
            Icon(Icons.cake,
              //color: Theme.of(context).primaryColor,
              size: 18,),
            SizedBox(width: 3,),
            Text(contact['birthday'], style: TextStyle(fontSize: 14,
                //color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w400),),

          ],),
          SizedBox(height: 25,),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [

            GestureDetector(onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (_) => EditContact(contactKey: contact['key'],
              )));
            },
            child: Row(
              children: [
              Icon(Icons.edit, size: 18, color: Colors.white30),
                SizedBox(width: 6,),
                Text('Editar',
                style: TextStyle(
                  color: Colors.white30
                ),)
            ],)),
              SizedBox(width: 18,),
              GestureDetector(onTap: (){
                _showDeleteDialog(contact: contact);
              },
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 18, color: Colors.white30),
                      SizedBox(width: 6,),
                      Text('Excluir',
                        style: TextStyle(
                            color: Colors.white30
                        ),)
                    ],))

          ],)

        ],
      ),
    );
  }

  _showDeleteDialog({Map contact}){
    showDialog(context: context, builder: (context){
      return AlertDialog(title: Text('Deletar ${contact['name']}'),
      content: Text('Você tem certeza que quer deletar este contato?'),

        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          },
          child: Text('Não')),

          TextButton(onPressed: (){
            reference.child(contact['key']).remove().whenComplete(() => Navigator.pop(context));
          },
              child: Text('Deletar')),

        ],

      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Contatos'),

      ),

      body: Container(
        height: double.infinity,
        child: FirebaseAnimatedList(query: _ref, itemBuilder: (BuildContext context,
            DataSnapshot snapshot, Animation<double> animation, int index) {
          Map contact = snapshot.value;
          contact['key'] = snapshot.key;
          return _buildContactItem(contact: contact);
        },),
      ),




      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (_){
          return AddContacts();
        }));
      },
        child: Icon(Icons.add),
      ),
    );
  }
}
