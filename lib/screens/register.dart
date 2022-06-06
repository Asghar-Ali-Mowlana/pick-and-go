import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pickandgo/models/model.dart';
import 'package:universal_io/io.dart' as u;

import 'loginpage.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  _RegisterState();
  bool showProgress = false;
  bool visible = false;
  final _formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  CollectionReference ref = FirebaseFirestore.instance.collection('userz');
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController confirmpassController =
      new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController nameController = new TextEditingController();
  final TextEditingController mobileController = new TextEditingController();
  final TextEditingController addressController = new TextEditingController();
  bool _isObscure = true;
  bool _isObscure2 = true;
  File? file;
  var role = "User";

  @override
  Widget build(BuildContext context) {
    return (u.Platform.operatingSystem == "android")
        ? Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    color: Colors.white10,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: SingleChildScrollView(
                      child: Container(
                        margin: EdgeInsets.all(22),
                        child: Form(
                          key: _formkey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(1.0),
                                child: Image.asset(
                                  "assets/logo2.png",
                                  height: 200,
                                  width: 150,
                                ),
                              ),

                              Text(
                                "Register Now",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 40,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                controller: nameController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: 'Name',
                                  enabled: true,
                                  contentPadding: const EdgeInsets.only(
                                      left: 14.0, bottom: 8.0, top: 8.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: Colors.black),
                                    borderRadius: new BorderRadius.circular(10),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: Colors.white),
                                    borderRadius: new BorderRadius.circular(10),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.length == 0) {
                                    return "Name cannot be empty";
                                  }
                                  if (!RegExp("^[a-zA-Z][a-zA-Z ]{2,}")
                                      .hasMatch(value)) {
                                    return ("Please enter your name");
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: (value) {},
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                controller: emailController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: 'Email',
                                  enabled: true,
                                  contentPadding: const EdgeInsets.only(
                                      left: 14.0, bottom: 8.0, top: 8.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: Colors.black),
                                    borderRadius: new BorderRadius.circular(10),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: Colors.white),
                                    borderRadius: new BorderRadius.circular(10),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.length == 0) {
                                    return "Email cannot be empty";
                                  }
                                  if (!RegExp(
                                          "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                      .hasMatch(value)) {
                                    return ("Please enter a valid email");
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: (value) {},
                                keyboardType: TextInputType.emailAddress,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                controller: mobileController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: 'Mobile Number',
                                  enabled: true,
                                  contentPadding: const EdgeInsets.only(
                                      left: 14.0, bottom: 8.0, top: 8.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: Colors.black),
                                    borderRadius: new BorderRadius.circular(10),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: Colors.white),
                                    borderRadius: new BorderRadius.circular(10),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.length == 0) {
                                    return "Mobile-Number cannot be empty";
                                  }
                                  if (!RegExp("").hasMatch(value)) {
                                    return ("Please enter your mobile number");
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: (value) {},
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                controller: addressController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: 'Address',
                                  enabled: true,
                                  contentPadding: const EdgeInsets.only(
                                      left: 14.0, bottom: 8.0, top: 8.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: Colors.black),
                                    borderRadius: new BorderRadius.circular(10),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: Colors.white),
                                    borderRadius: new BorderRadius.circular(10),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.length == 0) {
                                    return "Address cannot be empty";
                                  }
                                  if (!RegExp("").hasMatch(value)) {
                                    return ("Please enter your address");
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: (value) {},
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                obscureText: _isObscure,
                                controller: passwordController,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                      icon: Icon(_isObscure
                                          ? Icons.visibility_off
                                          : Icons.visibility),
                                      onPressed: () {
                                        setState(() {
                                          _isObscure = !_isObscure;
                                        });
                                      }),
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: 'Password',
                                  enabled: true,
                                  contentPadding: const EdgeInsets.only(
                                      left: 14.0, bottom: 8.0, top: 15.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: Colors.black),
                                    borderRadius: new BorderRadius.circular(10),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: Colors.white),
                                    borderRadius: new BorderRadius.circular(10),
                                  ),
                                ),
                                validator: (value) {
                                  RegExp regex = new RegExp(r'^.{6,}$');
                                  if (value!.isEmpty) {
                                    return "Password cannot be empty";
                                  }
                                  if (!regex.hasMatch(value)) {
                                    return ("please enter valid password min. 6 character");
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: (value) {},
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                obscureText: _isObscure2,
                                controller: confirmpassController,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                      icon: Icon(_isObscure2
                                          ? Icons.visibility_off
                                          : Icons.visibility),
                                      onPressed: () {
                                        setState(() {
                                          _isObscure2 = !_isObscure2;
                                        });
                                      }),
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: 'Confirm Password',
                                  enabled: true,
                                  contentPadding: const EdgeInsets.only(
                                      left: 14.0, bottom: 8.0, top: 15.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: Colors.black),
                                    borderRadius: new BorderRadius.circular(10),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: Colors.white),
                                    borderRadius: new BorderRadius.circular(10),
                                  ),
                                ),
                                validator: (value) {
                                  if (confirmpassController.text !=
                                      passwordController.text) {
                                    return "Password did not match";
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: (value) {},
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.center,
                              //   children: [
                              //     Text(
                              //       "Rool : ",
                              //       style: TextStyle(
                              //         fontSize: 20,
                              //         fontWeight: FontWeight.bold,
                              //         color: Colors.white,
                              //       ),
                              //     ),
                              //     // DropdownButton<String>(
                              //     //   dropdownColor: Colors.blue[900],
                              //     //   isDense: true,
                              //     //   isExpanded: false,
                              //     //   iconEnabledColor: Colors.white,
                              //     //   focusColor: Colors.white,
                              //     //   items: options.map((String dropDownStringItem) {
                              //     //     return DropdownMenuItem<String>(
                              //     //       value: dropDownStringItem,
                              //     //       child: Text(
                              //     //         dropDownStringItem,
                              //     //         style: TextStyle(
                              //     //           color: Colors.white,
                              //     //           fontWeight: FontWeight.bold,
                              //     //           fontSize: 20,
                              //     //         ),
                              //     //       ),
                              //     //     );
                              //     //   }).toList(),
                              //     //   onChanged: (newValueSelected) {
                              //     //     setState(() {
                              //     //       _currentItemSelected = newValueSelected!;
                              //     //       rool = newValueSelected;
                              //     //     });
                              //     //   },
                              //     //   value: _currentItemSelected,
                              //     // ),
                              //   ],
                              // ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  MaterialButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0))),
                                    elevation: 5.0,
                                    height: 40,
                                    onPressed: () {
                                      CircularProgressIndicator();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => LoginPage(),
                                        ),
                                      );
                                    },
                                    color: Colors.black,
                                    child: Text(
                                      "Login",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  MaterialButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0))),
                                    elevation: 5.0,
                                    height: 40,
                                    onPressed: () {
                                      setState(() {
                                        showProgress = true;
                                      });
                                      signUp(
                                          emailController.text,
                                          passwordController.text,
                                          role,
                                          nameController.text,
                                          mobileController.text,
                                          addressController.text);
                                    },
                                    child: Text(
                                      "Register Now",
                                      style: TextStyle(
                                        fontSize: 17,
                                      ),
                                    ),
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Scaffold(
            body: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      color: Colors.white10,
                      width: MediaQuery.of(context).size.width * 0.40,
                      height: MediaQuery.of(context).size.height,
                      child: SingleChildScrollView(
                        child: Container(
                          margin: EdgeInsets.all(5),
                          child: Form(
                            key: _formkey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(1.0),
                                  child: Image.asset(
                                    "assets/logo2.png",
                                    height: 200,
                                    width: 150,
                                  ),
                                ),
                                Text(
                                  "Register Now",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 40,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  controller: nameController,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: 'Name',
                                    enabled: true,
                                    contentPadding: const EdgeInsets.only(
                                        left: 14.0, bottom: 8.0, top: 8.0),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.black),
                                      borderRadius:
                                          new BorderRadius.circular(10),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.white),
                                      borderRadius:
                                          new BorderRadius.circular(10),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.length == 0) {
                                      return "Name cannot be empty";
                                    }
                                    if (!RegExp("^[a-zA-Z][a-zA-Z ]{2,}")
                                        .hasMatch(value)) {
                                      return ("Please enter your name");
                                    } else {
                                      return null;
                                    }
                                  },
                                  onChanged: (value) {},
                                  keyboardType: TextInputType.text,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  controller: emailController,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: 'Email',
                                    enabled: true,
                                    contentPadding: const EdgeInsets.only(
                                        left: 14.0, bottom: 8.0, top: 8.0),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.black),
                                      borderRadius:
                                          new BorderRadius.circular(10),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.white),
                                      borderRadius:
                                          new BorderRadius.circular(10),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.length == 0) {
                                      return "Email cannot be empty";
                                    }
                                    if (!RegExp(
                                            "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                        .hasMatch(value)) {
                                      return ("Please enter a valid email");
                                    } else {
                                      return null;
                                    }
                                  },
                                  onChanged: (value) {},
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  controller: mobileController,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: 'Mobile Number',
                                    enabled: true,
                                    contentPadding: const EdgeInsets.only(
                                        left: 14.0, bottom: 8.0, top: 8.0),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.black),
                                      borderRadius:
                                          new BorderRadius.circular(10),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.white),
                                      borderRadius:
                                          new BorderRadius.circular(10),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.length == 0) {
                                      return "Mobile-Number cannot be empty";
                                    }
                                    if (!RegExp("").hasMatch(value)) {
                                      return ("Please enter your mobile number");
                                    } else {
                                      return null;
                                    }
                                  },
                                  onChanged: (value) {},
                                  keyboardType: TextInputType.text,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  controller: addressController,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: 'Address',
                                    enabled: true,
                                    contentPadding: const EdgeInsets.only(
                                        left: 14.0, bottom: 8.0, top: 8.0),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.black),
                                      borderRadius:
                                          new BorderRadius.circular(10),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.white),
                                      borderRadius:
                                          new BorderRadius.circular(10),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.length == 0) {
                                      return "Address cannot be empty";
                                    }
                                    if (!RegExp("").hasMatch(value)) {
                                      return ("Please enter your address");
                                    } else {
                                      return null;
                                    }
                                  },
                                  onChanged: (value) {},
                                  keyboardType: TextInputType.text,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  obscureText: _isObscure,
                                  controller: passwordController,
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                        icon: Icon(_isObscure
                                            ? Icons.visibility_off
                                            : Icons.visibility),
                                        onPressed: () {
                                          setState(() {
                                            _isObscure = !_isObscure;
                                          });
                                        }),
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: 'Password',
                                    enabled: true,
                                    contentPadding: const EdgeInsets.only(
                                        left: 14.0, bottom: 8.0, top: 15.0),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.black),
                                      borderRadius:
                                          new BorderRadius.circular(10),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.white),
                                      borderRadius:
                                          new BorderRadius.circular(10),
                                    ),
                                  ),
                                  validator: (value) {
                                    RegExp regex = new RegExp(r'^.{6,}$');
                                    if (value!.isEmpty) {
                                      return "Password cannot be empty";
                                    }
                                    if (!regex.hasMatch(value)) {
                                      return ("please enter valid password min. 6 character");
                                    } else {
                                      return null;
                                    }
                                  },
                                  onChanged: (value) {},
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  obscureText: _isObscure2,
                                  controller: confirmpassController,
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                        icon: Icon(_isObscure2
                                            ? Icons.visibility_off
                                            : Icons.visibility),
                                        onPressed: () {
                                          setState(() {
                                            _isObscure2 = !_isObscure2;
                                          });
                                        }),
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: 'Confirm Password',
                                    enabled: true,
                                    contentPadding: const EdgeInsets.only(
                                        left: 14.0, bottom: 8.0, top: 15.0),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.black),
                                      borderRadius:
                                          new BorderRadius.circular(10),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.white),
                                      borderRadius:
                                          new BorderRadius.circular(10),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (confirmpassController.text !=
                                        passwordController.text) {
                                      return "Password did not match";
                                    } else {
                                      return null;
                                    }
                                  },
                                  onChanged: (value) {},
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    MaterialButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),
                                      elevation: 5.0,
                                      height: 40,
                                      onPressed: () {
                                        CircularProgressIndicator();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => LoginPage(),
                                          ),
                                        );
                                      },
                                      color: Colors.black,
                                      child: Text(
                                        "Login",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    MaterialButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),
                                      elevation: 5.0,
                                      height: 40,
                                      onPressed: () {
                                        setState(() {
                                          showProgress = true;
                                        });
                                        signUp(
                                            emailController.text,
                                            passwordController.text,
                                            role,
                                            nameController.text,
                                            mobileController.text,
                                            addressController.text);
                                      },
                                      child: Text(
                                        "Register Now",
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  //validate and signup method
  void signUp(String email, String password, String role, String name,
      String mobile, String address) async {
    CircularProgressIndicator();
    if (_formkey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(
            email: email,
            password: password,
          )
          .then((value) =>
              {postDetailsToFirestore(email, role, name, mobile, address)})
          .catchError((e) {});
    }
  }

  //add the user details to the database (method)
  postDetailsToFirestore(String email, String role, String name, String mobile,
      String address) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    //creating a usermodel object
    UserModel userModel = UserModel();
    userModel.email = email;
    userModel.uid = user!.uid;
    userModel.role = role;
    userModel.name = name;
    userModel.mobile = mobile;
    userModel.address = address;
    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        //insert to firebase database
        .set(userModel.toMap());
    print("User Signed Up email - ${userModel.email}");
    print("User Signed Up user unique ID - ${userModel.uid}");
    print("User Signed Up role - ${userModel.role}");
    print("User Signed Up name - ${userModel.name}");

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }
}
