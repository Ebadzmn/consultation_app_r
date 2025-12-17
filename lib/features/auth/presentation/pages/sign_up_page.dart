import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart'; // I will create this later
import '../bloc/sign_up/sign_up_bloc.dart';
import '../widgets/sign_up_form.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      
        
        centerTitle: false,
        titleSpacing: -10,
      ),
      body: BlocProvider(
        create: (_) => sl<SignUpBloc>(), // Service locator
        child: const SignUpForm(),
      ),
    );
  }
}
