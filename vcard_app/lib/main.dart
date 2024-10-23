import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(VCardApp());

class VCardApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'V_Card',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: VCardScreen(),
    );
  }
}

class VCardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Tarjeta Digital'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // Desplazamiento de la sobra
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(
                        'assets/imagen-perfil.png'), // Imagen de perfil
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Isai L Torres',
                    style: GoogleFonts.lato(
                        fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'isai-email@gmail.com',
                    style: GoogleFonts.openSans(fontSize: 16),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '+1 (234) 567-8901',
                    style: GoogleFonts.openSans(fontSize: 16),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'github/isai-torres',
                    style:
                        GoogleFonts.openSans(fontSize: 16, color: Colors.blue),
                  ),
                  SizedBox(height: 20),
                  Image.asset(
                    // Qr code
                    'assets/qr-code.png',
                    width: 100,
                    height: 100,
                  ),
                  SizedBox(height: 20), //Botón de Expansion
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          'Usuario de Github: isai-torres',
                          style: GoogleFonts.openSans(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
