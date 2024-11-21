import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'account.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(AccountAdapter());
  await Hive.openBox<Account>('accounts');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      home: AccountManager(),
    );
  }
}

class AccountManager extends StatefulWidget {
  @override
  _AccountManagerState createState() => _AccountManagerState();
}

class _AccountManagerState extends State<AccountManager> {
  final _serviceNameController = TextEditingController();
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedServiceType = 'WebPage';
  Box<Account> accountBox = Hive.box<Account>('accounts');
  bool _obscurePassword = true;
  int? _editingIndex;

  void _addOrUpdateAccount() {
    if (_editingIndex == null) {
      // Add new account
      final account = Account(
        serviceName: _serviceNameController.text,
        serviceType: _selectedServiceType,
        userName: _userNameController.text,
        password: _passwordController.text,
        createdAt: DateTime.now(),
      );
      accountBox.add(account);
    } else {
      // Update existing account
      final account = Account(
        serviceName: _serviceNameController.text,
        serviceType: _selectedServiceType,
        userName: _userNameController.text,
        password: _passwordController.text,
        createdAt: DateTime.now(),
      );
      accountBox.putAt(_editingIndex!, account);
    }
    _clearFields();
  }

  void _deleteAccount(int index) {
    accountBox.deleteAt(index);
    _clearFields();
  }

  void _clearFields() {
    _serviceNameController.clear();
    _userNameController.clear();
    _passwordController.clear();
    setState(() {
      _selectedServiceType = 'WebPage';
      _editingIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gestor de Cuentas")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _serviceNameController,
              decoration: InputDecoration(labelText: "Nombre del Servicio"),
            ),
            TextField(
              controller: _userNameController,
              decoration: InputDecoration(labelText: "Nombre de Usuario"),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: "Contraseña"),
                    obscureText: _obscurePassword,
                  ),
                ),
                IconButton(
                  icon: Icon(_obscurePassword
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ],
            ),
            DropdownButton<String>(
              value: _selectedServiceType,
              items: [
                'WebPage',
                'Mobile App',
                'Bank Account',
                'eMail',
                'PC Login',
                'Others',
              ]
                  .map((value) =>
                      DropdownMenuItem(value: value, child: Text(value)))
                  .toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedServiceType = newValue!;
                });
              },
            ),
            ElevatedButton(
              onPressed: _addOrUpdateAccount,
              child: Text(_editingIndex == null
                  ? "Agregar Cuenta"
                  : "Actualizar Cuenta"),
            ),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: accountBox.listenable(),
                builder: (context, Box<Account> box, _) {
                  if (box.isEmpty) {
                    return Center(child: Text("No hay cuentas almacenadas."));
                  }
                  return ListView.builder(
                    itemCount: box.length,
                    itemBuilder: (context, index) {
                      final account = box.getAt(index)!;
                      return ListTile(
                        title: Text(account.serviceName),
                        subtitle: Text(account.serviceType),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                setState(() {
                                  _serviceNameController.text =
                                      account.serviceName;
                                  _selectedServiceType = account.serviceType;
                                  _userNameController.text = account.userName;
                                  _passwordController.text = account.password;
                                  _editingIndex = index;
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => _deleteAccount(index),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
