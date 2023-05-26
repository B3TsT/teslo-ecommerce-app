//* STRING AND CONSTANTS USED IN THE APP
//* USE THIS FILE TO DEFINE ALL THE CONSTANTS USED IN THE APP

//? ERROR: ENVIRONMENT VARIABLES NOT FOUND
import 'package:flutter/material.dart';

const String apiUrlNotFound =
    'No está configurado el API_URL en el archivo .env';

//? ERROR: INPUTS
const String errorEmpty = 'El campo es requerido';
const String error0 = 'Tiene que ser un numero mayor o igual a 0';
const String errorLength = 'Mínimo 6 caracteres';
const String errorEmailFormat = 'No tiene formato de correo electrónico';
const String errorPasswordFormat =
    'Debe de tener Mayúscula, letras y un número';
const String errorDefault = 'El campo no tiene el formato esperado';

//? REGEX
final RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
final RegExp passwordRegExp =
    RegExp(r'(?:(?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$');

//? COLORS
const colorSeed = Color(0xff424CB8);
const scaffoldBackgroundColor = Color(0xFFF8F7F7);

//? UI STRINGS
const String login = 'Login';
const String email = 'Correo';
const String password = 'Contraseña';
const String enter = 'Ingresar';
const String accountNotFound = 'No tienes cuenta?';
const String createAccount = 'Crea una aquí';
const String createhere = 'Crear cuenta';
const double defaultPadding = 20.0;
