import 'package:contacts/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_core/firebase_core.dart';


    class MyScopedModel extends Model{

      bool _isLoading = false;
      bool get isLoading => _isLoading;

      bool _loginInProgress = false;
      bool get loginInProgress => _loginInProgress;

      Future<Map<String, dynamic>> registerUser(UserModel user) async{
        _isLoading = true;
        //Firebase.initializeApp()
        FirebaseAuth auth = FirebaseAuth.instance;


        try{

          UserCredential result = await auth.createUserWithEmailAndPassword(
              email: user.email, password: user.password);
          User loggedInUser = result.user;
          //String uid = loggedInUser.uid;

          _isLoading = false;

          return {'success': true,
            'message': 'Sign up success'};

        } on FirebaseAuthException catch(e){
          _isLoading = false;
          return {'success': false,
            'message': e.message};
        }

      }


      Future<Map<String, dynamic>> loginUser(UserModel user) async{
        _loginInProgress = true;
        //Firebase.initializeApp()
        FirebaseAuth auth = FirebaseAuth.instance;


        try{

          UserCredential result = await auth.signInWithEmailAndPassword(
              email: user.email, password: user.password);
          User loggedInUser = result.user;
          //String uid = loggedInUser.uid;
          _loginInProgress = false;

          return {'success': true,
            'message': 'Log in success'};

        } on FirebaseAuthException catch(e){
          _loginInProgress = false;
          return {'success': false,
            'message': e.message};
        }

      }
    }