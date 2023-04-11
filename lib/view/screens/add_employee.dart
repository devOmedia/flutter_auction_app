import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auction_app/view/widgets/auth_button.dart';
import 'package:flutter_auction_app/view/widgets/custom_inputfield.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddEmployeeScreen extends ConsumerStatefulWidget {
  const AddEmployeeScreen({super.key});
  static const id = "/addEmployee";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AppEmployeeScreenState();
}

class _AppEmployeeScreenState extends ConsumerState<AddEmployeeScreen> {
  late TextEditingController _name;

  late TextEditingController _designation;
  late TextEditingController _salary;
  final GlobalKey<FormState> _formkey = GlobalKey();
  @override
  void initState() {
    _name = TextEditingController();
    _designation = TextEditingController();
    _salary = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _name.dispose();
    _designation.dispose();
    _salary.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //  / SizedBox(height: size.height * 0.02),
              Text(
                "Add New Employee",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: size.height * 0.1),
              CustomTextInputfield(
                hintText: "Employee Name",
                textController: _name,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value!.isNotEmpty) {
                    return null;
                  } else {
                    return "please add a valid  name";
                  }
                },
              ),
              SizedBox(height: size.height * 0.02),
              CustomTextInputfield(
                hintText: "Employee Designation ",
                textController: _designation,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value!.isNotEmpty) {
                    return null;
                  } else {
                    return "please add a valid  designation";
                  }
                },
              ),
              SizedBox(height: size.height * 0.02),
              CustomTextInputfield(
                hintText: "Employee Salary ",
                textController: _salary,
                keyBoardType: TextInputType.number,
                validator: (value) {
                  if (value!.isNotEmpty) {
                    return null;
                  } else {
                    return "please add a valid  salary";
                  }
                },
              ),
              SizedBox(height: size.height * 0.06),
              AuthButton(
                buttonText: "ADD",
                onTriger: () {
                  if (_formkey.currentState!.validate()) {
                    FirebaseFirestore.instance.collection("users").add({
                      "name": _name.text,
                      "image":
                          "https://thumbs.dreamstime.com/b/happy-smiling-geek-hipster-beard-man-cool-avatar-geek-man-avatar-104871313.jpg",
                      "designation": _designation.text,
                      "salary": _salary.text,
                    });
                    _name.clear();
                    _designation.clear();
                    _salary.clear();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
