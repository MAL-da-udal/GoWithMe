String? validateLogin(String login) {
  if (login.isEmpty) {
    return 'Please enter a login';
  }
  return null;
}

String? validatePassword(String password) {
  if (password.isEmpty) {
    return 'Please enter a password';
  }
  if (password.length < 6) {
    return 'Password must be at least 6 characters';
  }
  return null;
}

String? validatePasswordConfirmation(
  String password,
  String passwordConfirmation,
) {
  if (password != passwordConfirmation) {
    return 'Passwords do not match';
  }
  return null;
}
