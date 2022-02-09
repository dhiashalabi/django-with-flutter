import 'package:flutter/material.dart';
import 'package:givememedicineapp/src/screens/doctor_screen.dart';
import 'package:givememedicineapp/src/screens/sales_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Give Me Medicine',
            style: GoogleFonts.merienda(),
          ),
        ),
        body: const HomeScreenPage(),
      ),
      routes: {
        '/doctor': (context) => const DoctorScreen(),
        '/representative': (context) => const SalesScreen(),
      },
    );
  }
}

class HomeScreenPage extends StatefulWidget {
  const HomeScreenPage({Key? key}) : super(key: key);

  @override
  _HomeScreenPageState createState() => _HomeScreenPageState();
}

class _HomeScreenPageState extends State<HomeScreenPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Card(
            child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onTap: () {
                Navigator.pushNamed(context, '/doctor');
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Image(
                      image: AssetImage('images/doctor.png'),
                      height: 70,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Doctor List',
                      style: GoogleFonts.merienda(fontSize: 20.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Card(
            child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onTap: () {
                Navigator.pushNamed(context, '/representative');
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Image(
                      image: AssetImage('images/add_medical.png'),
                      height: 70,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Sales',
                      style: GoogleFonts.merienda(fontSize: 20.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
