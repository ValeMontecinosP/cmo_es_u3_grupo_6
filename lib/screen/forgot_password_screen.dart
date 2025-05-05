import 'package:flutter/material.dart';
import 'package:flutter_application_3/services/auth_service.dart';
import 'package:flutter_application_3/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_3/providers/providers.dart';
import '../ui/input_decorations.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 170,
              ),
              CardContainer(
                  child: Column(children: [
                const SizedBox(height: 10),
                Text(
                  'Recuperar contraseña',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 30),
                ChangeNotifierProvider(
                  create: (_) => ForgotPasswordFormProvider(),
                  child: ForgotPasswordForm(),
                ),
                const SizedBox(height: 50),
                                
              ])),
            ],
          ),
        ),
      ),
    );
  }
}

class ForgotPasswordForm extends StatelessWidget {
  const ForgotPasswordForm({super.key});

  @override
  Widget build(BuildContext context) {
    final ForgotPasswordForm = Provider.of<ForgotPasswordFormProvider>(context);
    return Container(
      child: Form(
        key: ForgotPasswordForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(children: [
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.text,
            decoration: InputDecortions.authInputDecoration(
              hinText: 'Ingresa tu correo',
              labelText: 'Email',
              prefixIcon: Icons.people,
            ),
            onChanged: (value) => ForgotPasswordForm.email = value,
            validator: (value) {
              return (value != null && value.length >= 4)
                  ? null
                  : 'El usuario no puede estar vacío';
            },
          ),
          const SizedBox(height: 30),
        
          const SizedBox(height: 30),
          MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            disabledColor: Colors.grey,
            color: Colors.blue,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text(
                'Recuperar contraseña',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            elevation: 0,
            onPressed: ForgotPasswordForm.isLoading
                ? null
                : () async {
                    FocusScope.of(context).unfocus();
                    final authService =
                        Provider.of<AuthService>(context, listen: false);
                    if (!ForgotPasswordForm.isValidForm()) return;
                    ForgotPasswordForm.isLoading = true;
                    final String? errorMessage = await authService.forgotPassword(
                        ForgotPasswordForm.email);
                    if (errorMessage == null) {
                      Navigator.pushNamed(context, 'login');
                    } else {
                      print(errorMessage);
                    }
                  },

          )
        ]),
      ),
    );
  }
}
