import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/contollers/app_controllers.dart';
import 'package:flutter_application_1/domain/model/users.dart';
import 'package:flutter_application_1/domain/providers/user_provider.dart';
import 'package:flutter_application_1/ui/style/app_colors.dart';
import 'package:flutter_application_1/ui/widgets/text_widget.dart';
import 'package:flutter_application_1/ui/widgets/textfield_widget.dart';
import 'package:provider/provider.dart';

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
                  crossAxisAlignment: CrossAxisAlignment.start,
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
          backgroundColor: Colors.transparent,
        ),
        TextWidget(
          text: '${user.associatedClient}',
          backgroundColor: const Color.fromARGB(255, 199, 222, 240),
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 10),
        const TextWidget(
          text: 'Associated Contract:',
          backgroundColor: Colors.transparent,
        ),
        const SizedBox(height: 10),
        TextWidget(
          text: '${user.associatedContract}',
          backgroundColor: const Color.fromARGB(255, 246, 240, 217),
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 10),
        const TextWidget(
          text: 'Lawyer:',
          backgroundColor: Colors.transparent,
        ),
        const SizedBox(height: 10),
        TextWidget(
          text: '${user.lawyer}',
          backgroundColor: const Color.fromARGB(255, 216, 215, 213),
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 10),
        const TextWidget(
          text: 'Beneficiary Name:',
          backgroundColor: Colors.transparent,
        ),
        const SizedBox(height: 10),
        TextWidget(
          text: '${user.beneficiaryName}',
          backgroundColor: const Color.fromARGB(150, 74, 73, 73),
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
          backgroundColor: Colors.transparent,
        ),
        TextWidget(
          text: '${user.founders}',
          backgroundColor: const Color.fromARGB(173, 208, 74, 74),
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 10),
        const TextWidget(
          text: 'Director:',
          backgroundColor: Colors.transparent,
        ),
        TextWidget(
          text: '${user.director}',
          backgroundColor: const Color.fromARGB(255, 110, 175, 229),
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 10),
        const TextWidget(
          text: 'Other parties in dispute:',
          backgroundColor: Colors.transparent,
        ),
        TextWidget(
          text: '${user.partiesOfDispute}',
          backgroundColor: const Color.fromARGB(205, 174, 52, 60),
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 10),
        const TextWidget(
          text: 'Associated Companies:',
          backgroundColor: Colors.transparent,
        ),
        TextWidget(
          text: '${user.associatedCompanies}',
          backgroundColor: const Color.fromARGB(242, 232, 211, 150),
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 10),
        const TextWidget(
          text: 'Associated Cases:',
          backgroundColor: Colors.transparent,
        ),
        TextWidget(
          text: '${user.associatedCases}',
          backgroundColor: const Color.fromARGB(255, 226, 205, 144),
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
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
                            controller:
                                AppControllers.associatedClientController,
                            labelText: 'Associated Client',
                          ),
                          const SizedBox(height: 6),
                          TextFieldWidget(
                            controller:
                                AppControllers.associatedContractController,
                            labelText: 'Associated Contract',
                          ),
                          const SizedBox(height: 6),
                          TextFieldWidget(
                            controller: AppControllers.lawyerController,
                            labelText: 'Lawyer',
                          ),
                          const SizedBox(height: 6),
                          TextFieldWidget(
                            controller:
                                AppControllers.beneficiaryNameController,
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
                            controller:
                                AppControllers.associatedCasesController,
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
                                      .associatedClientController
                                      .text
                                      .isNotEmpty
                                  ? AppControllers
                                      .associatedClientController.text
                                  : user.associatedClient,
                              associatedContract: AppControllers
                                      .associatedContractController
                                      .text
                                      .isNotEmpty
                                  ? AppControllers
                                      .associatedContractController.text
                                  : user.associatedContract,
                              lawyer: AppControllers
                                      .lawyerController.text.isNotEmpty
                                  ? AppControllers.lawyerController.text
                                  : user.lawyer,
                              beneficiaryName: AppControllers
                                      .beneficiaryNameController.text.isNotEmpty
                                  ? AppControllers
                                      .beneficiaryNameController.text
                                  : user.beneficiaryName,
                              founders: AppControllers
                                      .foundersController.text.isNotEmpty
                                  ? AppControllers.foundersController.text
                                  : user.founders,
                              director: AppControllers
                                      .directorController.text.isNotEmpty
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
                                      .associatedCompaniesController
                                      .text
                                      .isNotEmpty
                                  ? AppControllers
                                      .associatedCompaniesController.text
                                  : user.associatedCompanies,
                              associatedCases: AppControllers
                                      .associatedCasesController.text.isNotEmpty
                                  ? AppControllers
                                      .associatedCasesController.text
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
        ),
        TextWidget(
          text: 'Данный клиент был добавлен: ${capitalize(user.createdBy.toString())}',
          backgroundColor: const Color.fromARGB(255, 240, 207, 107),
          color: Colors.black,
        ),
      ],
    );
  }
  String capitalize(String str)=> str[0].toUpperCase() + str.substring(1).toLowerCase();
}
