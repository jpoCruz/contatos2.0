import 'package:contacts/home.dart';
import 'package:contacts/model/user.dart';
import 'package:contacts/scoped_model/my_scoped_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class AuthPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AuthPage();
  }



}

class _AuthPage extends State<AuthPage>{

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  GlobalKey<FormState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Contatos - Autenticação'),),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Form(
          key: _key,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 10,),
              _emailInputWidget(),
              SizedBox(height: 10,),
              _passwordInputWidget(),
              SizedBox(height: 10,),
              _logInWidget(),
              SizedBox(height: 5,),
              _signUpWidget(),
            ],
           ),
          ),
        ),
    );
  }

  Widget _emailInputWidget(){
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(labelText: 'Email'),
      keyboardType: TextInputType.emailAddress,

      validator: (String value){
        if(value.isEmpty){
          return 'Email é necessário!';
        }
      }
    );
  }

  Widget _passwordInputWidget(){
    return TextFormField(
        controller: _passwordController,
        decoration: InputDecoration(labelText: 'Senha'),
        keyboardType: TextInputType.visiblePassword,

        validator: (String value){
          if(value.isEmpty){
            return 'Password is required!';
          }
        }
    );
  }
  
  Widget _signUpWidget(){
    return ScopedModelDescendant<MyScopedModel>(builder: (BuildContext context, Widget child, MyScopedModel model){
      return model.isLoading
          ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
              TextButton(
                onPressed: (){},
                child: Text('Criando conta...'))
            ],
      )
           : ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.cyan, // background
          onPrimary: Colors.white, // foreg
        ),
              child: Text('Crie uma conta'),
              onPressed: () {
                register(model);
              },

            );
      },
    );
  }

  Widget _logInWidget(){
    return ScopedModelDescendant<MyScopedModel>(builder: (BuildContext context, Widget child, MyScopedModel model){
      return model.loginInProgress
          ? Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          TextButton(
              onPressed: (){},
              child: Text('Entrando...'))
        ],
      )
          : ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.cyan, // background
          onPrimary: Colors.white, // foreg
        ),
        child: Text('Login'),
        onPressed: () {
          login(model);
        },
      );
    },
    );
  }

  void register(MyScopedModel model){
    if(_key.currentState.validate()){
      String email = _emailController.text;
      String password = _passwordController.text;

      UserModel user = UserModel();
      user.email = email;
      user.password = password;

      model.registerUser(user).then((Map<String, dynamic> response){
        if(response['success']){
          // redirect to main screen
        }else{
          _customDialog('Erro ao criar conta', response['message']);
        }
      });
    }
  }


  void login(MyScopedModel model){
    if(_key.currentState.validate()){
      String email = _emailController.text;
      String password = _passwordController.text;

      UserModel user = UserModel();
      user.email = email;
      user.password = password;

      model.loginUser(user).then((Map<String, dynamic> response){
        if(response['success']){
          //_customDialog('Login success', 'Welcome!');
          Navigator.push(context, new MaterialPageRoute(builder: (context) => Home()));
        }else{
          _customDialog('Erro ao fazer login', response['message']);
        }
      });
    }
  }

  _customDialog(String title, String message){
    return showDialog(
        context: context,
        builder: (param){
          return AlertDialog(
            title: Text(title),
            content: Text(message),
          );
        }
    );
  }

}//auth page