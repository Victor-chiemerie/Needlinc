import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:needlinc/needlinc/business-pages/home.dart';
import 'package:needlinc/needlinc/needlinc-variables/colors.dart';
import 'package:needlinc/needlinc/shared-pages/auth-pages/welcome.dart';
import 'firebase_options.dart';
import 'needlinc/business-pages/business-main.dart';
import 'needlinc/client-pages/client-main.dart';
import 'needlinc/needlinc-variables/constants.dart';
import 'needlinc/shared-pages/auth-pages/sign-in.dart';
import 'needlinc/shared-pages/user-type.dart';
import 'needlinc/controller/dependenct_injection.dart';
import 'needlinc/widgets/app_update_screen.dart';

void main() async {
  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // Ensure that Flutter is initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  DependencyInjection.init();

  runApp(const Home());

  // Cache data locally
  FirebaseFirestore.instance.settings = Settings(
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const RootPage(),
        '//': (context) => const SignupPage(),
        'client': (context) => ClientMainPages(currentPage: 0),
        'business': (context) => BusinessMainPages(currentPage: 0),
      },
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  bool _isLoading = true;
  bool _updateRequired = false;
  bool _technicalIssues = false;

  @override
  void initState() {
    super.initState();
    _checkAppVersion();
  }

  Future<void> _checkAppVersion() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('update')
          .doc('needlincId')
          .get();

      if (documentSnapshot.exists) {
        Map<String, dynamic>? data = documentSnapshot.data() as Map<String, dynamic>?;
        if (data != null && data.containsKey('appIdVersion')) {
          String appIdVersion = data['appIdVersion'];
          if (appIdVersion != '1st') {
            setState(() {
              _updateRequired = true;
            });
          }
        } else {
          setState(() {
            _technicalIssues = true;
          });
        }
      } else {
        setState(() {
          _technicalIssues = true;
        });
      }
    } catch (e) {
      // Handle errors as needed
      print('Error checking app version: $e');
      setState(() {
        _technicalIssues = true;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_technicalIssues) {
      return const TechnicalIssuesPage();
    }

    if (_updateRequired) {
      return UpdateScreen();
    }

    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            return const UserType();
          } else if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          }
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return const WelcomePage();
      },
    );
  }
}

class TechnicalIssuesPage extends StatelessWidget {
  const TechnicalIssuesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text(
            'Connection Issue',
          style: TextStyle(
              color: NeedlincColors.red
          ),
        )),
      ),
      body:  Center(
        child: Container(
          margin: EdgeInsets.all(10),
          child: Text(
              "Don't panic, this could either be your internet connection or our server, kindly wait for a while and re-try else contact us via needlinc@gmail.com or +2349075797957",
            style: TextStyle(
              color: NeedlincColors.red,
                  fontSize: 20
            ),
              ),
        ),
      ),
    );
  }
}