import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../styles.dart';

class ProfileScreenFieldWidget extends StatelessWidget {
  final String fieldName;
  // final String fieldValue;
  final String? Function(String?)? validate;
  final Function(String) onChangValue;
  // final Function() onTap;
  final TextInputType? textInputType;
  final int? numberTextLength;
  final FocusNode focusNode;
  final TextEditingController? textEditingController;

  const ProfileScreenFieldWidget({
    super.key,
    required this.fieldName,
    // required this.fieldValue,
    required this.validate,
    required this.onChangValue,
    this.textInputType, this.numberTextLength, required this.focusNode, required this.textEditingController
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            fieldName,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          // const SizedBox(
          //   height: 2,
          // ),
          PhysicalModel(
            color: Colors.grey.shade300,
            elevation: 5,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            child: TextFormField(
              maxLength: numberTextLength,
              controller: textEditingController,
              keyboardType: textInputType ?? TextInputType.text,
              decoration: profileTextFieldStyles(label: ''),
              // initialValue: fieldValue,
              focusNode: focusNode,
              validator: validate,
              onChanged: onChangValue,
              // onSaved: (v){},
            ),
          ),
          textInputType ==null? const SizedBox(
            height: 5,
          ) : const SizedBox()
        ],
      ),
    );
  }
}