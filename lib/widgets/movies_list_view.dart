import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recommender_system/business_logic/bloc/home_screen_bloc.dart';
import 'package:recommender_system/business_logic/events/home_screen_events.dart';

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
  Timer? _debounce;
  final textController = TextEditingController();

  _onRatingChange(String value, BuildContext context) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (value != "") {
        try {
          context
              .read<HomeScreenBloc>()
              .add(UpdateOrInsertMovieEvent(widget.title, double.parse(value)));
        } catch (e) {}
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
        title: Text(widget.title),
        value: _checked,
        secondary: SizedBox(
          height: 30,
          width: 50,
          child: TextField(
            onChanged: (value) => _onRatingChange(value, context),
            controller: textController,
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
        onChanged: (value) {
          setState(
            () {
              _checked = value!;
            },
          );
          if (value == false) {
            if (textController.text != "") {
              context
                  .read<HomeScreenBloc>()
                  .add(DeleteMovieEvent(widget.title));
            }
            textController.text = "";
          } else if (value == true) {
            if (textController.text != "") {
              context.read<HomeScreenBloc>().add(InsertMovieEvent(
                  widget.title, double.parse(textController.text)));
            }
          }
        });
  }
}
