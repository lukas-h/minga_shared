class FormValidator {
  static bool validatePassword(String password) =>
      RegExp(r"[\S]{12,32}").stringMatch(password) == password;
  static bool validateEmail(String email) =>
      RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@([a-zA-Z0-9\-]{2,63})+(\.[a-zA-Z0-9\-]{2,63})*(\.[a-zA-Z]{2,63})+")
          .stringMatch(email) ==
      email;
  static bool validatePhone(String number) =>
      RegExp(r"^(\+)?[\d\s]+").stringMatch(number) == number;
}
