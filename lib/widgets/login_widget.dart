import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sywari/services/auth_service.dart';

class LoginWidget extends StatefulWidget {
  final bool showLogin, isDark;

  const LoginWidget({Key? key, required this.showLogin, required this.isDark}) : super(key: key);

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoggedIn = false;
  dynamic _selectedFilePath;
  String _token = "";
  bool _obscurePassword = true;

  void _login() async {

    final response = await http.post(
      Uri.parse('http://192.168.1.239:8080/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'login': _usernameController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      await AuthService().saveToken(response.body);
      setState(() {
        _isLoggedIn = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка входа ${response.statusCode}')),
      );
    }
  }

  Future<void> _logout() async {
    setState(() {
      _isLoggedIn = false;
      _token = "";
      _usernameController.clear();
      _passwordController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.showLogin) return const SizedBox.shrink();

    return Center(
      child: _isLoggedIn
          ? GestureDetector(
          onTap: () {},
          child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 16,
              child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildFilePicker(),
                        SizedBox(height: _isLoggedIn ? 20 : 0),
                        _buildSendFileButton(),
                        SizedBox(height: _isLoggedIn ? 20 : 0),
                        _buildSendFileButtonFuture(),
                        SizedBox(height: _isLoggedIn ? 20 : 0),

                        ElevatedButton(
                          onPressed: _logout,
                          child:
                          const Text('Выйти'),
                        ),
                      ]
                  )
              )
          )
      )
        /*,*/

          : GestureDetector(
        onTap: () {},
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 16,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Вход в систему',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Логин',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Пароль',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  obscureText: _obscurePassword,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Войти'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildFilePicker() {
    return _isLoggedIn
        ? ElevatedButton(
      onPressed: _pickFile,
      child: Text(
        'Выберите XML файл',
        style: TextStyle(color: widget.isDark ? Colors.white : Colors.black),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        // Keep blue as is, change other colors
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    )
        : SizedBox(height: 0);
  }

  Widget _buildSendFileButton() {
    return _isLoggedIn
        ? ElevatedButton(
      onPressed: _sendFileToServer,
      child: Text(
        'Отправить файл на сервер',
        style: TextStyle(color: widget.isDark ? Colors.white : Colors.black),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        // Keep green as is, change other colors
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    )
        : SizedBox(height: 0);
  }

  Widget _buildSendFileButtonFuture() {
    return _isLoggedIn
        ? ElevatedButton(
      onPressed: _sendFileToServerFuture,
      child: Text(
        'Отправить файл на сервер на следующую неделю',
        style: TextStyle(color: widget.isDark ? Colors.white : Colors.black),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        // Keep green as is, change other colors
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    )
        : SizedBox(height: 0);
  }
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['xml']);

    if (result != null) {
      setState(() {
        if (kIsWeb) {
          _selectedFilePath = result.files.single.bytes;
        } else {
          _selectedFilePath = result.files.single.path;
        }
      });
    }
  }

  Future<void> _sendFileToServer() async {
    if (_selectedFilePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Пожалуйста, выберите файл для отправки')),
      );
      return;
    }

    try {
      var uri = Uri.parse('http://192.168.1.239:8080/secure/upload/present');
      var request;
      if (kIsWeb) {
        String authHeader = 'Bearer ${await AuthService().getToken()}';
        request = http.MultipartRequest(
          'POST',
          uri,
        )
          ..headers['Authorization'] = authHeader;

        request.files.add(http.MultipartFile.fromBytes(
            'file', // Имя поля для сервера
            _selectedFilePath,
            filename: 'file.xml'));
      } else {
        request = http.MultipartRequest('POST', uri)
          ..files.add(await http.MultipartFile.fromPath(
              'file', _selectedFilePath,
              filename: 'file.xml'));
      }
      var response = await request.send();
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Файл успешно отправлен')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
              Text('Ошибка при отправке файла ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Произошла ошибка: $e')),
      );
      print('$e');
    }
  }

  Future<void> _sendFileToServerFuture() async {
    if (_selectedFilePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Пожалуйста, выберите файл для отправки')),
      );
      return;
    }

    try {
      var uri = Uri.parse('http://192.168.1.239:8080/secure/upload/future');
      var request;
      if (kIsWeb) {
        String authHeader = 'Bearer ${await AuthService().getToken()}';
        request = http.MultipartRequest(
          'POST',
          uri,
        )
          ..headers['Authorization'] = authHeader;

        request.files.add(http.MultipartFile.fromBytes(
            'file', // Имя поля для сервера
            _selectedFilePath,
            filename: 'file.xml'));
      } else {
        request = http.MultipartRequest('POST', uri)
          ..files.add(await http.MultipartFile.fromPath(
              'file', _selectedFilePath,
              filename: 'file.xml'));
      }
      var response = await request.send();
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Файл успешно отправлен')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
              Text('Ошибка при отправке файла ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Произошла ошибка: $e')),
      );
      print('$e');
    }
  }
}
