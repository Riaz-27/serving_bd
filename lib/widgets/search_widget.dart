import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  final String text;
  final ValueChanged<String> onChanged;
  final String hintText;
  final bool autoFocus;

  const SearchWidget({
    Key? key,
    required this.text,
    required this.onChanged,
    required this.hintText,
    required this.autoFocus,
  }) : super(key: key);

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller;
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: controller,
          onChanged: widget.onChanged,
          maxLines: 1,
          autofocus: widget.autoFocus,
          decoration: InputDecoration(
            isDense: true,
            hintText: widget.hintText,
            border: InputBorder.none,
            icon: const Icon(Icons.search),
            suffixIcon: widget.text.isNotEmpty
                ? GestureDetector(
                    child: const Icon(Icons.close),
                    onTap: () {
                      controller.clear();
                      widget.onChanged('');
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
