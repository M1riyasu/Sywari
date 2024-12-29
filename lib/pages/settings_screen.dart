import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:sywari/models/user_model.dart';
import 'package:sywari/models/data_model.dart' as data;
import 'package:sywari/services/preferences_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:sywari/services/auth_service.dart';
import 'package:sywari/widgets/login_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final Map<String, String> _roleCodes = {
    '0': "Студент",
    '1': "Преподаватель",
    '2': "Сотрудник",
  };
  late final bool isDark = Theme.of(context).brightness == Brightness.dark;
  bool _showLogin = false;
  bool _isAdmin = true;
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    await Future.wait(<Future>[
      PreferencesService.init(),
    ]);
    final userModel = Provider.of<UserModel>(context, listen: false);
    userModel.loadUserData();
    setState(() {});
  }

  Future<void> _receiveTimeFromServer() async {
    try {
      var uri = Uri.parse('http://192.168.1.239:8080/api/files/earliest/time');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        // Парсим JSON-ответ
        final data = (response.body);

        // Предполагаем, что поле "dateTime" содержит LocalDateTime в формате ISO 8601
        final dateTimeString = data as String;
        final parsedDateTime = DateTime.parse(dateTimeString);
      } else {
        print('Ошибка: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Произошла ошибка: $e')),
      );
      print('$e');
    }
  }

  Future<void> _receiveScheduleFromServer() async {
    try {
      var uri = Uri.parse('http://192.168.1.239:8080/api/files/earliest');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = (response.body);

        final schedule = data as String;
      } else {
        print('Ошибка: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Произошла ошибка: $e')),
      );
      print('$e');
    }
  }

  Future<void> _receiveTeacherHoursFromServer() async {
    try {
      var uri = Uri.parse('http://192.168.1.239:8080/api/files/teachershours');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        String jsonResponse = response.body;
        var decodedMap = jsonDecode(jsonResponse);

// Ensure that decodedMap is of type Map<String, Map<String, int>> and cast it properly
        Map<String, Map<String, int>> typedMap = {};
        decodedMap.forEach((key, value) {
          if (value is Map) {
            typedMap[key] = Map<String, int>.from(value);
          }
        });

// Construct the result string
        String result = 'Занятия и потраченные часы у преподавателя '
            '${data.Schedule.teachers.firstWhere((teacher) => teacher.id == PreferencesService.getString('selectedTeacher')).name}: ';

// 1. Iterate over the first-level keys (e.g., 1CDCFDA7685B51B3, 0EA064017AF8BB70)
        typedMap.forEach((firstLevelKey, firstLevelMap) {
          if (firstLevelKey ==
              PreferencesService.getString('selectedTeacher')) {
            // 2. Iterate over the second-level keys (subjects)
            firstLevelMap.forEach((secondLevelKey, value) {
              // Check if the subject exists in the data.Schedule.subjects list
              var subject = data.Schedule.subjects.firstWhere(
                  (subject) => subject.id == secondLevelKey,
                  orElse: () => data.Subject(
                      id: '',
                      name: '',
                      short: '',
                      partnerId: '') // Return null if no subject is found
                  );

              if (subject != null) {
                result += '${subject.name}: $value ';
              } else {
                result += 'Unknown Subject: $value ';
              }
            });
          }
        });
        showCustomPopup(context, result);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Произошла ошибка: ${response.statusCode}')),
        );
        print('Ошибка: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Произошла ошибка: $e')),
      );
      print('$e');
    }
  }

  void showCustomPopup(BuildContext context, String result) {
    final overlay =
        Overlay.of(context); // Получаем Overlay для отображения на экране.
    late final overlayEntry;

    // Создаем позиционированный контейнер с текстом.
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        // Позиционируем окно чуть правее и ниже от центра экрана
        left: MediaQuery.of(context).size.width / 2 -
            150, // смещение по горизонтали
        top: MediaQuery.of(context).size.height / 2 +
            50, // смещение по вертикали
        child: GestureDetector(
          onTap: () {
            overlayEntry.remove();
          },
          child: Material(
            color: Colors
                .transparent, // Прозрачный фон, чтобы не перекрывать другие элементы.
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              width: MediaQuery.of(context).size.width -
                  32 -
                  (MediaQuery.of(context).size.width / 2 -
                      150), // Ширина до правой стороны с отступом
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Wrap(
                // Используем Wrap для динамичного изменения высоты
                children: [
                  Text(
                    result,
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    // Добавляем кастомное окошко в Overlay
    overlay.insert(overlayEntry);

    // Ожидаем, пока пользователь не кликнет куда-либо, чтобы убрать окошко.
  }

  void _pressLogin() {
    setState(() {
      _showLogin = !_showLogin;
      showDialog(
        context: context,
        builder: (_) => LoginWidget(showLogin: true, isDark: isDark,),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark
          ? Color.fromARGB(255, 40, 40, 40)
          : Color.fromARGB(255, 235, 235, 235),
      body: Consumer<UserModel>(
        builder: (context, model, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRoleDropdown(),
                  const SizedBox(height: 20),
                  _buildGroupDropdown(),
                  const SizedBox(height: 20),
                  _buildTeacherDropdown(),
                  const SizedBox(height: 20),
                  (PreferencesService.getString("selectedRole") == '2' ? _buildLogin() : SizedBox(height: 0)),
                  const SizedBox(height: 20),
                  _buildGetHours()
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRoleDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Выберите роль',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: PreferencesService.getString('selectedRole'),
          decoration: InputDecoration(
            filled: true,
            fillColor: isDark ? Colors.grey[800] : Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          hint: Text(_roleCodes['0']!,
              style: TextStyle(color: isDark ? Colors.grey : Colors.black)),
          dropdownColor: isDark ? Color(0xEE505050) : Color(0xEEE0E0E0),
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
          items: _roleCodes.keys.map((role) {
            return DropdownMenuItem<String>(
              value: role,
              child: Text(
                _roleCodes[role]!,
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              PreferencesService.setString('selectedRole', value!);
            });
          },
        ),
      ],
    );
  }

  Widget _buildGroupDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Выберите группу',
          style: TextStyle(
              color: isDark ? Colors.white : Colors.black, fontSize: 16),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: PreferencesService.getString('selectedGroup'),
          decoration: InputDecoration(
            filled: true,
            fillColor: isDark ? Colors.grey[800] : Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          hint: Text('Выберите группу',
              style: TextStyle(color: isDark ? Colors.grey : Colors.black)),
          dropdownColor: isDark ? Color(0xEE505050) : Color(0xEEE0E0E0),
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
          items: data.Schedule.classes.isEmpty
              ? [
                  DropdownMenuItem<String>(
                      value: '',
                      child: Text('Нет доступных групп',
                          style: TextStyle(
                              color: isDark ? Colors.white : Colors.black)))
                ]
              : data.Schedule.classes.map((classs) {
                  return DropdownMenuItem<String>(
                    value: classs.id,
                    child: Text(classs.name,
                        style: TextStyle(
                            color: isDark ? Colors.white : Colors.black)),
                  );
                }).toList(),
          onChanged: (value) {
            PreferencesService.setString('selectedGroup', value!);
          },
        ),
      ],
    );
  }

  Widget _buildTeacherDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Выберите учителя',
          style: TextStyle(
              color: isDark ? Colors.white : Colors.black, fontSize: 16),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: PreferencesService.getString('selectedTeacher'),
          decoration: InputDecoration(
            filled: true,
            fillColor: isDark ? Colors.grey[800] : Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          hint: Text('Выберите учителя',
              style: TextStyle(color: isDark ? Colors.grey : Colors.black)),
          dropdownColor: isDark ? Color(0xEE505050) : Color(0xEEE0E0E0),
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
          items: data.Schedule.teachers.isEmpty
              ? [
                  DropdownMenuItem<String>(
                      value: '',
                      child: Text('Нет доступных учителей',
                          style: TextStyle(
                              color: isDark ? Colors.white : Colors.black)))
                ]
              : data.Schedule.teachers.map((teacher) {
                  return DropdownMenuItem<String>(
                    value: teacher.id,
                    child: Text(teacher.name,
                        style: TextStyle(
                            color: isDark ? Colors.white : Colors.black)),
                  );
                }).toList(),
          onChanged: (value) {
            PreferencesService.setString('selectedTeacher', value!);
          },
        ),
      ],
    );
  }


  Widget _buildGetHours() {
    return ElevatedButton(
      onPressed: _receiveTeacherHoursFromServer,
      child: Text(
        'Получить часы',
        style: TextStyle(color: isDark ? Colors.white : Colors.black),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        // Keep green as is, change other colors
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildLogin() {
    return ElevatedButton(
      onPressed: _pressLogin,
      child: Text(
        'Войти',
        style: TextStyle(color: isDark ? Colors.white : Colors.black),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        // Keep green as is, change other colors
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
