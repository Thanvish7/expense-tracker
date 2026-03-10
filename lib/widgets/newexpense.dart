import 'package:expense_tracker/model/expense.dart';
import 'package:flutter/material.dart';

class Newexpense extends StatefulWidget {
  Newexpense({super.key, required this.addexpense});

  final Function(Expense e) addexpense;

  @override
  State<Newexpense> createState() {
    return _newexpensestate();
  }
}

class _newexpensestate extends State<Newexpense> {
  final titlecontrol = TextEditingController();
  final amountcontrol = TextEditingController();
  DateTime? datepick;
  Category selectedcategory = Category.place;

  void datepicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final lastDate = now;
    final datepicked = await showDatePicker(
      context: context,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    setState(() {
      datepick = datepicked;
    });
  }

  void submitexpense() {
    final eneteredamount = double.tryParse(amountcontrol.text);
    final amountinvalid = eneteredamount == null || eneteredamount <= 0;
    if (titlecontrol.text.trim().isEmpty || amountinvalid || datepick == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          titleTextStyle: TextStyle(color: Colors.black),
          title: Text("INVALID DATA"),
          content: Text("please enter valid title,amount,date"),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    widget.addexpense(
      Expense(
        title: titlecontrol.text,
        amount: eneteredamount,
        date: datepick!,
        category: selectedcategory,
      ),
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    titlecontrol.dispose();
    amountcontrol.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20,50,20,20),
      child: Column(
        children: [
          TextField(
            controller: titlecontrol,
            maxLength: 50,
            decoration: InputDecoration(label: Text("Title")),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: amountcontrol,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixText: "\$ ",
                    label: Text("Amount"),
                  ),
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      datepick == null
                          ? "no date picked"
                          : formatter.format(datepick!),
                    ),
                    IconButton(
                      onPressed: datepicker,
                      icon: Icon(Icons.calendar_month_rounded),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Row(
            children: [
              DropdownButton(
                value: selectedcategory,
                items: Category.values
                    .map(
                      (Category) => DropdownMenuItem(
                        value: Category,
                        child: Text(Category.name.toUpperCase()),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    selectedcategory = value;
                  });
                },
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("CANCEL"),
              ),
              ElevatedButton(
                onPressed: submitexpense,
                child: Text("save expense"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
