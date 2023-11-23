import 'package:flutter/material.dart';

import 'package:get_api/models/user_model.dart';
import 'package:get_api/services/http_services.dart';

HttpService httpService = HttpService();

class DropDownBuilder extends StatefulWidget {
  final Function(UserModel?) onUserChanged;
  final bool isPostUserDownButton;
  const DropDownBuilder(
      {super.key,
      required this.onUserChanged,
      required this.isPostUserDownButton});

  @override
  State<DropDownBuilder> createState() => _DropDownBuilderState();
}

class _DropDownBuilderState extends State<DropDownBuilder> {
  String? selectedValue;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<UserModel?>>(
        future: httpService.getUsers(),
        builder: ((context, snapshot) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final List<DropdownMenuItem<String>> items = [
              if (!widget.isPostUserDownButton)
                const DropdownMenuItem(
                  value: "",
                  child: Text('All Users'),
                ),
              ...snapshot.data!.map((e) {
                return DropdownMenuItem(
                  value: e?.name.toString(),
                  child: Text("${e!.name} User : ${e.id}"),
                );
              }).toList(),
            ];

            return Container(
              width: 350,
              height: 38,
              padding: const EdgeInsets.all(8),
              decoration: (BoxDecoration(
                color: Colors.lightBlue,
                borderRadius: BorderRadius.circular(30),
              )),
              child: DropdownButton(
                isExpanded: true,
                hint: const Text("select user",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
                items: items,
                onChanged: (value) {
                  setState(() {
                    selectedValue = value;
                    UserModel? selectedUser = value != ""
                        ? snapshot.data!
                            .firstWhere((user) => user?.name == value)
                        : null;

                    widget.onUserChanged(selectedUser);
                  });
                },
                value: selectedValue,
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        }));
  }
}
