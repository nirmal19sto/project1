import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sample2/Repository.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool? colorval ;

  loginData(payload) async {
    try {
      final response = await http.post(
        Uri.parse('https://reqres.in/api/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        colorval=true;
        alertDialog(context,'Login Successful');
      } else {
        colorval=false;
        alertDialog(context,'Login Failed');
      }
    } catch (e) {
      colorval=false;
      alertDialog(context,'Something went wrong');
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        centerTitle: true,
      ),
      body: Form(
        key: _formkey,
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(15),
                child: TextFormField(
                  controller: _email,
                    validator: (val){
                      if (val==null ||
                          !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(val)) {
                        return 'Enter a valid email!';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        hintText: 'Enter Email',
                        labelText: 'Email',
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.blue,
                        ),
                        border: OutlineInputBorder(
                            )
                    )
                )
            ),
            const SizedBox(height: 10,),
            Padding(
                padding: const EdgeInsets.all(15),
                child: TextFormField(
                  controller: _password,
                    validator: (val){
                      if (val==null ||val.isEmpty) {
                        return 'Enter a valid Password';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        hintText: 'Enter Password',
                        labelText: 'Password',
                        prefixIcon: Icon(
                          Icons.key,
                          color: Colors.blue,
                        ),
                        border: OutlineInputBorder(
                        )
                    )
                )
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                color: Colors.green,
                height: 40,
                width: 200,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () {
                    if (_formkey.currentState!.validate()) {
                      var payload = Post(
                          email: _email.text,
                          password: _password.text,
                          );
                      loginData(payload);
                    }
                  },
                  child: const Text(
                    'LOGIN',
                    style: TextStyle(color: Colors.black,
                    fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  alertDialog(BuildContext context,String message){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
       // content:  Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Container(
              color:colorval!? Colors.green:Colors.red,
              padding: const EdgeInsets.all(14),
              child: const Text("OK",
                style: TextStyle(color: Colors.black,
                  fontWeight: FontWeight.bold
                ),),
            ),
          ),
        ],
      ),
    );
  }
}

