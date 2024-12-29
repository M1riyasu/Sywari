import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sywari/models/user_model.dart';
import 'package:sywari/models/data_model.dart' as data;
import 'package:sywari/services/preferences_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  late Future<data.Schedule> _scheduleData;
  data.ClassLessons? classLessons;
  var groupSchedule;
  String selectedPeriod = '100000';
  late final bool isDark = Theme.of(context).brightness == Brightness.dark;
  final Map<String, String> _dayCodes = {
    "100000": "Понедельник",
    "010000": "Вторник",
    "001000": "Среда",
    "000100": "Четверг",
    "000010": "Пятница",
    "000001": "Суббота",
  };
  @override
  void initState() {
    super.initState();
    _loadUserData();
    _scheduleData = loadScheduleData();
  }

  Future<void> _loadUserData() async {
    await Future.wait(<Future>[
      PreferencesService.init(),
    ]);
    final userModel = Provider.of<UserModel>(context, listen: false);
    userModel.loadUserData();
    setState(() {});
  }

  Future<data.Schedule> loadScheduleData() async {
    late final Map<String, dynamic> file;
    try {
      if (kIsWeb) {
        if (PreferencesService.getBool('requireUpdate')!) {
          file = json.decode(await _getSchedule());
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Файл успешно получен')),
          );
          PreferencesService.setBool('requireUpdate', false);
        } else {
          try {
            file = json.decode(await readStringFromFile());
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Файл успешно получен не был $e')),
            );
            file = json
                .decode(await rootBundle.loadString('assets/Расписание.json'));
          }
        }
      } else {
        final String response =
            await rootBundle.loadString('assets/Расписание.json');
        file = json.decode(response);
      }
    } catch (e) {
      print(e);
    }
    return data.Schedule.fromJson(file);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark
          ? Color.fromARGB(255, 40, 40, 40)
          : Color.fromARGB(255, 235, 235, 235),
      body: FutureBuilder<data.Schedule>(
        future: _scheduleData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: CircularProgressIndicator());
          } else {
            final schedule = snapshot.data!;
            return Column(
              children: [
                //PreferencesService.getString('selectedRole')
                Align(
                    alignment: Alignment.topCenter,
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 20.0),
                      elevation: 6.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      color: isDark ? Color(0xFF383838) : Color(0xFFFFFFFF),
                      child: Container(
                        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: Text(getChosenText(),
                            style: TextStyle(
                                color: isDark ? Colors.white : Colors.black)),
                      ),
                    )),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: DropdownButtonFormField<String>(
                    value: selectedPeriod,
                    hint: const Text('Выберите период',
                        style: TextStyle(color: Colors.grey)),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: isDark ? Colors.grey[800] : Color(0xFFFFFFFF),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    dropdownColor:
                        isDark ? Color(0xEE505050) : Color(0xEEE0E0E0),
                    style:
                        TextStyle(color: isDark ? Colors.white : Colors.black),
                    items: _dayCodes.keys.map((day) {
                      return DropdownMenuItem<String>(
                        value: day,
                        child: Text(
                          _dayCodes[day]!,
                          style: TextStyle(
                              color: isDark ? Colors.white : Colors.black),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedPeriod = value!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: FutureBuilder<dynamic>(
                    future: PreferencesService.getString('selectedRole') == '0'
                        ? _getGroupLesson(schedule)
                        : _getTeacherLesson(schedule),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {}

                      final classLesson = snapshot.data!;

                      return ListView.builder(
                        itemCount: classLesson.cards.length,
                        itemBuilder: (context, index) {
                          if (PreferencesService.getString('selectedRole') == '0') {
                            final card = classLesson.cards[index];
                            final period = classLesson.periods[card.period];
                            final lesson = classLesson.lessons[card.lessonId];
                            final subject =
                                classLesson.subjects[lesson.subjectId];
                            final teacher =
                                classLesson.teachers[lesson.subjectId];
                            final classRoom =
                                classLesson.classRooms[lesson.classRoomIds];

                            return LessonCard(
                              period: card.period,
                              subjectName: subject.name,
                              teacherName: teacher.name,
                              time: '${period.startTime}—${period.endTime}',
                              classRoomName:
                                  classRoom == null ? '' : classRoom.name,
                              groupName: classLesson.className,
                              key: ValueKey(card.lessonId),
                            );
                          } else {
                            final card = classLesson.cards[index];
                            final period = classLesson.periods[card.period];
                            final lesson = classLesson.lessons[card.lessonId];
                            final subject =
                                classLesson.subjects[lesson.subjectId];
                            final teacher = classLesson.teacherName;
                            final classes =
                                classLesson.classes[lesson.classIds];
                            final classRoom =
                                classLesson.classRooms[lesson.classRoomIds];
                            return LessonCard(
                              period: card.period,
                              subjectName: subject.name,
                              teacherName: teacher,
                              time: '${period.startTime}—${period.endTime}',
                              classRoomName:
                                  classRoom == null ? '' : classRoom.name,
                              groupName: classes.name,
                              key: ValueKey(classLesson.teacherId),
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Future<String> _getSchedule() async {
    String data = await _receiveScheduleFromServer();
    if (data != '') {
      PreferencesService.setString(
          'scheduleTime', await _receiveTimeFromServer());
      PreferencesService.setBool('requireUpdate', false);
      saveStringToFile(data);
      return data;
    } else {
      return readStringFromFile();
    }
  }

  Future<data.ClassLessons> _getGroupLesson(data.Schedule schedule) async {
    var groupClasses = {
      for (var groupClass in schedule.groups) groupClass.id: groupClass
    };
    var lessonGroups = {
      for (var lesson in data.Schedule.lessons)
        if (PreferencesService.getString('selectedGroup') == lesson.classIds)
          lesson.id: lesson
    };
    var _teachersList = data.Schedule.teachers.where((teacher) => lessonGroups
        .values
        .any((lessonGroup) => teacher.id == lessonGroup.teacherIds));
    var _subjectsList = data.Schedule.subjects.where((subject) => lessonGroups
        .values
        .any((lessonGroup) => subject.id == lessonGroup.subjectId));
    var _teachers = {
      for (var lessonGroup in lessonGroups.values)
        if (_teachersList
            .any((teacher) => lessonGroup.teacherIds == teacher.id))
          lessonGroup.subjectId: _teachersList.firstWhere(
            (teacher) => lessonGroup.teacherIds == teacher.id,
          )
    };
    var _subjects = {
      for (var lessonGroup in lessonGroups.values)
        lessonGroup.subjectId: _subjectsList.firstWhere(
          (subject) => subject.id == lessonGroup.subjectId,
        )
    };

    var _classRooms = {
      for (var classRoom in schedule.classRooms) classRoom.id: classRoom
    };

    var _periods = {for (var period in schedule.periods) period.period: period};

    List<data.Card> filteredCards = schedule.cards
        .where((card) => lessonGroups.values.any((lessonGroup) =>
            (card.lessonId == lessonGroup.id) && (card.days == selectedPeriod)))
        .toList();
    filteredCards.sort((first, second) {
      int firstPeriod = int.parse(first.period);
      int secondPeriod = int.parse(second.period);
      return firstPeriod.compareTo(secondPeriod);
    });
    return data.ClassLessons(
      className: data.Schedule.classes
          .firstWhere((_class) =>
              _class.id == PreferencesService.getString('selectedGroup'))
          .name,
      classId:
          PreferencesService.getString('selectedGroup') ?? 'FCFE9537598C08EA',
      periods: _periods,
      classRooms: _classRooms,
      subjects: _subjects,
      lessons: lessonGroups,
      teachers: _teachers,
      groups: groupClasses,
      cards: filteredCards,
    );
  }

  Future<data.TeacherLessons> _getTeacherLesson(data.Schedule schedule) async {
    var groupClasses = {
      for (var groupClass in schedule.groups) groupClass.id: groupClass
    };
    var lessonGroups = {
      for (var lesson in data.Schedule.lessons)
        if (PreferencesService.getString('selectedTeacher') ==
            lesson.teacherIds)
          lesson.id: lesson
    };

    var _subjectsList = data.Schedule.subjects.where((subject) => lessonGroups
        .values
        .any((lessonGroup) => subject.id == lessonGroup.subjectId));

    var classes = {for (var _class in data.Schedule.classes) _class.id: _class};

    var _subjects = {
      for (var lessonGroup in lessonGroups.values)
        lessonGroup.subjectId: _subjectsList.firstWhere(
          (subject) => subject.id == lessonGroup.subjectId,
        )
    };

    var _classRooms = {
      for (var classRoom in schedule.classRooms) classRoom.id: classRoom
    };

    var _periods = {for (var period in schedule.periods) period.period: period};

    List<data.Card> filteredCards = schedule.cards
        .where((card) => lessonGroups.values.any((lessonGroup) =>
            (card.lessonId == lessonGroup.id) && (card.days == selectedPeriod)))
        .toList();
    filteredCards.sort((first, second) {
      int firstPeriod = int.parse(first.period);
      int secondPeriod = int.parse(second.period);
      return firstPeriod.compareTo(secondPeriod);
    });
    return data.TeacherLessons(
      teacherName: data.Schedule.teachers
          .firstWhere((teacher) =>
              teacher.id == PreferencesService.getString('selectedTeacher'))
          .name,
      teacherId:
          PreferencesService.getString('selectedTeacher') ?? 'B18DE74A65AA13C8',
      periods: _periods,
      subjects: _subjects,
      lessons: lessonGroups,
      classes: classes,
      classRooms: _classRooms,
      groups: groupClasses,
      cards: filteredCards,
    );
  }

  String getChosenText() {
    if (PreferencesService.getString('selectedRole') == null) {
      return 'Не выбрано';
    }
    if (PreferencesService.getString('selectedRole') == '0') {
      if (PreferencesService.getString('selectedGroup') == null) {
        return 'Не выбрано';
      }
      return data.Schedule.classes
          .firstWhere((_class) =>
              _class.id == PreferencesService.getString('selectedGroup'))
          .name;
    } else {
      if (PreferencesService.getString('selectedTeacher') == null) {
        return 'Не выбрано';
      }
      return data.Schedule.teachers
          .firstWhere((teacher) =>
              teacher.id == PreferencesService.getString('selectedTeacher'))
          .name;
    }
  }

  Future<String> _receiveTimeFromServer() async {
    try {
      var uri = Uri.parse('http://192.168.1.239:8080/api/files/earliest/time');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = (response.body);

        return data as String;
      } else {
        return '';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Произошла ошибка: $e')),
      );
      return '';
    }
  }

  Future<String> _receiveScheduleFromServer() async {
    try {
      var uri = Uri.parse('http://192.168.1.239:8080/api/files/earliest');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return '';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Произошла ошибка: $e')),
      );
      return '';
    }
  }

  Future<void> saveStringToFile(String content) async {
    if (kIsWeb) {
      await PreferencesService.setString('schedule', content);
    } else {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/schedule.json');
      await file.writeAsString(content);
    }
  }

  Future<String> readStringFromFile() async {
    if (kIsWeb) {
      return PreferencesService.getString('schedule') ?? '';
    } else {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/schedule.json');
      return await file.readAsString();
    }
  }
}

class LessonCard extends StatelessWidget {
  final String period;
  final String subjectName;
  final String teacherName;
  final String time;
  final String classRoomName;
  final String groupName;
  const LessonCard({
    Key? key,
    required this.period,
    required this.subjectName,
    required this.teacherName,
    required this.time,
    required this.classRoomName,
    required this.groupName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
      elevation: 6.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: isCurrentTimeInRange(time)
          ? Colors.blueGrey
          : isDark
              ? Color(0xFF383838)
              : Color(0xFFFFFFFF),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
        ),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 32.0,
                  backgroundColor: isCurrentTimeInRange(time)
                      ? (isDark ? Color(0xFF383838) : Color(0xFFFFFFFF))
                      : Colors.blueAccent,
                  child: Text(
                    period,
                    style: TextStyle(
                      fontSize: 24.0,
                      color: isCurrentTimeInRange(time) ? Colors.blueAccent : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Text(
                    subjectName,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _infoIconText(Icons.person, teacherName, isDark),
                _infoIconText(Icons.access_time, time, isDark),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _infoIconText(Icons.class_, classRoomName, isDark),
                _infoIconText(Icons.group, groupName, isDark),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoIconText(IconData icon, String text, bool isDark) {
    return Row(
      children: [
        Icon(
          icon,
          color: isCurrentTimeInRange(time)
              ? Color(0xFF383838)
              : Colors.blueAccent,
          size: 16.0,
        ),
        const SizedBox(width: 6.0),
        Text(
          text,
          style: TextStyle(
            fontSize: 14.0,
            color: isDark ? Colors.white70 : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  bool isCurrentTimeInRange(String timeRange) {
    List<String> times = timeRange.split('—');
    String startTime = times[0].trim();
    String endTime = times[1].trim();

    DateFormat timeFormat = DateFormat("HH:mm");

    DateTime now = DateTime.now();
    DateTime start = DateTime(now.year, now.month, now.day,
        timeFormat.parse(startTime).hour, timeFormat.parse(startTime).minute);
    DateTime end = DateTime(now.year, now.month, now.day,
        timeFormat.parse(endTime).hour, timeFormat.parse(endTime).minute);

    return now.isAfter(start) && now.isBefore(end);
  }
}
