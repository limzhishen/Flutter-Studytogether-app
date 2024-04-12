import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final bool obscureText;
  //final TextEditingController? controller;

  final String? Function(String?)? validator;
  final String? Function(String?)? onSaved;
  final bool isPassword;
  final bool passwordVisibilityToggle;
  final void Function()? togglePasswordVisibility;
  final String? initialValue;
  final bool readonly;

  const TextInputField({
    Key? key,
    required this.labelText,
    required this.hintText,
    this.obscureText = false,
    //this.controller,
    this.onSaved,
    this.validator,
    this.isPassword = false,
    this.passwordVisibilityToggle = false,
    this.togglePasswordVisibility,
    this.initialValue,
    this.readonly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: TextFormField(
              // controller: controller,
              obscureText: obscureText,
              readOnly: readonly,
              initialValue: initialValue,
              decoration: InputDecoration(
                labelText: labelText,
                labelStyle: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: Theme.of(context).textTheme.bodyText1!.fontSize,
                  color: Theme.of(context).textTheme.bodyText1!.color,
                ),
                hintText: hintText,
                hintStyle: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: Theme.of(context).textTheme.bodyText1!.fontSize,
                    color: Theme.of(context).colorScheme.secondary),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.black,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.black,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.black,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.onPrimary,
                contentPadding: const EdgeInsetsDirectional.fromSTEB(
                  16,
                  24,
                  0,
                  24,
                ),
                suffixIcon: isPassword
                    ? InkWell(
                        onTap: togglePasswordVisibility,
                        focusNode: FocusNode(skipTraversal: true),
                        child: Icon(
                          obscureText
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Theme.of(context).colorScheme.onBackground,
                          size: 22,
                        ),
                      )
                    : null,
              ),
              style: TextStyle(
                fontFamily: 'Inter',
                color: Theme.of(context).colorScheme.onSecondary,
              ),
              validator: validator,
              onSaved: onSaved,
            ),
          ),
        ],
      ),
    );
  }
}

class TextInputField2 extends StatelessWidget {
  final String labelText;
  final String hintText;
  final bool obscureText;
  final TextEditingController? controller;

  final String? Function(String?)? validator;
  final String? Function(String?)? onSaved;
  final bool isPassword;
  final bool passwordVisibilityToggle;
  final void Function()? togglePasswordVisibility;
  final String? initialValue;
  final bool readonly;

  const TextInputField2({
    Key? key,
    required this.labelText,
    required this.hintText,
    this.obscureText = false,
    this.controller,
    this.onSaved,
    this.validator,
    this.isPassword = false,
    this.passwordVisibilityToggle = false,
    this.togglePasswordVisibility,
    this.initialValue,
    this.readonly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              obscureText: obscureText,
              readOnly: readonly,
              initialValue: initialValue,
              decoration: InputDecoration(
                labelText: labelText,
                labelStyle: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: Theme.of(context).textTheme.bodyText1!.fontSize,
                  color: Theme.of(context).textTheme.bodyText1!.color,
                ),
                hintText: hintText,
                hintStyle: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: Theme.of(context).textTheme.bodyText1!.fontSize,
                    color: Theme.of(context).colorScheme.secondary),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.black,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.black,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.black,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.onPrimary,
                contentPadding: const EdgeInsetsDirectional.fromSTEB(
                  16,
                  0,
                  0,
                  24,
                ),
                suffixIcon: isPassword
                    ? InkWell(
                        onTap: togglePasswordVisibility,
                        focusNode: FocusNode(skipTraversal: true),
                        child: Icon(
                          obscureText
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Theme.of(context).colorScheme.onBackground,
                          size: 22,
                        ),
                      )
                    : null,
              ),
              style: TextStyle(
                fontFamily: 'Inter',
                color: Theme.of(context).colorScheme.onSecondary,
              ),
              validator: validator,
              onSaved: onSaved,
            ),
          ),
        ],
      ),
    );
  }
}
