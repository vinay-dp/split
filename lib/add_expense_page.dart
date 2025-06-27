import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  // Add a selected date variable, with default now
  DateTime _selectedDate = DateTime.now();

  // Example: hardcoded users for splitting
  final List<Map<String, dynamic>> _users = [
    {'name': 'You', 'selected': true},
    {'name': 'Sarah Wilson', 'selected': true},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Add New Expense'),
        titleTextStyle: TextStyle(fontSize: 18),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(height: 1, color: Color(0xffF3F4F6)),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                // Only allow numbers and up to one decimal point
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xff9CA3AF),
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                hintText: '\$ 0.00',
                hintStyle: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff9CA3AF),
                ),
                border: InputBorder.none,
              ),
            ),
            Divider(height: 1, color: Color(0xffF3F4F6)),
            TextFormField(
              controller: _descController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                hintText: 'What\'s this expense for?',
                hintStyle: TextStyle(fontSize: 16, color: Color(0xff9CA3AF)),
                border: InputBorder.none,
              ),
            ),
            Divider(height: 1, color: Color(0xffF3F4F6)),
            // Replace the fixed "Today" row with a GestureDetector to open date picker
            Padding(
              padding: const EdgeInsets.all(16),
              child: GestureDetector(
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(3000),
                  );
                  if(pickedDate != null) {
                    setState(() {
                      _selectedDate = pickedDate;
                    });
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_month_outlined),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            '${_selectedDate.toLocal()}'.split(' ')[0],
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios_rounded, color: Color(0xff9CA3AF)),
                  ],
                ),
              ),
            ),
            Divider(height: 1, color: Color(0xffF3F4F6)),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Paid by'),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage('images/avatar.jpg'),
                        minRadius: 18,
                      ),
                      SizedBox(width: 10),
                      Text('You'),
                      Icon(Icons.keyboard_arrow_down_rounded),
                    ],
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: Color(0xffF3F4F6)),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Split Between',
                    style: TextStyle(color: Color(0xff4B5563)),
                  ),
                  SizedBox(height: 15),
                  ..._users.map((user) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: AssetImage('images/avatar.jpg'),
                              minRadius: 18,
                            ),
                            SizedBox(width: 10),
                            Text(user['name']),
                          ],
                        ),
                        Switch(
                          value: user['selected'],
                          onChanged: (bool value) {
                            setState(() {
                              user['selected'] = value;
                            });
                          },
                        ),
                      ],
                    ),
                  )),
                  SizedBox(height: 40),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            final double? amount = double.tryParse(
                                _amountController.text.replaceAll('\$', '').trim());
                            final String desc = _descController.text.trim();
                            final selectedUsers = _users.where((u) => u['selected']).toList();
                            if (amount != null && amount > 0 && desc.isNotEmpty && selectedUsers.isNotEmpty) {
                              double splitAmount = selectedUsers.length == 1 ? 0.0 : amount / selectedUsers.length;
                              Navigator.of(context).pop({
                                'amount': amount,
                                'desc': desc,
                                'splitAmount': splitAmount,
                                'users': selectedUsers.map((u) => u['name']).toList(),
                                'paidBy': 'You',
                                // Pass the selected date instead of DateTime.now()
                                'date': _selectedDate,
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Please enter valid details')),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff5B68FF),
                            foregroundColor: Color(0xffFFFFFF),
                            padding: EdgeInsets.symmetric(vertical: 18),
                            textStyle: TextStyle(fontSize: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text('Split Expense'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}