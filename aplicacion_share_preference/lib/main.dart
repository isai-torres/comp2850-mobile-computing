import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;
  String userName = "";
  String preferredLanguage = "español"; // Idioma predeterminado
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _loadPreferences();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('isDarkMode') ?? false;
      userName = prefs.getString('userName') ?? "";
      preferredLanguage = prefs.getString('preferredLanguage') ?? "español";
      _controller.text = userName;
    });
  }

  Future<void> _saveThemePreference(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', value);
  }

  Future<void> _saveUserName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userName', name);
  }

  Future<void> _saveLanguagePreference(String language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('preferredLanguage', language);
  }

  Future<void> _resetPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Borra todas las preferencias almacenadas
    setState(() {
      isDarkMode = false;
      userName = "";
      preferredLanguage = "español";
      _controller.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Preferencias restablecidas.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Preferencias de Usuario"),
        ),
        body: Builder(
          builder: (BuildContext context) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: "Nombre de Usuario",
                  ),
                  onChanged: (value) {
                    userName = value;
                  },
                  controller: _controller,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isDarkMode = false;
                          _saveThemePreference(isDarkMode);
                        });
                      },
                      child: const Text("Modo Claro"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isDarkMode = true;
                          _saveThemePreference(isDarkMode);
                        });
                      },
                      child: const Text("Modo Oscuro"),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                DropdownButton<String>(
                  value: preferredLanguage,
                  items: const [
                    DropdownMenuItem(value: "español", child: Text("Español")),
                    DropdownMenuItem(value: "inglés", child: Text("Inglés")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      preferredLanguage = value!;
                      _saveLanguagePreference(preferredLanguage);
                    });
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _saveUserName(userName);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Preferencias guardadas.'),
                      ),
                    );
                  },
                  child: const Text("Guardar Preferencias"),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _resetPreferences,
                  child: const Text("Restablecer Preferencias"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
