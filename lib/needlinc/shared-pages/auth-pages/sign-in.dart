import 'package:flutter/material.dart';
import 'package:needlinc/needlinc/needlinc-variables/colors.dart';
import 'package:needlinc/needlinc/shared-pages/auth-pages/Forgot_Password.dart';
import 'package:needlinc/needlinc/shared-pages/auth-pages/sign-up.dart';
import 'package:needlinc/needlinc/shared-pages/construction.dart';
import 'package:needlinc/needlinc/widgets/snack-bar.dart';
import 'package:needlinc/needlinc/widgets/login-background.dart';
// import '../../backend/authentication/google-auth.dart';
import '../../backend/authentication/login.dart';
import '../../widgets/TextFieldBorder.dart';
import '../../widgets/page-transition.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool isChecked = false;

  void check(bool? newValue) {
    setState(() {
      isChecked = newValue ?? false;
    });
  }

  final _formField = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  bool passToggle = true;
  bool notLoading = true;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: notLoading
            ? SingleChildScrollView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                child: Stack(
                  children: [
                    const backGround(),
                    Padding(
                      padding:
                          EdgeInsets.fromLTRB(15, screenHeight * 0.2, 15, 15),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(15, 30, 15, 18),
                        decoration: BoxDecoration(
                          color: NeedlincColors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0, 3),
                              blurRadius: 3.0,
                              spreadRadius: 1.0,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Welcome to NEEDLINC
                            RichText(
                              text: const TextSpan(
                                text: 'WELCOME TO ',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: NeedlincColors.black1,
                                  fontWeight: FontWeight.w400,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'NEEDLINC',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                      color: NeedlincColors.blue1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(22, 0, 22, 0),
                              child: Form(
                                key: _formField,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // input Email
                                    SizedBox(
                                      height: 35,
                                      child: TextFormField(
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        controller: emailController,
                                        focusNode: _focusNode1,
                                        onEditingComplete: () {
                                          _fieldFocusChange(context,
                                              _focusNode1, _focusNode2);
                                        },
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Enter Email";
                                          }
                                          return null;
                                          // Email Check function
                                        },
                                        decoration: const InputDecoration(
                                          labelText: 'Email',
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          prefixIcon: Icon(Icons.email),
                                          focusedBorder: Borders.FocusedBorder,
                                          enabledBorder: Borders.EnabledBorder,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    // input password
                                    SizedBox(
                                      height: 35,
                                      child: TextFormField(
                                        controller: passwordController,
                                        obscureText: passToggle,
                                        focusNode: _focusNode2,
                                        onEditingComplete: () async {
                                          try {
                                            notLoading = false;
                                            setState(() {});
                                            await loginUser(
                                              emailController.text.trim(),
                                              passwordController.text,
                                              context,
                                            );
                                            notLoading = true;
                                            setState(() {});
                                            // Add your logic for Client sign-in here
                                            if (_formField.currentState!
                                                .validate()) {
                                              emailController.clear();
                                              passwordController.clear();
                                            }
                                          } catch (error) {
                                            showSnackBar(context, 'Ooops!!!',
                                                '$error', NeedlincColors.red);
                                          }
                                        },
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Enter Password";
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          labelText: 'Password',
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 8.0),
                                          focusedBorder: Borders.FocusedBorder,
                                          enabledBorder: Borders.EnabledBorder,
                                          prefixIcon: const Icon(Icons.lock),
                                          suffixIcon: InkWell(
                                            onTap: () {
                                              setState(() {
                                                passToggle = !passToggle;
                                              });
                                            },
                                            child: Icon(
                                              passToggle
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    // Sign in button
                                    ElevatedButton(
                                      onPressed: () async {
                                        try {
                                          notLoading = false;
                                          setState(() {});
                                          await loginUser(
                                            emailController.text.trim(),
                                            passwordController.text,
                                            context,
                                          );
                                          notLoading = true;
                                          setState(() {});
                                          // Add your logic for Client sign-in here
                                          if (_formField.currentState!
                                              .validate()) {
                                            emailController.clear();
                                            passwordController.clear();
                                          }
                                        } catch (error) {
                                          // Print error
                                          print(error);
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: NeedlincColors.blue1,
                                        fixedSize:
                                            const Size(double.maxFinite, 27),
                                        shape: const BeveledRectangleBorder(
                                          borderRadius: BorderRadius.zero,
                                        ),
                                      ),
                                      child: const Text(
                                        'Sign in',
                                        style: TextStyle(
                                            color: NeedlincColors.white),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    // create new account
                                    TextButton(
                                      onPressed: () => Navigator.push(
                                          context,
                                          SizeTransition5(
                                              const CreateAccountPage())),
                                      style: TextButton.styleFrom(
                                        fixedSize:
                                            const Size(double.maxFinite, 28),
                                        shape: const BeveledRectangleBorder(
                                          side: BorderSide(
                                            color: NeedlincColors.blue1,
                                          ),
                                          borderRadius: BorderRadius.zero,
                                        ),
                                      ),
                                      child: const Text(
                                        'Create New Account',
                                        style: TextStyle(
                                          color: NeedlincColors.blue1,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    // forgot password
                                    GestureDetector(
                                      onTap: () => Navigator.push(context,
                                          SizeTransition5(const ForgotPass())),
                                      child: const Text(
                                        'forgot password? Click here to reset',
                                        style: TextStyle(
                                          color: NeedlincColors.blue1,
                                          fontSize: 12,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 45),
              
                                    /** //TODO: bEGIN OF COMMENT ACTION
                                    // or sign up as
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          height: 1,
                                          width: 73,
                                          color: NeedlincColors.black1,
                                        ),
                                        const SizedBox(width: 3),
                                        const Text(
                                          "or sign up as",
                                          style: TextStyle(fontSize: 10),
                                        ),
                                        const SizedBox(width: 3),
                                        Container(
                                          height: 1,
                                          width: 73,
                                          color: NeedlincColors.black1,
                                        ),
                                      ],
                                    ),
                                    
                  
                                    // sign up with google
              
                                    
                                    TextButton.icon(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) =>
                                              const Construction(),
                                        );
                                        // signUpWithGoogle();
                                      },
                                      icon: SizedBox(
                                        child: Image.asset(
                                          "assets/google_icon.png",
                                          height: 45,
                                          width: 45,
                                        ),
                                      ),
                                      label: const Text(
                                        'Sign up with Google',
                                        style: TextStyle(
                                            color: NeedlincColors.black1),
                                      ),
                                      style: TextButton.styleFrom(
                                        fixedSize:
                                            const Size(double.maxFinite, 28),
                                        shape: const BeveledRectangleBorder(
                                          side: BorderSide(
                                            color: NeedlincColors.black1,
                                          ),
                                          borderRadius: BorderRadius.zero,
                                        ),
                                      ),
                                    ),
                                    
                                    
                                    
                                    // sign up with facebook
                                    TextButton.icon(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) =>
                                              const Construction(),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.facebook,
                                        color: NeedlincColors.blue1,
                                      ),
                                      label: const Text(
                                        'Sign up with Facebook',
                                        style: TextStyle(
                                            color: NeedlincColors.black1),
                                      ),
                                      style: TextButton.styleFrom(
                                        fixedSize:
                                            const Size(double.maxFinite, 28),
                                        shape: const BeveledRectangleBorder(
                                          side: BorderSide(
                                            color: NeedlincColors.black1,
                                          ),
                                          borderRadius: BorderRadius.zero,
                                        ),
                                      ),
                                    ),
                                    */  //TODO: END OF COMMENT ACTON
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  void _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
