import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/services/user_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
	final _formKey = GlobalKey<FormState>();
	TextEditingController nameController = TextEditingController();
	TextEditingController emailController = TextEditingController();
	TextEditingController phoneNumberController = TextEditingController();
	TextEditingController passwordController = TextEditingController();
	TextEditingController confirmPasswordController = TextEditingController();
	TextEditingController addressController = TextEditingController();

	bool _isLoading = false;
	bool _obscurePassword = true;
	bool _obscureConfirmPassword = true;

	Future<void> registerUser() async {
		if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

		try {
			await UserService().createUser(
				nameController.text.trim(),
				emailController.text.trim(),
				phoneNumberController.text.trim(),
				addressController.text.trim(),
				passwordController.text.trim(),
			);

			if (!mounted) return;

			showDialog(
				context: context,
				builder: (context) {
				return AlertDialog(
					title: Text("Registration Successful"),
					content: Text('Registration successful! Please login with your credentials.'),
					actions: [
						TextButton(
							onPressed: () {
								Navigator.of(context).pop();
							},
							child: Text("OK"),
						),
					],
				);
			});

		} on FirebaseAuthException catch (e) {

			if (!mounted) return;

			String errorMessage;

      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'This email is already registered. Please login instead.';
          break;
        case 'weak-password':
          errorMessage = 'Password is too weak. Please use a stronger password.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address.';
          break;
        default:
          errorMessage = e.message ?? "An unknown error occurred.";
      }

			showDialog(context: context, builder: (context) {
				return AlertDialog(
					title: Text("Registration Failed"),
					content: Text(errorMessage),
					actions: [
						TextButton(
							onPressed: () => Navigator.of(context).pop(),
							child: Text("OK"),
						),
					],
				);
			});
		} catch(e) {
			if (!mounted) return;

			showDialog(
				context: context,
				builder: (context) {
					return AlertDialog(
						title: const Text('Error'),
						content: Text('Failed to create account: $e'),
						actions: [
							TextButton(
								onPressed: () => Navigator.of(context).pop(),
								child: const Text('OK')
							)
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
    nameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
			body: SafeArea(
				child: _isLoading 
				? const Center(
					child: CircularProgressIndicator(),
				) 
				: Center(
					child: SingleChildScrollView(
						padding: const EdgeInsets.all(16.0),
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
										controller: nameController,
										decoration: InputDecoration(
											labelText: "Name",
											border: OutlineInputBorder(
												borderRadius: BorderRadius.circular(8),
											),
										),
										keyboardType: TextInputType.name,
										validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                      	return 'Please enter your name';
                      }
                      return null;
                    },
									),
																															
									SizedBox(height: 16),
																															
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
										  if (value == null || value.trim().isEmpty) {
                        return 'Please enter your email';
                      }
											return null;
										},
									),
									
									SizedBox(height: 16),
									
									TextFormField(
										controller: phoneNumberController,
										decoration: InputDecoration(
											labelText: "Phone Number",
											border: OutlineInputBorder(
												borderRadius: BorderRadius.circular(8),
											),
										),
										keyboardType: TextInputType.number,
										validator: (value) {
										  if (value == null || value.trim().isEmpty) {
												return 'Please enter your phone number';
											}
											return null;
										},
									),
							
									SizedBox(height: 16),
									
									TextFormField(
										controller: addressController,
										maxLines: 2,
										decoration: InputDecoration(
											labelText: "Address",
											border: OutlineInputBorder(
												borderRadius: BorderRadius.circular(8),
											),
										),
										keyboardType: TextInputType.streetAddress,
										validator: (value) {
										  if (value == null || value.trim().isEmpty) {
												return 'Please enter your address';
											}
											return null;
										},
									),
									
									SizedBox(height: 16),
																						
									TextFormField(
										controller: passwordController,
										decoration: InputDecoration(
											labelText: "Password",
											suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                      ),
											border: OutlineInputBorder(
												borderRadius: BorderRadius.circular(8),
											),
										),
										obscureText: _obscurePassword,
										validator: (value) {
										  if (value == null || value.trim().isEmpty) {
												return 'Please enter your password';
											}
											if (value.trim().length < 6) {
												return 'Password must be at least 6 characters long';
											}
											return null;
										},
									),
																						
									SizedBox(height: 16),
									
									TextFormField(
										controller: confirmPasswordController,
										decoration: InputDecoration(
											labelText: "Confirm Password",
											suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                        },
                      ),
											border: OutlineInputBorder(
												borderRadius: BorderRadius.circular(8),
											)
										),
										obscureText: _obscureConfirmPassword,
										validator: (value) {
										  if (value == null || value.trim().isEmpty) {
												return 'Please enter your confirm password';
											}
											if (value != passwordController.text) {
												return 'Passwords do not match';
											}
											return null;
										},
									),
																						
									SizedBox(height: 16),
																						
									ElevatedButton(
										onPressed: registerUser,
										style: ElevatedButton.styleFrom(
											minimumSize: Size(double.infinity, 48),
											shape: RoundedRectangleBorder(
												borderRadius: BorderRadius.circular(8),
											),
										),
										child: Text(
											"Register",
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
											Text("Already have an account? "),
											GestureDetector(
												child: Text("Login",
													style: TextStyle(
														color: Theme.of(context).colorScheme.primary,
													),
												),
												onTap: () {
													Navigator.pop(context);
												},
											)
										],
									),
								],
							),
						),
					),
				),
			),
		);
  }
}