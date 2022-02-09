import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:givememedicineapp/src/screens/home_screen.dart';
import 'package:givememedicineapp/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/representative_api.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = (prefs.getInt('representativeId') == null) ? false : true;

  runApp(
    OverlaySupport(
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.red,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          scaffoldBackgroundColor: Colors.white,
          fontFamily: GoogleFonts.poppins().fontFamily,
        ),
        home: isLoggedIn ? const HomeScreen() : const MainApp(),
        routes: {
          '/home': (context) => const HomeScreen(),
        },
      ),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Login",
          style: GoogleFonts.merienda(),
        ),
      ),
      body: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late final StreamSubscription subscription;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _pass = TextEditingController();

  @override
  void initState() {
    super.initState();
    subscription =
        Connectivity().onConnectivityChanged.listen(checkConnectivityState);
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  Widget _buildPhone() {
    return TextFormField(
      controller: _phone,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Your Phone Number',
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Enter Your Phone Number.';
        }
        return null;
      },
    );
  }

  Widget _buildPassword() {
    return TextFormField(
      controller: _pass,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Your Password',
      ),
      keyboardType: TextInputType.visiblePassword,
      obscureText: true,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Enter Your Password.';
        }
        return null;
      },
    );
  }

  _saveRepresentative(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('representativeId', id);
    int check = prefs.getInt('representativeId') ?? 0;
    if (check != 0) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  Future<void> getRepresentativeFromApi() async {
    await RepresentativeApi.getRepresentative(ph: _phone.text, pas: _pass.text)
        .then((response) {
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        if (list.isNotEmpty) {
          for (var element in list) {
            _saveRepresentative(element['id']);
          }
        } else {
          showRAlertDialog(
              context,
              'Error!!',
              'Make sure from your account credentials then try again later.',
              AlertType.error);
        }
      } else {
        showRAlertDialog(
            context,
            'Error!!',
            'Make sure that your connected network has internet access.',
            AlertType.error);
      }
    }).timeout(const Duration(seconds: 5), onTimeout: () {
      showRAlertDialog(
          context,
          'Timeout!!',
          'Make sure that your connected network has internet access.',
          AlertType.error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Image(
                  image: AssetImage('images/app.png'),
                  height: 200,
                ),
                const SizedBox(height: 20.0),
                _buildPhone(),
                const SizedBox(height: 20.0),
                _buildPassword(),
                const SizedBox(height: 10.0),
                ElevatedButton(
                  child: const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text('Login'),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      var connectivityResult =
                          Connectivity().checkConnectivity();
                      connectivityResult.then(
                        (value) => {
                          if (value == ConnectivityResult.mobile ||
                              value == ConnectivityResult.wifi)
                            {
                              getRepresentativeFromApi(),
                            }
                          else
                            {
                              showRAlertDialog(
                                  context,
                                  'Error!',
                                  'Make sure you are connected to network and have access to internet.',
                                  AlertType.error),
                            }
                        },
                      );
                    }
                  },
                ),
                const SizedBox(height: 10.0),
                const Center(
                  child: Text(
                    'Forget Password?',
                    style: TextStyle(fontSize: 15.0, color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void checkConnectivityState(ConnectivityResult result) {
    if (result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile) {
      showConnectivitySnackBar(context, result);
    } else if (result == ConnectivityResult.none) {
      showConnectivitySnackBar(context, result);
    }
  }
}
