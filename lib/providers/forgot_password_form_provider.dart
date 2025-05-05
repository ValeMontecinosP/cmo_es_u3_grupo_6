import 'package:flutter_application_3/theme/theme.dart';

class ForgotPasswordFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  String email = '';

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
  }

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}
