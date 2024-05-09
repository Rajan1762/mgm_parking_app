import 'package:flutter/material.dart';
import 'package:mgm_parking_app/screens/enrty_screens/entry_screen.dart';
import '../../model/errorResponseModel.dart';
import '../../model/profile_models.dart';
import '../../sevices/network_services/profile_services.dart';
import '../../utils/colors.dart';
import '../../utils/custom_widgets/loading_widgets.dart';
import '../../utils/custom_widgets/notification_widgets.dart';
import '../home_screens/home_main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscureTextStatus = true;

  Future<ErrorResponseModel> _loginUser(
      {required String userName, required String password}) async {
    UserBaseModel? obj;
    String? message;
    try {
      if(userName=='1'&&password=='1')
        {
          obj = UserBaseModel(status: true);
        }else{
        obj = UserBaseModel(status: false);
      }
      // obj = await loginUser(userName: userName, password: password);
      print('obj = $obj');
    } catch (e) {
      message = e.toString();
      print('Error Occurred $e');
    }
    print('objsgsg = $obj');
    return ErrorResponseModel(obj: obj, errorMessage: message);
  }

  @override
  void dispose() {
    userController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Stack(
        children: [
          SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: const Image(
                  image: AssetImage('assets/images/parking_bg_image.jpg'),
                  fit: BoxFit.cover)),
          Center(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 80),
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                decoration: const BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 6)],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('Welcome',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                            letterSpacing: 1.5)),
                    const SizedBox(height: 40,),
                    Column(
                      children: [
                        TextField(
                          controller: userController,
                            decoration: loginTextFieldDesign(true,(){})),
                        const SizedBox(height: 20),
                        TextField(
                          controller: passwordController,
                            obscureText: _obscureTextStatus,
                            decoration: loginTextFieldDesign(false,(){
                              print('_obscureTextStatus = $_obscureTextStatus');
                              _obscureTextStatus = !_obscureTextStatus;
                              setState(() {});
                            }))
                      ],
                    ),
                    const SizedBox(height: 30,),
                    ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(appThemeColor),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                          padding: MaterialStateProperty.all<EdgeInsetsGeometry?>(const EdgeInsets.symmetric(vertical: 10)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                          ),
                        ),
                        onPressed: () async {
                          if(userController.value.text.isNotEmpty && passwordController.value.text.isNotEmpty)
                            {
                              setState(() => _isLoading=true);
                              ErrorResponseModel response = await _loginUser(userName: userController.value.text, password: passwordController.value.text);
                              if (context.mounted) {
                                setState(() => _isLoading=false);
                                if (response.obj != null) {
                                    if(!response.obj.status!)
                                    {
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                        content: Text('UserName Or Password is Incorrect'),
                                      ));
                                    }else{
                                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                                          builder: (context) => const HomeMainScreen()));
                                    }
                                } else {
                                  showErrorAlertDialog(context: context, message: response.errorMessage ?? '');
                                }
                              }
                            }else{
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text('Fill all fields to Login'),
                            ));
                          }
                        },
                        child: const Text(
                          'Log In',
                          style: TextStyle(color: Colors.white,
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ))
                  ],
                ),
              ),
            ),
          ),
          FullScreenLoadingWidget(isLoading: _isLoading)
        ],
      ),
    ));
  }

  InputDecoration loginTextFieldDesign(bool status,Function() onTap) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintText: status ? 'User Name' : 'Password',
      isDense: true,
      suffixIcon: GestureDetector(onTap: onTap,child: Icon(status ? Icons.person_outline : Icons.remove_red_eye_outlined)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      border: loginBorderDesign(),
      focusedBorder: loginBorderDesign(),
      enabledBorder: loginBorderDesign(),
      disabledBorder: loginBorderDesign(),
    );
  }

  OutlineInputBorder loginBorderDesign() {
    return const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.all(Radius.circular(5)));
  }
}
