import 'package:flutter/material.dart';
import 'package:flutter_application_3/services/auth_service.dart';
import 'package:flutter_application_3/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_3/providers/providers.dart';
import '../ui/input_decorations.dart';

class RegisterUserScreen extends StatelessWidget {
  const RegisterUserScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 160,
              ),
              CardContainer(
                  child: Column(children: [
                const SizedBox(height: 10),
                Text(
                  'Crea tu cuenta',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 30),
                ChangeNotifierProvider(
                  create: (_) => LoginFormProvider(),
                  child: RegisterForm(),
                ),
                const SizedBox(height: 50),
                TextButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, 'login'),
                  style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(
                          Colors.indigo.withOpacity(0.1)),
                      shape: MaterialStateProperty.all(StadiumBorder())),
                  child: const Text('¿Ya tienes una cuenta? Inicia sesión aquí'),
                )
              ])),
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginForm = Provider.of<LoginFormProvider>(context);
    return Container(
      child: Form(
        key: LoginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(children: [
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.text,
            decoration: InputDecortions.authInputDecoration(
              hinText: 'Ingrese su correo',
              labelText: 'Email',
              prefixIcon: Icons.people,
            ),
            onChanged: (value) => LoginForm.email = value,
            validator: (value) {
              return (value != null && value.length >= 4)
                  ? null
                  : 'El usuario no puede estar vacío';
            },
          ),
          const SizedBox(height: 30),
          TextFormField(
            autocorrect: false,
            obscureText: true,
            keyboardType: TextInputType.text,
            decoration: InputDecortions.authInputDecoration(
              hinText: '************',
              labelText: 'Password',
              prefixIcon: Icons.lock_outline,
            ),
            onChanged: (value) => LoginForm.password = value,
            validator: (value) {
              return (value != null && value.length >= 4)
                  ? null
                  : 'La contraseña no puede estar vacía';
            },
          ),
          const SizedBox(height: 30),
          MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            disabledColor: Colors.grey,
            color: Colors.blue,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 10),
              child: Text(
                'Registrar',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            elevation: 0,
            onPressed: LoginForm.isLoading
                ? null
                : () async {
                    FocusScope.of(context).unfocus();
                    final authService =
                        Provider.of<AuthService>(context, listen: false);
                    if (!LoginForm.isValidForm()) return;
                    LoginForm.isLoading = true;
                    final String? errorMessage = await authService.createUser(
                        LoginForm.email, LoginForm.password);
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
