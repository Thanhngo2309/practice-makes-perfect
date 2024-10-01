import 'package:flutter/material.dart';
import 'package:myapp/service/AuthService.dart';

class SignInPage2 extends StatelessWidget {
  const SignInPage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
        body: Center(
            child: isSmallScreen
                ? const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      _Logo(),
                      _FormContent(),
                    ],
                  )
                : Container(
                    padding: const EdgeInsets.all(32.0),
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: const Row(
                      children: const [
                        Expanded(child: _Logo()),
                        Expanded(
                          child: Center(child: _FormContent()),
                        ),
                      ],
                    ),
                  )));
  }
}

class _Logo extends StatelessWidget {
  const _Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FlutterLogo(size: isSmallScreen ? 100 : 200),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Chào mừng đến với EduX",
            textAlign: TextAlign.center,
            style: isSmallScreen
                ? Theme.of(context).textTheme.titleMedium
                : Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: Colors.black),
          ),
        )
      ],
    );
  }
}

class _FormContent extends StatefulWidget {
  const _FormContent({Key? key}) : super(key: key);

  @override
  State<_FormContent> createState() => __FormContentState();
}

class __FormContentState extends State<_FormContent> {
  bool _isPasswordVisible = false;
  bool _rememberMe = false;
  String email = '';
  String password = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              onChanged: (text) {
                setState(() {
                  email = text;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email không được để trống';
                }
                bool emailValid = RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(value);
                if (!emailValid) {
                  return 'Email không hợp lệ';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'm@example.com',
                prefixIcon:const Icon(Icons.email_outlined),
                border:const OutlineInputBorder(),
                enabledBorder:  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Color.fromARGB(255, 210, 210, 210)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
              ),
            ),
            _gap(),
            TextFormField(
              onChanged: (text) {
                 password = text;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Mật khẩu không được để trống';
                }

                if (value.length < 6) {
                  return 'Mật khẩu phải dài hơn 6 ký tự';
                }
                return null;
              },
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: '*********',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  border: const OutlineInputBorder(),
                  enabledBorder:  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Color.fromARGB(255, 210, 210, 210)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  )),
            ),
            _gap(),
            CheckboxListTile(
              value: _rememberMe,
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  _rememberMe = value;
                });
              },
              title: const Text('Lưu mật khẩu'),
              controlAffinity: ListTileControlAffinity.leading,
              dense: true,
              contentPadding: const EdgeInsets.all(0),
            ),
            _gap(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Đăng ký',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    AuthService.signup(email, password, context);
                  }
                },
              ),
            ),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Bạn đã có tài khoản ? "),
                  GestureDetector(
                      onTap: () {
                          Navigator.pushNamed(context, "/signin");
                        },
                    child: const Text("Đăng nhập", style: TextStyle(color: Colors.blue),),
                                )
                              ],
                            )
          ],
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}
