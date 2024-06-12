import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/pages/authcheck_page.dart';
import 'package:flutter_application_1/ui/pages/register_page.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:provider/provider.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_application_1/domain/contollers/app_controllers.dart';
import 'package:flutter_application_1/domain/model/users.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final _appRouter = AppRouter();
    return ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerDelegate: _appRouter.delegate(),
        routeInformationParser: _appRouter.defaultRouteParser(),
        // home: MyHomePage(),
      ),
    );
  }
}

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userModel = context.watch<UserProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 10,
        leading: IconButton(
          onPressed: () {
            userModel.logout(context);
          },
          icon: const Icon(Icons.exit_to_app_rounded),
        ),
        title: const Text(
          'Поиск клиентов',
          style: TextStyle(
            color: AppColors.white,
          ),
        ),
        backgroundColor: AppColors.mainColor,
        actions: [
          SizedBox(
            width: 40,
            height: 40,
            child: FloatingActionButton(
              backgroundColor: Colors.black,
              onPressed: () {
                userModel.showWindowDialog(context);
              },
              child: const Icon(
                Icons.add,
                color: AppColors.white,
              ),
            ),
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: const AppBody(),
    );
  }
}

class AppBody extends StatelessWidget {
  const AppBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final userModel = context.watch<UserProvider>();
    return FutureBuilder<List<Users>>(
        future: userModel.fetchUsersData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Нет связи с сервером'),
            );
          } else {
            return const ListDataWidget();
          }
        });
  }
}

class ListDataWidget extends StatelessWidget {
  const ListDataWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final userModel = context.watch<UserProvider>();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: AppControllers.searchController,
                  decoration: const InputDecoration(
                    labelText: 'Поиск',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.mainColor,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.mainColor,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  userModel.onSearch(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mainColor,
                ),
                child: const Text(
                  'Поиск',
                  style: TextStyle(
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.only(left: 10, right: 10),
            itemCount: userModel.filteredData.length,
            itemBuilder: (context, i) {
              final user = userModel.filteredData[i];
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.mainColor,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    LeftData(user: user),
                    CenterData(user: user),
                    RightData(user: user),
                  ],
                ),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 10),
          ),
        ),
      ],
    );
  }
}

class LeftData extends StatelessWidget {
  const LeftData({super.key, required this.user});
  final Users user;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Id: ${user.id}'),
        const SizedBox(height: 10),
        const TextWidget(
          text: 'Associated Client:',
          color: Colors.transparent,
        ),
        TextWidget(
          text: '${user.associatedClient}',
          color: const Color.fromARGB(255, 199, 222, 240),
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 10),
        const TextWidget(
          text: 'Associated Contract:',
          color: Colors.transparent,
        ),
        const SizedBox(height: 10),
        TextWidget(
          text: '${user.associatedContract}',
          color: const Color.fromARGB(255, 246, 240, 217),
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 10),
        const TextWidget(
          text: 'Lawyer:',
          color: Colors.transparent,
        ),
        const SizedBox(height: 10),
        TextWidget(
          text: '${user.lawyer}',
          color: const Color.fromARGB(255, 216, 215, 213),
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 10),
        const TextWidget(
          text: 'Beneficiary Name:',
          color: Colors.transparent,
        ),
        const SizedBox(height: 10),
        TextWidget(
          text: '${user.beneficiaryName}',
          color: const Color.fromARGB(150, 74, 73, 73),
          fontWeight: FontWeight.bold,
        ),
      ],
    );
  }
}

class CenterData extends StatelessWidget {
  const CenterData({super.key, required this.user});
  final Users user;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const TextWidget(
          text: 'Founders:',
          color: Colors.transparent,
        ),
        TextWidget(
          text: '${user.founders}',
          color: const Color.fromARGB(173, 208, 74, 74),
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 10),
        const TextWidget(
          text: 'Director:',
          color: Colors.transparent,
        ),
        TextWidget(
          text: '${user.director}',
          color: const Color.fromARGB(255, 110, 175, 229),
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 10),
        const TextWidget(
          text: 'Other parties in dispute:',
          color: Colors.transparent,
        ),
        TextWidget(
          text: '${user.partiesOfDispute}',
          color: const Color.fromARGB(205, 174, 52, 60),
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 10),
        const TextWidget(
          text: 'Associated Companies:',
          color: Colors.transparent,
        ),
        TextWidget(
          text: '${user.associatedCompanies}',
          color: const Color.fromARGB(242, 232, 211, 150),
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 10),
        const TextWidget(
          text: 'Associated Cases:',
          color: Colors.transparent,
        ),
        TextWidget(
          text: '${user.associatedCases}',
          color: const Color.fromARGB(255, 226, 205, 144),
          fontWeight: FontWeight.bold,
        ),
      ],
    );
  }
}

class RightData extends StatelessWidget {
  const RightData({super.key, required this.user});
  final Users user;
  @override
  Widget build(BuildContext context) {
    final userModel = context.watch<UserProvider>();
    return Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.mainColor,
            foregroundColor: AppColors.white,
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  surfaceTintColor: Colors.transparent,
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                          'Вы действительно хотите изменить этого пользователя?'),
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
                        controller:
                            AppControllers.otherPartiesInDisputeController,
                        labelText: 'Other parties in dispute',
                      ),
                      const SizedBox(height: 6),
                      TextFieldWidget(
                        controller:
                            AppControllers.associatedCompaniesController,
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
                      onPressed: () async {
                        final updatedData = user.copyWith(
                          associatedClient: AppControllers
                                  .associatedClientController.text.isNotEmpty
                              ? AppControllers.associatedClientController.text
                              : user.associatedClient,
                          associatedContract: AppControllers
                                  .associatedContractController.text.isNotEmpty
                              ? AppControllers.associatedContractController.text
                              : user.associatedContract,
                          lawyer:
                              AppControllers.lawyerController.text.isNotEmpty
                                  ? AppControllers.lawyerController.text
                                  : user.lawyer,
                          beneficiaryName: AppControllers
                                  .beneficiaryNameController.text.isNotEmpty
                              ? AppControllers.beneficiaryNameController.text
                              : user.beneficiaryName,
                          founders:
                              AppControllers.foundersController.text.isNotEmpty
                                  ? AppControllers.foundersController.text
                                  : user.founders,
                          director:
                              AppControllers.directorController.text.isNotEmpty
                                  ? AppControllers.directorController.text
                                  : user.director,
                          partiesOfDispute: AppControllers
                                  .otherPartiesInDisputeController
                                  .text
                                  .isNotEmpty
                              ? AppControllers
                                  .otherPartiesInDisputeController.text
                              : user.partiesOfDispute,
                          associatedCompanies: AppControllers
                                  .associatedCompaniesController.text.isNotEmpty
                              ? AppControllers
                                  .associatedCompaniesController.text
                              : user.associatedCompanies,
                          associatedCases: AppControllers
                                  .associatedCasesController.text.isNotEmpty
                              ? AppControllers.associatedCasesController.text
                              : user.associatedCases,
                        );

                        // Вызов метода updateData для обновления данных пользователя
                        await userModel.updateData(
                            user.id, context, updatedData);
                      },
                      child: const Text('Да'),
                    ),
                  ],
                );
              },
            );

            // userModel.updateData(user.id, context);
          },
          child: const Text('Изменить'),
        ),
        const SizedBox(height: 50),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.black,
            foregroundColor: AppColors.white,
            elevation: 0,
            shadowColor: Colors.transparent,
          ),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: const Text(
                        'Вы действительно хотите удалить пользователя?'),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Нет'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          userModel.delete(user.id, context);
                        },
                        child: const Text('Да'),
                      ),
                    ],
                  );
                });
          },
          child: const Text('Удалить'),
        ),
      ],
    );
  }
}

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
    );

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
    try {
      // Обновляем данные на сервере
      await Api.updateUser(userId, updatedData);

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
        );
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

class Api {
  static List<Users> users = [];

  static Future<List<Users>> fetchUsers() async {
    final response = await http.get(Uri.parse('http://localhost:3000/users'));

    final json = jsonDecode(response.body) as List<dynamic>;

    final userData = json.map<Users>((e) {
      return Users.fromJson(e as Map<String, dynamic>);
    }).toList();

    users = userData;

    return users;
  }

  static Future<void> addUser(Users user) async {
    final jsonData = jsonEncode(user.toJson());

    final response = await http.post(
      Uri.parse('http://localhost:3000/users'),
      headers: {'Content-Type': 'application/json'},
      body: jsonData,
    );
    print('response.body: ${response.body}');
    if (response.statusCode == 201) {
      users.add(user);
    } else {
      throw Exception('Failed to add user');
    }
  }

  //регистрация

  static Future<bool> register(BuildContext context) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': AppControllers.nameController.text,
        'userLastName': AppControllers.lastNameController.text,
        'userEmail': AppControllers.emailController.text,
        'password': AppControllers.passwordController.text,
      }),
    );
    if (response.statusCode == 201) {
      final body = jsonDecode(response.body);
      final token = body['token'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      print('User registered successfully');
      return true;
    } else {
      print('Failed to register user');
      return false;
    }
  }

//авторизация
  static Future<bool> login(BuildContext context) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userEmail': AppControllers.emailController.text,
        'password': AppControllers.passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final token = body['token'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      print('User logged in successfully');
      return true;
    } else {
      print('Failed to login user');
      return false;
    }
  }

//обновление данных
  static Future<void> updateUser(int? userId, Users userToUpdate) async {
    final url = Uri.parse('http://localhost:3000/users/$userId');
    print("User to update: $userToUpdate");
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userToUpdate.toJson()),
      );

      if (response.statusCode == 200) {
        print('User data updated successfully');
        await fetchUsers();
      } else {
        print('Failed to update user data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating user data: $e');
    }
  }

  //удаление данных
  static Future<void> deleteUser(int? userId) async {
    final url = Uri.parse('http://localhost:3000/users/$userId');
    try {
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        users.removeWhere((user) => user.id == userId);
        print('User data deleted successfully');
      } else {
        print('Failed to delete user data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating user data: $e');
    }
  }
}

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    super.key,
    required this.controller,
    required this.labelText,
    this.obscureText = false,
  });
  final String labelText;
  final TextEditingController controller;
  final bool obscureText;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
    );
  }
}

class TextWidget extends StatelessWidget {
  const TextWidget({
    super.key,
    required this.text,
    required this.color,
    this.fontWeight,
  });

  final String text;
  final FontWeight? fontWeight;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 18,
        fontWeight: fontWeight,
        backgroundColor: color,
      ),
    );
  }
}

class SingInBody extends StatelessWidget {
  const SingInBody({super.key, required this.callback});
  final Function callback;
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<UserProvider>(context, listen: false);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Вход',
              style: AppStyle.fontStyle,
            ),
            const SizedBox(height: 10),
            const SizedBox(height: 10),
            TextFieldWidget(
              labelText: 'Email',
              controller: AppControllers.emailController,
            ),
            const SizedBox(height: 10),
            TextFieldWidget(
              labelText: 'Пароль',
              controller: AppControllers.passwordController,
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final success = await Api.login(context);
                if (success) {
                  authService.login();
                  context.router.replace(const HomeRoute());
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainColor,
                padding: const EdgeInsets.only(bottom: 12, left: 20, right: 20),
              ),
              child: Text(
                'Войти',
                style: AppStyle.fontStyle.copyWith(
                  fontSize: 24,
                  color: AppColors.white,
                ),
              ),
            ),
            const SizedBox(height: 25),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  callback();
                },
                child: Text(
                  'Регистрация',
                  style: AppStyle.fontStyle.copyWith(
                    fontSize: 16,
                    color: Colors.black,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterBody extends StatelessWidget {
  const RegisterBody({
    super.key,
    required this.callback,
  });
  final Function callback;
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<UserProvider>(context, listen: false);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Регистрация',
              style: AppStyle.fontStyle,
            ),
            const SizedBox(height: 10),
            TextFieldWidget(
              labelText: 'Имя',
              controller: AppControllers.nameController,
            ),
            const SizedBox(height: 10),
            const SizedBox(height: 10),
            TextFieldWidget(
              labelText: 'Фамилия',
              controller: AppControllers.lastNameController,
            ),
            const SizedBox(height: 10),
            const SizedBox(height: 10),
            TextFieldWidget(
              labelText: 'Email',
              controller: AppControllers.emailController,
            ),
            const SizedBox(height: 10),
            TextFieldWidget(
              labelText: 'Пароль',
              controller: AppControllers.passwordController,
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final success = await Api.register(context);
                if (success) {
                  authService.login();
                  context.router.replace(const HomeRoute());
                }
                // Api.register(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainColor,
                padding: const EdgeInsets.only(bottom: 15, left: 20, right: 20),
              ),
              child: Text(
                'Зарегистрироваться',
                style: AppStyle.fontStyle.copyWith(
                  fontSize: 24,
                  color: AppColors.white,
                ),
              ),
            ),
            const SizedBox(height: 25),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  callback();
                },
                child: Text(
                  'Войти',
                  style: AppStyle.fontStyle.copyWith(
                    fontSize: 16,
                    color: Colors.black,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

abstract class AppStyle {
  static const TextStyle fontStyle = TextStyle(
    fontSize: 34,
    color: AppColors.mainColor,
    fontWeight: FontWeight.bold,
  );
}

abstract class AppColors {
  static const mainColor = Color.fromRGBO(151, 37, 44, 0.85);
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF444444);
}

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: AuthCheckRoute.page, initial: true),
        AutoRoute(page: RegisterRoute.page, path: '/register'),
        AutoRoute(page: HomeRoute.page),
      ];
}
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

abstract class _$AppRouter extends RootStackRouter {

  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    AuthCheckRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AuthCheckPage(),
      );
    },
    HomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomePage(),
      );
    },
    RegisterRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const RegisterPage(),
      );
    },
  };
}

/// generated route for
/// [AuthCheckPage]
class AuthCheckRoute extends PageRouteInfo<void> {
  const AuthCheckRoute({List<PageRouteInfo>? children})
      : super(
          AuthCheckRoute.name,
          initialChildren: children,
        );

  static const String name = 'AuthCheckRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [RegisterPage]
class RegisterRoute extends PageRouteInfo<void> {
  const RegisterRoute({List<PageRouteInfo>? children})
      : super(
          RegisterRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

@RoutePage()
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isActive = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !isActive
          ? RegisterBody(
              callback: () {
                setState(() {
                  isActive = true;
                });
              },
            )
          : SingInBody(
              callback: () {
                setState(() {
                  isActive = false;
                });
              },
            ),
    );
  }
}

@RoutePage()
class AuthCheckPage extends StatelessWidget {
  const AuthCheckPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkAuth(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Error checking authentication'),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Future<bool> checkAuth(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      context.router.replace(const HomeRoute());
      return true;
    } else {
      context.router.replace(const RegisterRoute());
      return false;
    }
  }
}

@freezed
class Users with _$Users {
  const factory Users({
    @JsonKey(name: 'Id') int? id,
    @JsonKey(name: 'AssociatedClient') String? associatedClient,
    @JsonKey(name: 'AssociatedContract') String? associatedContract,
    @JsonKey(name: 'Lawyer') String? lawyer,
    @JsonKey(name: 'BeneficiaryName') String? beneficiaryName,
    @JsonKey(name: 'Founders') String? founders,
    @JsonKey(name: 'Director') String? director,
    @JsonKey(name: 'PartiesOfDispute') String? partiesOfDispute,
    @JsonKey(name: 'AssociatedCompanies') String? associatedCompanies,
    @JsonKey(name: 'AssociatedCases') String? associatedCases,
  }) = _Users;

  factory Users.fromJson(Map<String, dynamic> json) => _$UsersFromJson(json);
}
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Users _$UsersFromJson(Map<String, dynamic> json) {
  return _Users.fromJson(json);
}

/// @nodoc
mixin _$Users {
  @JsonKey(name: 'Id')
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'AssociatedClient')
  String? get associatedClient => throw _privateConstructorUsedError;
  @JsonKey(name: 'AssociatedContract')
  String? get associatedContract => throw _privateConstructorUsedError;
  @JsonKey(name: 'Lawyer')
  String? get lawyer => throw _privateConstructorUsedError;
  @JsonKey(name: 'BeneficiaryName')
  String? get beneficiaryName => throw _privateConstructorUsedError;
  @JsonKey(name: 'Founders')
  String? get founders => throw _privateConstructorUsedError;
  @JsonKey(name: 'Director')
  String? get director => throw _privateConstructorUsedError;
  @JsonKey(name: 'PartiesOfDispute')
  String? get partiesOfDispute => throw _privateConstructorUsedError;
  @JsonKey(name: 'AssociatedCompanies')
  String? get associatedCompanies => throw _privateConstructorUsedError;
  @JsonKey(name: 'AssociatedCases')
  String? get associatedCases => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UsersCopyWith<Users> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UsersCopyWith<$Res> {
  factory $UsersCopyWith(Users value, $Res Function(Users) then) =
      _$UsersCopyWithImpl<$Res, Users>;
  @useResult
  $Res call(
      {@JsonKey(name: 'Id') int? id,
      @JsonKey(name: 'AssociatedClient') String? associatedClient,
      @JsonKey(name: 'AssociatedContract') String? associatedContract,
      @JsonKey(name: 'Lawyer') String? lawyer,
      @JsonKey(name: 'BeneficiaryName') String? beneficiaryName,
      @JsonKey(name: 'Founders') String? founders,
      @JsonKey(name: 'Director') String? director,
      @JsonKey(name: 'PartiesOfDispute') String? partiesOfDispute,
      @JsonKey(name: 'AssociatedCompanies') String? associatedCompanies,
      @JsonKey(name: 'AssociatedCases') String? associatedCases});
}

/// @nodoc
class _$UsersCopyWithImpl<$Res, $Val extends Users>
    implements $UsersCopyWith<$Res> {
  _$UsersCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? associatedClient = freezed,
    Object? associatedContract = freezed,
    Object? lawyer = freezed,
    Object? beneficiaryName = freezed,
    Object? founders = freezed,
    Object? director = freezed,
    Object? partiesOfDispute = freezed,
    Object? associatedCompanies = freezed,
    Object? associatedCases = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      associatedClient: freezed == associatedClient
          ? _value.associatedClient
          : associatedClient // ignore: cast_nullable_to_non_nullable
              as String?,
      associatedContract: freezed == associatedContract
          ? _value.associatedContract
          : associatedContract // ignore: cast_nullable_to_non_nullable
              as String?,
      lawyer: freezed == lawyer
          ? _value.lawyer
          : lawyer // ignore: cast_nullable_to_non_nullable
              as String?,
      beneficiaryName: freezed == beneficiaryName
          ? _value.beneficiaryName
          : beneficiaryName // ignore: cast_nullable_to_non_nullable
              as String?,
      founders: freezed == founders
          ? _value.founders
          : founders // ignore: cast_nullable_to_non_nullable
              as String?,
      director: freezed == director
          ? _value.director
          : director // ignore: cast_nullable_to_non_nullable
              as String?,
      partiesOfDispute: freezed == partiesOfDispute
          ? _value.partiesOfDispute
          : partiesOfDispute // ignore: cast_nullable_to_non_nullable
              as String?,
      associatedCompanies: freezed == associatedCompanies
          ? _value.associatedCompanies
          : associatedCompanies // ignore: cast_nullable_to_non_nullable
              as String?,
      associatedCases: freezed == associatedCases
          ? _value.associatedCases
          : associatedCases // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UsersImplCopyWith<$Res> implements $UsersCopyWith<$Res> {
  factory _$$UsersImplCopyWith(
          _$UsersImpl value, $Res Function(_$UsersImpl) then) =
      __$$UsersImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'Id') int? id,
      @JsonKey(name: 'AssociatedClient') String? associatedClient,
      @JsonKey(name: 'AssociatedContract') String? associatedContract,
      @JsonKey(name: 'Lawyer') String? lawyer,
      @JsonKey(name: 'BeneficiaryName') String? beneficiaryName,
      @JsonKey(name: 'Founders') String? founders,
      @JsonKey(name: 'Director') String? director,
      @JsonKey(name: 'PartiesOfDispute') String? partiesOfDispute,
      @JsonKey(name: 'AssociatedCompanies') String? associatedCompanies,
      @JsonKey(name: 'AssociatedCases') String? associatedCases});
}

/// @nodoc
class __$$UsersImplCopyWithImpl<$Res>
    extends _$UsersCopyWithImpl<$Res, _$UsersImpl>
    implements _$$UsersImplCopyWith<$Res> {
  __$$UsersImplCopyWithImpl(
      _$UsersImpl _value, $Res Function(_$UsersImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? associatedClient = freezed,
    Object? associatedContract = freezed,
    Object? lawyer = freezed,
    Object? beneficiaryName = freezed,
    Object? founders = freezed,
    Object? director = freezed,
    Object? partiesOfDispute = freezed,
    Object? associatedCompanies = freezed,
    Object? associatedCases = freezed,
  }) {
    return _then(_$UsersImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      associatedClient: freezed == associatedClient
          ? _value.associatedClient
          : associatedClient // ignore: cast_nullable_to_non_nullable
              as String?,
      associatedContract: freezed == associatedContract
          ? _value.associatedContract
          : associatedContract // ignore: cast_nullable_to_non_nullable
              as String?,
      lawyer: freezed == lawyer
          ? _value.lawyer
          : lawyer // ignore: cast_nullable_to_non_nullable
              as String?,
      beneficiaryName: freezed == beneficiaryName
          ? _value.beneficiaryName
          : beneficiaryName // ignore: cast_nullable_to_non_nullable
              as String?,
      founders: freezed == founders
          ? _value.founders
          : founders // ignore: cast_nullable_to_non_nullable
              as String?,
      director: freezed == director
          ? _value.director
          : director // ignore: cast_nullable_to_non_nullable
              as String?,
      partiesOfDispute: freezed == partiesOfDispute
          ? _value.partiesOfDispute
          : partiesOfDispute // ignore: cast_nullable_to_non_nullable
              as String?,
      associatedCompanies: freezed == associatedCompanies
          ? _value.associatedCompanies
          : associatedCompanies // ignore: cast_nullable_to_non_nullable
              as String?,
      associatedCases: freezed == associatedCases
          ? _value.associatedCases
          : associatedCases // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UsersImpl implements _Users {
  const _$UsersImpl(
      {@JsonKey(name: 'Id') this.id,
      @JsonKey(name: 'AssociatedClient') this.associatedClient,
      @JsonKey(name: 'AssociatedContract') this.associatedContract,
      @JsonKey(name: 'Lawyer') this.lawyer,
      @JsonKey(name: 'BeneficiaryName') this.beneficiaryName,
      @JsonKey(name: 'Founders') this.founders,
      @JsonKey(name: 'Director') this.director,
      @JsonKey(name: 'PartiesOfDispute') this.partiesOfDispute,
      @JsonKey(name: 'AssociatedCompanies') this.associatedCompanies,
      @JsonKey(name: 'AssociatedCases') this.associatedCases});

  factory _$UsersImpl.fromJson(Map<String, dynamic> json) =>
      _$$UsersImplFromJson(json);

  @override
  @JsonKey(name: 'Id')
  final int? id;
  @override
  @JsonKey(name: 'AssociatedClient')
  final String? associatedClient;
  @override
  @JsonKey(name: 'AssociatedContract')
  final String? associatedContract;
  @override
  @JsonKey(name: 'Lawyer')
  final String? lawyer;
  @override
  @JsonKey(name: 'BeneficiaryName')
  final String? beneficiaryName;
  @override
  @JsonKey(name: 'Founders')
  final String? founders;
  @override
  @JsonKey(name: 'Director')
  final String? director;
  @override
  @JsonKey(name: 'PartiesOfDispute')
  final String? partiesOfDispute;
  @override
  @JsonKey(name: 'AssociatedCompanies')
  final String? associatedCompanies;
  @override
  @JsonKey(name: 'AssociatedCases')
  final String? associatedCases;

  @override
  String toString() {
    return 'Users(id: $id, associatedClient: $associatedClient, associatedContract: $associatedContract, lawyer: $lawyer, beneficiaryName: $beneficiaryName, founders: $founders, director: $director, partiesOfDispute: $partiesOfDispute, associatedCompanies: $associatedCompanies, associatedCases: $associatedCases)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UsersImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.associatedClient, associatedClient) ||
                other.associatedClient == associatedClient) &&
            (identical(other.associatedContract, associatedContract) ||
                other.associatedContract == associatedContract) &&
            (identical(other.lawyer, lawyer) || other.lawyer == lawyer) &&
            (identical(other.beneficiaryName, beneficiaryName) ||
                other.beneficiaryName == beneficiaryName) &&
            (identical(other.founders, founders) ||
                other.founders == founders) &&
            (identical(other.director, director) ||
                other.director == director) &&
            (identical(other.partiesOfDispute, partiesOfDispute) ||
                other.partiesOfDispute == partiesOfDispute) &&
            (identical(other.associatedCompanies, associatedCompanies) ||
                other.associatedCompanies == associatedCompanies) &&
            (identical(other.associatedCases, associatedCases) ||
                other.associatedCases == associatedCases));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      associatedClient,
      associatedContract,
      lawyer,
      beneficiaryName,
      founders,
      director,
      partiesOfDispute,
      associatedCompanies,
      associatedCases);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UsersImplCopyWith<_$UsersImpl> get copyWith =>
      __$$UsersImplCopyWithImpl<_$UsersImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UsersImplToJson(
      this,
    );
  }
}

abstract class _Users implements Users {
  const factory _Users(
      {@JsonKey(name: 'Id') final int? id,
      @JsonKey(name: 'AssociatedClient') final String? associatedClient,
      @JsonKey(name: 'AssociatedContract') final String? associatedContract,
      @JsonKey(name: 'Lawyer') final String? lawyer,
      @JsonKey(name: 'BeneficiaryName') final String? beneficiaryName,
      @JsonKey(name: 'Founders') final String? founders,
      @JsonKey(name: 'Director') final String? director,
      @JsonKey(name: 'PartiesOfDispute') final String? partiesOfDispute,
      @JsonKey(name: 'AssociatedCompanies') final String? associatedCompanies,
      @JsonKey(name: 'AssociatedCases')
      final String? associatedCases}) = _$UsersImpl;

  factory _Users.fromJson(Map<String, dynamic> json) = _$UsersImpl.fromJson;

  @override
  @JsonKey(name: 'Id')
  int? get id;
  @override
  @JsonKey(name: 'AssociatedClient')
  String? get associatedClient;
  @override
  @JsonKey(name: 'AssociatedContract')
  String? get associatedContract;
  @override
  @JsonKey(name: 'Lawyer')
  String? get lawyer;
  @override
  @JsonKey(name: 'BeneficiaryName')
  String? get beneficiaryName;
  @override
  @JsonKey(name: 'Founders')
  String? get founders;
  @override
  @JsonKey(name: 'Director')
  String? get director;
  @override
  @JsonKey(name: 'PartiesOfDispute')
  String? get partiesOfDispute;
  @override
  @JsonKey(name: 'AssociatedCompanies')
  String? get associatedCompanies;
  @override
  @JsonKey(name: 'AssociatedCases')
  String? get associatedCases;
  @override
  @JsonKey(ignore: true)
  _$$UsersImplCopyWith<_$UsersImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UsersImpl _$$UsersImplFromJson(Map<String, dynamic> json) => _$UsersImpl(
      id: (json['Id'] as num?)?.toInt(),
      associatedClient: json['AssociatedClient'] as String?,
      associatedContract: json['AssociatedContract'] as String?,
      lawyer: json['Lawyer'] as String?,
      beneficiaryName: json['BeneficiaryName'] as String?,
      founders: json['Founders'] as String?,
      director: json['Director'] as String?,
      partiesOfDispute: json['PartiesOfDispute'] as String?,
      associatedCompanies: json['AssociatedCompanies'] as String?,
      associatedCases: json['AssociatedCases'] as String?,
    );

Map<String, dynamic> _$$UsersImplToJson(_$UsersImpl instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'AssociatedClient': instance.associatedClient,
      'AssociatedContract': instance.associatedContract,
      'Lawyer': instance.lawyer,
      'BeneficiaryName': instance.beneficiaryName,
      'Founders': instance.founders,
      'Director': instance.director,
      'PartiesOfDispute': instance.partiesOfDispute,
      'AssociatedCompanies': instance.associatedCompanies,
      'AssociatedCases': instance.associatedCases,
    };

abstract class AppControllers {
  //регистрация/авторизация
  static final nameController = TextEditingController();
  static final lastNameController = TextEditingController();
  static final emailController = TextEditingController();
  static final passwordController = TextEditingController();

  //поиск
  static final searchController = TextEditingController();

  //добавление
  static final associatedClientController = TextEditingController();
  static final associatedContractController = TextEditingController();
  static final lawyerController = TextEditingController();
  static final beneficiaryNameController = TextEditingController();
  static final foundersController = TextEditingController();
  static final directorController = TextEditingController();
  static final otherPartiesInDisputeController = TextEditingController();
  static final associatedCompaniesController = TextEditingController();
  static final associatedCasesController = TextEditingController();
}
