class Period {
  final String name;
  final String short;
  final String period;
  final String startTime;
  final String endTime;

  Period(
      {required this.name,
      required this.short,
      required this.period,
      required this.startTime,
      required this.endTime});

  factory Period.fromJson(Map<String, dynamic> json) {
    return Period(
      name: json['_name'],
      short: json['_short'],
      period: json['_period'],
      startTime: json['_starttime'],
      endTime: json['_endtime'],
    );
  }
}

class Subject {
  final String id;
  final String name;
  final String short;
  final String partnerId;

  Subject(
      {required this.id,
      required this.name,
      required this.short,
      required this.partnerId});

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['_id'],
      name: json['_name'],
      short: json['_short'],
      partnerId: json['_partner_id'],
    );
  }
}

class Group {
  final String id;
  final String name;
  final String classId;
  final String studentIds;
  final String entireClass;
  final String divisionTag;
  final String studentCount;
  Group({
    required this.id,
    required this.name,
    required this.classId,
    required this.studentIds,
    required this.entireClass,
    required this.divisionTag,
    required this.studentCount,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['_id'],
      name: json['_name'],
      classId: json['_classid'],
      studentIds: json['_studentids'],
      entireClass: json['_entireclass'],
      divisionTag: json['_divisiontag'],
      studentCount: json['_studentcount'],
    );
  }
}

class Teacher {
  final String id;
  final String firstname;
  final String lastname;
  final String name;
  final String short;
  final String gender;
  final String color;
  final String email;
  final String mobile;
  final String partnerId;
  Teacher({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.name,
    required this.short,
    required this.gender,
    required this.color,
    required this.email,
    required this.mobile,
    required this.partnerId,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['_id'],
      firstname: json['_firstname'],
      lastname: json['_lastname'],
      name: json['_name'],
      short: json['_short'],
      gender: json['_gender'],
      color: json['_color'],
      email: json['_email'],
      mobile: json['_mobile'],
      partnerId: json['_partner_id'],
    );
  }
}

class ClassRoom {
  final String id;
  final String name;
  final String short;
  final String capacity;
  final String partnerId;
  ClassRoom({
    required this.id,
    required this.name,
    required this.short,
    required this.capacity,
    required this.partnerId,
  });

  factory ClassRoom.fromJson(Map<String, dynamic> json) {
    return ClassRoom(
      id: json['_id'],
      name: json['_name'],
      short: json['_short'],
      capacity: json['_capacity'],
      partnerId: json['_partner_id'],
    );
  }
}

class Grade {
  final String name;
  final String short;
  final String grade;
  Grade({
    required this.name,
    required this.short,
    required this.grade,
  });

  factory Grade.fromJson(Map<String, dynamic> json) {
    return Grade(
      name: json['_name'],
      short: json['_short'],
      grade: json['_grade'],
    );
  }
}

class Classes {
  final String id;
  final String name;
  final String short;
  final String teacherId;
  final String classroomIds;
  final String grade;
  final String partnerId;
  Classes({
    required this.id,
    required this.name,
    required this.short,
    required this.teacherId,
    required this.classroomIds,
    required this.grade,
    required this.partnerId,
  });

  factory Classes.fromJson(Map<String, dynamic> json) {
    return Classes(
      id: json['_id'],
      name: json['_name'],
      short: json['_short'],
      teacherId: json['_teacherid'],
      classroomIds: json['_classroomids'],
      grade: json['_grade'],
      partnerId: json['_partner_id'],
    );
  }
}

class Lesson {
  final String id;
  final String classIds;
  final String subjectId;
  final String periodsPerCard;
  final String periodsPerWeek;
  final String teacherIds;
  final String classRoomIds;
  final String groupIds;
  final String capacity;
  final String seminarGroup;
  final String termsdefid;
  final String weeksdefid;
  final String daysdefid;
  final String partnerId;

  Lesson({
    required this.id,
    required this.classIds,
    required this.subjectId,
    required this.periodsPerCard,
    required this.periodsPerWeek,
    required this.teacherIds,
    required this.classRoomIds,
    required this.groupIds,
    required this.capacity,
    required this.seminarGroup,
    required this.termsdefid,
    required this.weeksdefid,
    required this.daysdefid,
    required this.partnerId,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['_id'],
      classIds: json['_classids'],
      subjectId: json['_subjectid'],
      periodsPerCard: json['_periodspercard'],
      periodsPerWeek: json['_periodsperweek'],
      teacherIds: json['_teacherids'],
      classRoomIds: json['_classroomids'],
      groupIds: json['_groupids'],
      capacity: json['_capacity'],
      seminarGroup: json['_seminargroup'],
      termsdefid: json['_termsdefid'],
      weeksdefid: json['_weeksdefid'],
      daysdefid: json['_daysdefid'],
      partnerId: json['_partner_id'],
    );
  }
}

class Card {
  final String lessonId;
  final String classroomIds;
  final String period;
  final String weeks;
  final String terms;
  final String days;

  Card({
    required this.lessonId,
    required this.classroomIds,
    required this.period,
    required this.weeks,
    required this.terms,
    required this.days,
  });

  factory Card.fromJson(Map<String, dynamic> json) {
    return Card(
      lessonId: json['_lessonid'],
      classroomIds: json['_classroomids'],
      period: json['_period'],
      weeks: json['_weeks'],
      terms: json['_terms'],
      days: json['_days'],
    );
  }
}

class Daysdef {
  final String id;
  final String name;
  final String short;
  final String days;

  Daysdef(
      {required this.id,
      required this.name,
      required this.short,
      required this.days});

  factory Daysdef.fromJson(Map<String, dynamic> json) {
    return Daysdef(
      id: json['_id'],
      name: json['_name'],
      short: json['_short'],
      days: json['_days'],
    );
  }
}

class Weeksdef {
  final String id;
  final String name;
  final String short;
  final String weeks;

  Weeksdef(
      {required this.id,
      required this.name,
      required this.short,
      required this.weeks});

  factory Weeksdef.fromJson(Map<String, dynamic> json) {
    return Weeksdef(
      id: json['_id'],
      name: json['_name'],
      short: json['_short'],
      weeks: json['_weeks'],
    );
  }
}

class ClassLessons {
  final String className;
  final String classId;
  final Map<String, Period> periods;
  final Map<String, ClassRoom> classRooms;
  final Map<String, Group> groups;
  final Map<String, Teacher> teachers;
  final Map<String, Subject> subjects;
  final Map<String, Lesson> lessons;
  final List<Card> cards;
  ClassLessons({
    required this.className,
    required this.classId,
    required this.periods,
    required this.classRooms,
    required this.groups,
    required this.teachers,
    required this.subjects,
    required this.lessons,
    required this.cards,
  });
  ClassLessons copyWith({
    String? className,
    String? classId,
    Map<String, Period>? periods,
    Map<String, ClassRoom>? classRooms,
    Map<String, Group>? groups,
    Map<String, Teacher>? teachers,
    Map<String, Subject>? subjects,
    Map<String, Lesson>? lessons,
    List<Card>? cards,
  }) {
    return ClassLessons(
      className: className ?? this.className,
      classId: classId ?? this.classId,
      periods: periods ?? this.periods,
      classRooms: classRooms ?? this.classRooms,
      groups: groups ?? this.groups,
      teachers: teachers ?? this.teachers,
      subjects: subjects ?? this.subjects,
      lessons: lessons ?? this.lessons,
      cards: cards ?? this.cards,
    );
  }
}

class TeacherLessons {
  final String teacherName;
  final String teacherId;
  final Map<String, Period> periods;
  final Map<String, Group> groups;
  final Map<String, Classes> classes;
  final Map<String, ClassRoom> classRooms;
  final Map<String, Subject> subjects;
  final Map<String, Lesson> lessons;
  final List<Card> cards;
  TeacherLessons({
    required this.teacherName,
    required this.teacherId,
    required this.periods,
    required this.groups,
    required this.classes,
    required this.classRooms,
    required this.subjects,
    required this.lessons,
    required this.cards,
  });
  factory TeacherLessons.fromData(Map<String, dynamic> data) {
    return TeacherLessons(
      teacherName: data['teachername'],
      teacherId: data['teacherid'],
      periods: data['periods'],
      groups: data['groups'],
      classes: data['classes'],
      classRooms: data['classrooms'],
      subjects: data['subjects'],
      lessons: data['lessons'],
      cards: data['cards'],
    );
  }
}

class Schedule {
  final List<Period> periods;
  final List<Daysdef> daysdef;
  final List<Weeksdef> weeksdef;
  final List<Group> groups;
  static late List<Teacher> teachers;
  static late List<Lesson> lessons;
  final List<Card> cards;
  static late List<Classes> classes;
  final List<Grade> grades;
  final List<ClassRoom> classRooms;
  static late List<Subject> subjects;
  final ClassLessons classLesson;
  final TeacherLessons teacherLesson;

  Schedule({
    required this.periods,
    required this.daysdef,
    required this.weeksdef,
    required this.groups,
    required this.cards,
    required this.grades,
    required this.classRooms,
    required this.classLesson,
    required this.teacherLesson,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    List<Lesson> lessons = (json['lessons']['lesson'] as List)
        .map((e) => Lesson.fromJson(e))
        .toList();
    List<Card> cards =
        (json['cards']['card'] as List).map((e) => Card.fromJson(e)).toList();
    List<Teacher> teachers = (json['teachers']['teacher'] as List)
        .map((e) => Teacher.fromJson(e))
        .toList();
    List<ClassRoom> classRooms = (json['classrooms']['classroom'] as List)
        .map((e) => ClassRoom.fromJson(e))
        .toList();
    List<Classes> classes = (json['classes']['class'] as List)
        .map((e) => Classes.fromJson(e))
        .toList();
    List<Subject> subjects = (json['subjects']['subject'] as List)
        .map((e) => Subject.fromJson(e))
        .toList();
    List<Group> groups = (json['groups']['group'] as List)
        .map((e) => Group.fromJson(e))
        .toList();
    List<Period> periods = (json['periods']['period'] as List)
        .map((e) => Period.fromJson(e))
        .toList();
    var groupClasses = {
      for (var groupClass in groups)
        if (classes.first.id == groupClass.classId) groupClass.id: groupClass
    };
    var lessonGroups = {
      for (var lesson in lessons)
        if (classes.first.id == lesson.classIds) lesson.id: lesson
    };
    var _teachersList = teachers.where((teacher) => lessonGroups.values
        .any((lessonGroup) => teacher.id == lessonGroup.teacherIds));

    var _subjectsList = subjects.where((subject) => lessonGroups.values
        .any((lessonGroup) => subject.id == lessonGroup.subjectId));

    var _teachers = {
      for (var lessonGroup in lessonGroups.values)
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

    var _classes = {for (var _class in classes) _class.teacherId: _class};

    var _classRooms = {
      for (var classRoom in classRooms) classRoom.id: classRoom
    };

    var _periods = {for (var period in periods) period.period: period};

    List<Card> filteredCards = cards
        .where(
          (card) => lessonGroups.values.first.id == card.lessonId,
        )
        .toList();
    ClassLessons classLesson = ClassLessons(
      className: classes.first.name,
      classId: classes.first.id,
      periods: _periods,
      classRooms: _classRooms,
      subjects: _subjects,
      lessons: lessonGroups,
      teachers: _teachers,
      groups: groupClasses,
      cards: filteredCards,
    );
    TeacherLessons teacherLesson = TeacherLessons(
      teacherName: _teachers.values.first.name,
      teacherId: _teachers.values.first.id,
      periods: _periods,
      classes: _classes,
      classRooms: _classRooms,
      subjects: _subjects,
      lessons: lessonGroups,
      groups: groupClasses,
      cards: filteredCards,
    );
    Schedule.classes = classes;
    Schedule.teachers = teachers;
    Schedule.lessons = lessons;
    Schedule.subjects = subjects;
    return Schedule(
      periods: periods,
      daysdef: (json['daysdefs']['daysdef'] as List)
          .map((e) => Daysdef.fromJson(e))
          .toList(),
      weeksdef: (json['weeksdefs']['weeksdef'] as List)
          .map((e) => Weeksdef.fromJson(e))
          .toList(),
      groups: groups,
      cards: cards,
      grades: (json['grades']['grade'] as List)
          .map((e) => Grade.fromJson(e))
          .toList(),
      classRooms: classRooms,
      classLesson: classLesson,
      teacherLesson: teacherLesson,
    );
  }
}
