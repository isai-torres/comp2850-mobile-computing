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
    final fechaActual = DateTime.now();
    final updateDate =
        '${fechaActual.year}-${fechaActual.month}-${fechaActual.day}';

    if (_editingIndex == null) {
      // Agregar nueva cuenta
      final account = Account(
        serviceName: _serviceNameController.text,
        serviceType: _selectedServiceType,
        userName: _userNameController.text,
        password: _passwordController.text,
        createdAt: fechaActual,
        updateHistory:
            updateDate, // Almacena la fecha de creación como historial inicial
      );
      accountBox.add(account);
    } else {
      // Actualizar cuenta existente
      final account = accountBox.getAt(_editingIndex!)!;
      account
        ..serviceName = _serviceNameController.text
        ..serviceType = _selectedServiceType
        ..userName = _userNameController.text
        ..password = _passwordController.text
        ..updateHistory =
            updateDate; // Almacena la nueva fecha de actualización
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
      appBar: AppBar(
        title: const Text("Gestor de Cuentas"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                // Campos de entrada y DropdownButton
                Row(
                  children: [
                    const Text(
                      'Servicio',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: DropdownButton<String>(
                        value: _selectedServiceType,
                        items: [
                          'WebPage',
                          'Mobile App',
                          'Bank Account',
                          'eMail',
                          'PC Login',
                          'Others'
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedServiceType = newValue!;
                          });
                        },
                      ),
                    ),
                  ],
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
                ElevatedButton(
                  onPressed: _addOrUpdateAccount,
                  child: Text(_editingIndex == null
                      ? "Agregar Cuenta"
                      : "Actualizar Cuenta"),
                ),
              ],
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: accountBox.listenable(),
              builder: (context, Box<Account> box, _) {
                if (box.values.isEmpty) {
                  return Center(child: Text("No hay cuentas almacenadas."));
                }
                return ListView.builder(
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    final account = box.getAt(index)!;
                    return ListTile(
                      title: Text(account.serviceName),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tipo de servicio: ${account.serviceType}'),
                          if (account.updateHistory != null)
                            Text(
                                'Última actualización: ${account.updateHistory}'),
                        ],
                      ),
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
    );
  }
}
