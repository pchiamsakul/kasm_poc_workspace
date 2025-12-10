import 'package:flutter/material.dart';
import 'package:kasm_poc_workspace/core/helper/debouncer.dart';

import '../constant/k_color.dart';

class SearchView extends StatefulWidget {
  final bool? autocorrect;
  final InputDecoration? decoration;
  final Function(String) onChanged;
  final FocusNode focusNode;
  final TextEditingController controller;
  final TextStyle? style;
  final TextInputType? keyboardType;
  final Key? searchBarKey;
  final Color? backgroundColor;
  final int debouncing;
  final String hint;

  const SearchView({
    super.key,
    required this.onChanged,
    required this.controller,
    required this.focusNode,
    this.decoration,
    this.autocorrect,
    this.style,
    this.keyboardType,
    this.searchBarKey,
    this.backgroundColor = Colors.white,
    this.debouncing = 400,
    this.hint = "",
  });

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  late final Debouncer debouncer = Debouncer(milliseconds: widget.debouncing);

  @override
  void dispose() {
    super.dispose();
    debouncer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: widget.searchBarKey,
      keyboardType: widget.keyboardType ?? TextInputType.name,
      focusNode: widget.focusNode,
      autocorrect: widget.autocorrect ?? false,
      onChanged: (text) {
        debouncer.run(() {
          widget.onChanged(text);
        });
      },
      onFieldSubmitted: (text) {
        widget.focusNode.unfocus();
        debouncer.clear();
        widget.onChanged(text);
      },
      textInputAction: TextInputAction.search,
      controller: widget.controller,
      cursorColor: KColors.primary,
      decoration: widget.decoration ??
          InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
            hintText: !widget.focusNode.hasFocus ? widget.hint : null,
            filled: widget.backgroundColor != null,
            fillColor: widget.backgroundColor,
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1.5),
              borderRadius: BorderRadius.all(Radius.circular(24.0)),
            ),
            prefixIcon: const Padding(
                padding: EdgeInsets.fromLTRB(16.0, 12.0, 8.0, 12.0),
                child: Icon(Icons.search, color: Colors.grey)),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: KColors.primary, width: 1.5),
              borderRadius: BorderRadius.all(Radius.circular(24.0)),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 1.5),
              borderRadius: BorderRadius.all(Radius.circular(24.0)),
            ),
            suffixIcon: ValueListenableBuilder(
                valueListenable: widget.controller,
                builder: (context, value, child) {
                  return value.text.isEmpty
                      ? Container(width: 0)
                      : Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 12.0, 16.0, 12.0),
                          child: InkWell(
                              onTap: () {
                                widget.focusNode.unfocus();
                                widget.controller.text = '';
                                final text = widget.controller.text;
                                widget.onChanged(text);
                              },
                              child: const Icon(Icons.close, color: Colors.grey)),
                        );
                }),
          ),
      style: widget.style,
    );
  }
}
