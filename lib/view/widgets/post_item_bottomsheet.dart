import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auction_app/view/widgets/auth_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../model/constants.dart';

class PostItemScreen extends ConsumerStatefulWidget {
  const PostItemScreen({super.key});
  static const id = "/addPost";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PostItemScreenState();
}

class _PostItemScreenState extends ConsumerState<PostItemScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey();
  late TextEditingController _productName;
  late TextEditingController _productDescription;
  late TextEditingController _minBitPrice;

  late String selectedDate;
  late TimeOfDay? selectedTime;

//input field border.
  OutlineInputBorder inputFieldBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
          color: KConstColors.inputFieldBorderColor, width: 2.0),
    );
  }

//date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050, 1),
    );
    if (picked != null) {
      DateFormat dateFormater = DateFormat("yyyy-MM-dd");
      selectedDate = dateFormater.format(picked);
      setState(() {});
    }
  }

// time picker
  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? selectedTime24Hour = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (selectedTime24Hour != null) {
      selectedTime = selectedTime24Hour;
      setState(() {});
    }
  }

  @override
  void initState() {
    _productName = TextEditingController();
    _productDescription = TextEditingController();
    _minBitPrice = TextEditingController();
    // get current date time
    selectedDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
    selectedTime = TimeOfDay.now();
    super.initState();
  }

  @override
  void dispose() {
    _minBitPrice.dispose();
    _productDescription.dispose();
    _productName.dispose();
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
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          //physics: const NeverScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Auction Details",
                      style: Theme.of(context).textTheme.headline6),
                  SizedBox(height: size.height * 0.01),
                  //==========================================================>>>input fields
                  //product name
                  inputField(
                    hintText: "Product name",
                    controller: _productName,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please enter product name";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: size.height * 0.01),
                  //product details
                  inputField(
                    hintText: "Product details",
                    controller: _productDescription,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please enter product details";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: size.height * 0.01),
                  //minimum bid price.
                  inputField(
                    hintText: "Minimum bid price",
                    controller: _minBitPrice,
                    inputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value.isNotEmpty) {
                        if (value.contains(",") ||
                            value.contains(".") ||
                            value.contains("-")) {
                          return "Invalid number formate";
                        }
                        return null;
                      }
                      return "Please enter a valid product price";
                    },
                  ),
                  SizedBox(height: size.height * 0.01),
                  Container(
                    padding: const EdgeInsets.all(8),
                    //width: size.width * 0.04,
                    height: size.width * 0.1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: KConstColors.inputFieldBorderColor,
                        width: 2,
                      ),
                    ),
                    child: const Text("Add Image"),
                  ),
                  SizedBox(height: size.height * 0.02),
                  //======================================>>> date time picker
                  Text(
                    "Auction End Date With Time",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(height: size.height * 0.01),
                  //date picker widget
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: dateTimeWidget(
                        size: size,
                        icon: FeatherIcons.calendar,
                        data: selectedDate),
                  ),
                  Helper.spacer(size, 0.02),
                  //time picker widget
                  GestureDetector(
                    onTap: () => _selectTime(context),
                    child: dateTimeWidget(
                        size: size,
                        icon: FeatherIcons.clock,
                        data: selectedTime,
                        isTime: true),
                  ),
                  //=====================================================>>> add button.
                  Helper.spacer(size, 0.04),
                  AuthButton(
                      buttonText: "Add Product",
                      onTriger: () {
                        if (_formkey.currentState!.validate()) {
                          FirebaseFirestore.instance
                              .collection("auction_data")
                              .doc()
                              .set({
                            "product_name": _productName.text,
                            "product_details": _productDescription.text,
                            "price": _minBitPrice.text,
                            "time": DateTime.now(),
                            "end_date": selectedDate,
                            "end_time": selectedTime.toString(),
                          });
                          _productName.clear();
                          _productDescription.clear();
                          _minBitPrice.clear();
                        } else {}
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField inputField(
      {hintText,
      controller,
      validator,
      inputAction = TextInputAction.next,
      keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      textInputAction: inputAction,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: hintText,
        focusedBorder: inputFieldBorder(),
        enabledBorder: inputFieldBorder(),
        disabledBorder: inputFieldBorder(),
        errorBorder: inputFieldBorder(),
        focusedErrorBorder: inputFieldBorder(),
      ),
      validator: validator,
    );
  }

  ///date time widget
  Container dateTimeWidget({size, icon, data, isTime = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      width: size.width,
      height: size.height * 0.08,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xffDADADA),
        ),
        borderRadius: BorderRadius.circular(size.width * 0.02),
      ),
      child: Row(
        children: [
          Icon(icon),
          SizedBox(
            width: size.width * 0.04,
          ),
          Text(
            isTime
                ? "${data.hour.toString().padLeft(2, '0')}: ${data.minute.toString().padLeft(2, '0')}"
                : data.toString(),
            style: TextStyle(
                fontSize: size.width * 0.045, fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }
}
