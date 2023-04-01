import 'package:flutter/material.dart';

class MoviesListView extends StatelessWidget {
  final List<String> moviesName;

  const MoviesListView({super.key, required this.moviesName});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: moviesName.length,
      itemBuilder: (context, index) =>
          CheckBoxListItem(title: moviesName[index]),
    );
  }
}

class CheckBoxListItem extends StatefulWidget {
  final String title;
  const CheckBoxListItem({super.key, required this.title});

  @override
  State<CheckBoxListItem> createState() => _CheckBoxListItemState();
}

class _CheckBoxListItemState extends State<CheckBoxListItem> {
  bool _checked = false;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(widget.title),
      value: _checked,
      secondary: SizedBox(
        height: 30,
        width: 50,
        child: TextField(
          enabled: _checked,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 10),
            border: OutlineInputBorder(),
          ),
        ),
      ),
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (value) => setState(
        () {
          _checked = value!;
        },
      ),
    );
  }
}
