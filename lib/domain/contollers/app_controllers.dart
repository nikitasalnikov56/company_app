import 'package:flutter/material.dart';

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
  static final  associatedCompaniesController = TextEditingController();
  static final associatedCasesController = TextEditingController();
}
