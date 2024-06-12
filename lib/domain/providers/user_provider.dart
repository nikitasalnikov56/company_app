import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/api/api.dart';
import 'package:flutter_application_1/domain/contollers/app_controllers.dart';
import 'package:flutter_application_1/domain/model/users.dart';
import 'package:flutter_application_1/ui/routes/app_routes.dart';
import 'package:flutter_application_1/ui/widgets/textfield_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:mysql_client/mysql_client.dart';

class UserProvider extends ChangeNotifier {
  var filteredData = <Users>[];
  List<Users> listUsers = [];
  int userId = 0;

  Future<List<Users>> fetchUsersData() async {
    listUsers = await Api.fetchUsers();
    return listUsers;
  }

  void onSearch(BuildContext context) async {
    final query = AppControllers.searchController.text.toLowerCase();
    await Api.fetchUsers();
    if (query.isNotEmpty) {
      final results = Api.users.where((user) {
        final nameLower = user.associatedClient?.toLowerCase() ?? '';
        userId = user.id ?? 0;

        return nameLower.contains(query);
        // nameLower.length == query.length &&
      }).toList();

      if (results.isEmpty) {
        AppControllers.searchController.clear();
        // ignore: use_build_context_synchronously
        showWindowDialog(context);
      } else {
        filteredData = results;
        AppControllers.searchController.clear();
      }
    } else {
      filteredData = [];
    }
    notifyListeners();
  }

  Future<dynamic> showWindowDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          surfaceTintColor: Colors.transparent,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Пользователь не найден. Добавить?'),
              const SizedBox(height: 6),
              TextFieldWidget(
                controller: AppControllers.associatedClientController,
                labelText: 'Associated Client',
              ),
              const SizedBox(height: 6),
              TextFieldWidget(
                controller: AppControllers.associatedContractController,
                labelText: 'Associated Contract',
              ),
              const SizedBox(height: 6),
              TextFieldWidget(
                controller: AppControllers.lawyerController,
                labelText: 'Lawyer',
              ),
              const SizedBox(height: 6),
              TextFieldWidget(
                controller: AppControllers.beneficiaryNameController,
                labelText: 'BeneficiaryName',
              ),
              const SizedBox(height: 6),
              TextFieldWidget(
                controller: AppControllers.foundersController,
                labelText: 'Founders',
              ),
              const SizedBox(height: 6),
              TextFieldWidget(
                controller: AppControllers.directorController,
                labelText: 'Director',
              ),
              const SizedBox(height: 6),
              TextFieldWidget(
                controller: AppControllers.otherPartiesInDisputeController,
                labelText: 'Other parties in dispute',
              ),
              const SizedBox(height: 6),
              TextFieldWidget(
                controller: AppControllers.associatedCompaniesController,
                labelText: 'Associated Companies',
              ),
              const SizedBox(height: 6),
              TextFieldWidget(
                controller: AppControllers.associatedCasesController,
                labelText: 'Associated Cases',
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Нет'),
            ),
            ElevatedButton(
              onPressed: () {
                addToDatabase(context);
              },
              child: const Text('Да'),
            ),
          ],
        );
      },
    );
  }

  controllerClear() {
    AppControllers.associatedClientController.clear();
    AppControllers.associatedContractController.clear();
    AppControllers.lawyerController.clear();
    AppControllers.beneficiaryNameController.clear();
    AppControllers.foundersController.clear();
    AppControllers.directorController.clear();
    AppControllers.otherPartiesInDisputeController.clear();
    AppControllers.associatedCompaniesController.clear();
    AppControllers.associatedCasesController.clear();
  }

  Future<void> addToDatabase(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final createdBy = prefs.getString('username') ?? 'Unknown';

    final user = Users(
      associatedClient: AppControllers.associatedClientController.text,
      associatedContract: AppControllers.associatedContractController.text,
      lawyer: AppControllers.lawyerController.text,
      beneficiaryName: AppControllers.beneficiaryNameController.text,
      founders: AppControllers.foundersController.text,
      director: AppControllers.directorController.text,
      partiesOfDispute: AppControllers.otherPartiesInDisputeController.text,
      associatedCompanies: AppControllers.associatedCompaniesController.text,
      associatedCases: AppControllers.associatedCasesController.text,
      createdBy: createdBy,
    );
    print(user.createdBy);

    try {
      await Api.addUser(user)
          .then((value) => Navigator.of(context).pop())
          .then((value) => controllerClear());

      // Navigator.of(context).pop();
      notifyListeners();
    } catch (e) {
      print('Failed to add user: $e');
    }
  }

  Future<void> updateData(
      int? userId, BuildContext context, Users updatedData) async {
    final prefs = await SharedPreferences.getInstance();
    final createdBy = prefs.getString('username') ?? 'Unknown';
    try {
      // Обновляем данные на сервере
      await Api.updateUser(userId, updatedData, createdBy);

      // Обновляем пользователя в локальном списке
      final index = listUsers.indexWhere((user) => user.id == userId);
      if (index != -1) {
        // Обновляем только измененные поля
        listUsers[index] = listUsers[index].copyWith(
            associatedClient: updatedData.associatedClient!.isNotEmpty
                ? updatedData.associatedClient
                : listUsers[index].associatedClient,
            associatedContract: updatedData.associatedContract!.isNotEmpty
                ? updatedData.associatedContract
                : listUsers[index].associatedContract,
            lawyer: updatedData.lawyer!.isNotEmpty
                ? updatedData.lawyer
                : listUsers[index].lawyer,
            beneficiaryName: updatedData.beneficiaryName!.isNotEmpty
                ? updatedData.beneficiaryName
                : listUsers[index].beneficiaryName,
            founders: updatedData.founders!.isNotEmpty
                ? updatedData.founders
                : listUsers[index].founders,
            director: updatedData.director!.isNotEmpty
                ? updatedData.director
                : listUsers[index].director,
            partiesOfDispute: updatedData.partiesOfDispute!.isNotEmpty
                ? updatedData.partiesOfDispute
                : listUsers[index].partiesOfDispute,
            associatedCompanies: updatedData.associatedCompanies!.isNotEmpty
                ? updatedData.associatedCompanies
                : listUsers[index].associatedCompanies,
            associatedCases: updatedData.associatedCases!.isNotEmpty
                ? updatedData.associatedCases
                : listUsers[index].associatedCases,
            createdBy: createdBy);
      }
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      // Уведомляем подписчиков об изменении данных
      notifyListeners();
    } catch (e) {
      print('Ошибка при обновлении данных пользователя: $e');
    }
  }

  //проверка аутентификации
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  void login() {
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    // ignore: use_build_context_synchronously
    AutoRouter.of(context).replace(const AuthCheckRoute());
  }

  //delete data

  Future<void> delete(int? userId, BuildContext context) async {
    // print(userId);
    try {
      await Api.deleteUser(userId);
      await fetchUsersData();
      filteredData.clear();
      notifyListeners();
      Navigator.pop(context);
    } catch (e) {
      print('Ошибка при удалении данных пользователя: $e');
    }
    notifyListeners();
  }
}
