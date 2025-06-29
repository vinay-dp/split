import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddExpensePage extends StatefulWidget {
  final List<String> availableUsers;
  const AddExpensePage({super.key, this.availableUsers = const []});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  List<Map<String, dynamic>> _users = [];
  String? _selectedPayer;

  @override
  void initState() {
    super.initState();
    _users = widget.availableUsers.map((userName) => {
      'name': userName,
      'selected': true, 
      'avatar': 'images/avatar.jpg' 
    }).toList();

    if (widget.availableUsers.isNotEmpty) {
      if (widget.availableUsers.contains('You')) {
        _selectedPayer = 'You';
      } else {
        _selectedPayer = widget.availableUsers.first;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Add New Expense'),
        titleTextStyle: TextStyle(fontSize: 18, color: Colors.black),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(height: 1, color: Color(0xffF3F4F6)),
          TextFormField(
            controller: _amountController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Paid by',
                  style: TextStyle(fontSize: 16, color: Color(0xff4B5563)),
                ),
                SizedBox(height: 10),
                if (widget.availableUsers.isNotEmpty)
                  DropdownButtonFormField<String>(
                    value: _selectedPayer,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Color(0xffD1D5DB)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Color(0xffD1D5DB)),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    hint: Text('Select Payer'),
                    isExpanded: true,
                    items: widget.availableUsers.map((String user) {
                      return DropdownMenuItem<String>(
                        value: user,
                        child: Text(user),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedPayer = newValue;
                      });
                    },
                    validator: (value) => value == null ? 'Please select a payer' : null,
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Text(
                      'No users available. Add users on the home screen.',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
              ],
            ),
          ),
          Divider(height: 1, color: Color(0xffF3F4F6)),
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Split Between',
              style: TextStyle(color: Color(0xff4B5563)),
            ),
          ),
          SizedBox(height: 15),
          // Only this section scrolls
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  final user = _users[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: AssetImage(user['avatar']),
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
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              final double? parsedAmount = double.tryParse(
                  _amountController.text.replaceAll('\$', '').trim());
              final String desc = _descController.text.trim();
              final selectedUsers = _users.where((u) => u['selected'] as bool).toList();

              String errorMessage = '';
              if (parsedAmount == null || parsedAmount <= 0) {
                errorMessage = 'Please enter a valid amount.';
              } else if (desc.isEmpty) {
                errorMessage = 'Please enter a description.';
              } else if (_selectedPayer == null) {
                errorMessage = 'Please select who paid.';
              } else if (selectedUsers.isEmpty) {
                errorMessage = 'Please select users to split with.';
              }

              if (errorMessage.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(errorMessage)),
                );
              } else {
                final double amount = parsedAmount!;
                double splitAmount;
                if (selectedUsers.length == 1 && selectedUsers[0]['name'] == _selectedPayer) {
                  splitAmount = amount;
                } else {
                  splitAmount = amount / selectedUsers.length;
                }
                Navigator.of(context).pop({
                  'amount': amount,
                  'desc': desc,
                  'splitAmount': splitAmount,
                  'users': selectedUsers.map((u) => u['name'] as String).toList(),
                  'paidBy': _selectedPayer!,
                  'date': _selectedDate,
                });
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xff5B68FF),
              foregroundColor: Color(0xffFFFFFF),
              textStyle: TextStyle(fontSize: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text('Add Expense'),
          ),
        ),
      ),
    );
  }
}
