import 'package:flutter/material.dart';

class TextPasswordField extends StatefulWidget {
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

  const TextPasswordField({
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
  State<TextPasswordField> createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextPasswordField> {
  bool _passwordVisibility = true;
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
              obscureText: _passwordVisibility,
              readOnly: widget.readonly,
              initialValue: widget.initialValue,
              decoration: InputDecoration(
                labelText: widget.labelText,
                labelStyle: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: Theme.of(context).textTheme.bodyText1!.fontSize,
                  color: Theme.of(context).textTheme.bodyText1!.color,
                ),
                hintText: widget.hintText,
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
                suffixIcon: widget.isPassword
                    ? InkWell(
                        onTap: () => setState(
                          () => _passwordVisibility = !_passwordVisibility,
                        ),
                        focusNode: FocusNode(skipTraversal: true),
                        child: Icon(
                          _passwordVisibility
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
              validator: widget.validator,
              onSaved: widget.onSaved,
            ),
          ),
        ],
      ),
    );
  }
}
