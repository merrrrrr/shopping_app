import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/pages/register_page.dart';
import 'package:shopping_app/services/user_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
	final _formKey = GlobalKey<FormState>();
	TextEditingController emailController = TextEditingController();
	TextEditingController passwordController = TextEditingController();

	bool _isLoading = false;
  bool _obscurePassword = true;

	Future<void> loginUser() async {
		if (!_formKey.currentState!.validate()) {
			return;
		}

		setState(() => _isLoading = true);

		try {
			await FirebaseAuth.instance.signInWithEmailAndPassword(
				email: emailController.text.trim(),
				password: passwordController.text.trim()
			);

		} on FirebaseAuthException catch (e) {
			if (!mounted) return;

			String errorMessage;

      switch (e.code) {
        case 'user-not-found':
          errorMessage =
            'No user found with this email. Please register first.';
          break;

        case 'wrong-password':
          errorMessage = 'Incorrect password. Please try again.';
          break;

        case 'invalid-email':
          errorMessage = 'Invalid email address.';
          break;

        case 'user-disabled':
          errorMessage = 'This account has been disabled.';
          break;

        case 'too-many-requests':
          errorMessage =
            'Too many failed login attempts. Please try again later.';
          break;

        default:
          errorMessage = e.message ?? "An unknown error occurred.";
      }

			showDialog(
				context: context,
				builder: (context) {
					return AlertDialog(
						title: Text("Login Failed"),
						content: Text(errorMessage),
						actions: [
							TextButton(
								onPressed: () => Navigator.of(context).pop(),
								child: Text("OK"),
							),
						],
					);
				}
			);
		} catch(e) {
			if (!mounted) return;

			showDialog(
				context: context,
				builder: (context) {
					return AlertDialog(
						title: Text("Error"),
						content: Text("Failed to login: $e"),
						actions: [
							TextButton(
								onPressed: () => Navigator.of(context).pop(),
								child: Text("OK"),
							),
						],
					);
				}
			);
		} finally {
			if (mounted) {
				setState(() => _isLoading = false);
			}
		}
	}

	@override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
			body: Padding(
				padding: const EdgeInsets.all(16.0),
				child: _isLoading
				? Center(
					child: CircularProgressIndicator()
				)
				: Center(
					child: Form(
						key: _formKey,
						child: Column(
							mainAxisAlignment: MainAxisAlignment.center,
							children: [
								Text(
									"Jiji",
									style: TextStyle(
										fontSize: 32,
										fontWeight: FontWeight.bold,
										color: Theme.of(context).colorScheme.primary,
									),
								),

								SizedBox(height: 24),

								TextFormField(
									controller: emailController,
									decoration: InputDecoration(
										labelText: "Email",
										border: OutlineInputBorder(
											borderRadius: BorderRadius.circular(8),
										),
									),
									keyboardType: TextInputType.emailAddress,
									validator: (value) {
										if (value == null || value.isEmpty) {
											return "Please enter your email";
										}
										return null;
									}
								),

								SizedBox(height: 16),
					
								TextFormField(
									controller: passwordController,
									decoration: InputDecoration(
										labelText: "Password",
										suffixIcon: IconButton(
											onPressed: () {
												setState(() => _obscurePassword = !_obscurePassword);
											},
											icon: Icon(
												_obscurePassword ? Icons.visibility_off : Icons.visibility
											)
										),
										border: OutlineInputBorder(
											borderRadius: BorderRadius.circular(8),
										)
									),
									obscureText: _obscurePassword,
									validator: (value) {
										if (value == null || value.isEmpty) {
											return "Please enter your password";
										}
										return null;
									}
								),

								SizedBox(height: 16),

								ElevatedButton(
									onPressed: loginUser,
									style: ElevatedButton.styleFrom(
										minimumSize: Size(double.infinity, 48),
										shape: RoundedRectangleBorder(
											borderRadius: BorderRadius.circular(8),
										),
									),
									child: Text(
										"Login",
										style: TextStyle(
											fontSize: 16,
											fontWeight: FontWeight.bold,
										),
									),
								),

								SizedBox(height: 24),

								Row(
									mainAxisAlignment: MainAxisAlignment.center,
									children: [
										Text("New user? Click"),
										GestureDetector(
											child: Text(" here ",
												style: TextStyle(
													color: Theme.of(context).colorScheme.primary,
												),
											),
											onTap: () {
												Navigator.push(
													context,
													MaterialPageRoute(
														builder: (context) => RegisterPage(),
													),
												);
											},
										),
										Text("to register."),
									],
								),

								SizedBox(height: 8),

								GestureDetector(
									child: Text("Reset Password",
										style: TextStyle(
											color: Theme.of(context).colorScheme.primary,
										),
									),
									onTap: () {
										showDialog(
											context: context,
											builder: (context) {
												return AlertDialog(
													title: Text("Enter your email"),
													content: TextFormField(
														controller: emailController,
														decoration: InputDecoration(
															labelText: "Email",
															border: OutlineInputBorder(
																borderRadius: BorderRadius.circular(8),
															),
														),
													),
													actions: [
														TextButton(
															onPressed: () async {
																Navigator.of(context).pop();
																await UserService().resetPassword(emailController.text.trim());
															},
															child: Text("Send Reset Link"),
														),
													],
												);
											}
										);
										
									},
								),

					
								
							],
						),
					)
				),
			),
		);
  }
}