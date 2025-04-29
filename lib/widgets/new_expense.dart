import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/expense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddNewExpenses});

  final Function(Expense expense) onAddNewExpenses;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {

  final TextEditingController _titleTextEditingController = TextEditingController();
  final TextEditingController _amountTextEditingController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategories = Category.leisure;

  _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context, firstDate: firstDate, lastDate: now);

    setState(() {
      _selectedDate = pickedDate;
    });
  }

   _showDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (ctx) => CupertinoAlertDialog(
            title: const Text('Invalid input'),
            content: const Text(
                'Please make sure a valid title, amount, date and category was entered.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text('Okay'),
              ),
            ],
          ));
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text(
              'Please make sure a valid title, amount, date and category was entered.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
    }
  }

  _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountTextEditingController.text);
    // tryParse('Hello') => null, tryParse('1.12') => 1.12
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleTextEditingController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      _showDialog();
      return;//whenever you return in a function you make sure that no code there after in that function gets
      // executed
    }
    widget.onAddNewExpenses(Expense(
        title: _titleTextEditingController.text,
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectedCategories));

    Navigator.pop(context);
  }


  @override
  void dispose() {
    _titleTextEditingController.dispose();
    _amountTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(builder: (ctx, constraints){
      final width = constraints.maxWidth;
      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
            child: Column(
              children: [
                if (width >= 600)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _titleTextEditingController,
                          maxLength: 50,
                          decoration: const InputDecoration(
                            label: Text('Title'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),

                      Expanded(
                        child: TextField(
                          controller: _amountTextEditingController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefixText: '\$ ',
                            label: Text('Amount'),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  TextField(
                    controller: _titleTextEditingController,
                    maxLength: 50,
                    decoration: const InputDecoration(
                      label: Text('Title'),
                    ),
                  ),
                if (width >= 600)
                  Row(children: [
                    DropdownButton(
                      value: _selectedCategories,
                      items: Category.values
                          .map(
                            (category) => DropdownMenuItem(
                          value: category,
                          child: Text(
                            category.name.toUpperCase(),
                          ),
                        ),
                      )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        setState(() {
                          _selectedCategories = value;
                        });
                      },
                    ),
                    SizedBox(width: 24),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            _selectedDate == null
                                ? 'No date selected'
                                : formatter.format(_selectedDate!),
                          ),
                          IconButton(
                            onPressed: _presentDatePicker,
                            icon: const Icon(
                              Icons.calendar_month,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ])
                else
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _amountTextEditingController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefixText: '\$ ',
                            label: Text('Amount'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 7),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _selectedDate == null
                                  ? 'No date selected'
                                  : formatter.format(_selectedDate!),
                            ),
                            IconButton(
                              onPressed: _presentDatePicker,
                              icon: const Icon(
                                Icons.calendar_month,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 16),
                if (width >= 600)
                  Row(children: [
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: _submitExpenseData,
                      child: const Text('Save Expense'),
                    ),
                  ])
                else
                  Row(
                    children: [
                      DropdownButton(
                        value: _selectedCategories,
                        items: Category.values
                            .map(
                              (category) => DropdownMenuItem(
                            value: category,
                            child: Text(
                              category.name.toUpperCase(),
                            ),
                          ),
                        )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setState(() {
                            _selectedCategories = value;
                          });
                        },
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: _submitExpenseData,
                        child: const Text('Save Expense'),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }
}


//       SizedBox(
//       height: double.infinity,
//       child: SingleChildScrollView(
//         child: Padding(
//           padding:  EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace+16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextField(
//                 controller: _titleTextEditingController,
//                 maxLength: 50,
//                 decoration: InputDecoration(label: Text('Title')),
//               ),
//
//               Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _amountTextEditingController,
//                       keyboardType: TextInputType.number,
//                       decoration: const InputDecoration(
//                         prefixText: '\$ ',
//                         label: Text('Amount'),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 7),
//                   Expanded(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Text(
//                           _selectedDate == null
//                               ? 'No date selected'
//                               : formatter.format(_selectedDate!),
//                         ),
//                         IconButton(
//                           onPressed: _presentDatePicker,
//                           icon: const Icon(
//                             Icons.calendar_month,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 16,
//               ),
//               Row(
//                 children: [
//                   DropdownButton(
//                     value: _selectedCategories,
//                     items: Category.values
//                         .map(
//                           (category) => DropdownMenuItem(
//                             value: category,
//                             child: Text(category.name.toUpperCase()),
//                           ),
//                         )
//                         .toList(),
//                     onChanged: (value) {
//                       if (value == null) {
//                         return;
//                       }
//                       setState(() {
//                         _selectedCategories = value;
//                       });
//                     },
//                   ),
//                   Spacer(),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     child: Text('cancle'),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       _submitExpenseData();
//                     },
//                     child: Text('Save Expense'),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
