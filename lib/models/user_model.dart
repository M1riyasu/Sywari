import 'package:flutter/cupertino.dart';
import 'package:sywari/services/preferences_service.dart';

class UserModel extends ChangeNotifier {
  bool splashDone = false;
  String selectedRole = '0';
  String selectedGroup = 'FCFE9537598C08EA';
  String selectedTeacher = 'B18DE74A65AA13C8';
  String selectedPeriod = '100000';

  void loadUserData() {
    // Здесь можно добавить логику загрузки данных пользователя
  }

  void updateRole(String newRole) {
    selectedRole = newRole;
    notifyListeners();
  }

  void updateGroup(String newGroup) {
    selectedGroup = newGroup;
    notifyListeners();
  }

  void updateTeacher(String newTeacher) {
    selectedTeacher = newTeacher;
    notifyListeners();
  }

  void updatePeriod(String newPeriod) {
    selectedPeriod = newPeriod;
    notifyListeners();
  }
}
