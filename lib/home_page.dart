import 'dart:math';
import 'package:flutter/material.dart';
import 'package:split_share/OverlappingAvatars.dart';
import 'package:split_share/add_expense_page.dart';
import 'package:split_share/user_avatar.dart';
import 'firebase_service.dart';
import 'package:intl/intl.dart'; // <-- Add this import

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _userNameController = TextEditingController();
  List<Map<String, dynamic>> _addedUsers = [
    {'name': 'You', 'color': Color(0xff5B68FF)},
  ]; // Now stores name and color
  Map<String, double> _balances = {};
  List<Map<String, dynamic>> _expenses = [];

  @override
  void initState() {
    super.initState();
    _fetchExpenses();
    _recalculateBalances();
  }

  Future<void> _fetchExpenses() async {
    try {
      final expenses = await FirebaseService().getExpenses();
      setState(() {
        _expenses = expenses.map((expense) {
          if (expense['date'] is String) {
            expense['date'] = DateTime.parse(expense['date']);
          }
          if (expense['users'] is List<dynamic>) {
            expense['users'] = List<String>.from(expense['users']);
          }
          return expense;
        }).toList();

        // --- Ensure all users from expenses have a color in _addedUsers ---
        final allExpenseUsers = <String>{};
        for (var exp in _expenses) {
          allExpenseUsers.add(exp['paidBy'] as String);
          allExpenseUsers.addAll(exp['users'] as List<String>);
        }
        for (var user in allExpenseUsers) {
          if (!_addedUsers.any((u) => u['name'] == user)) {
            // Use the same color logic as UserAvatar for consistency
            _addedUsers.add({
              'name': user,
              'color': _getColorFromName(user),
            });
          }
        }
        // ---------------------------------------------------------------

        _recalculateBalances(); // <-- Ensure balances are recalculated after fetching
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load expenses: $e')),
      );
    }
  }

  List<String> get _allExpenseUsers {
    final allUsers = <String>{};
    allUsers.addAll(_addedUsers.map((u) => u['name'] as String)); // Add users from the modal
    for (var exp in _expenses) {
      allUsers.add(exp['paidBy'] as String);
      allUsers.addAll(exp['users'] as List<String>);
    }
    var sortedUsers = allUsers.toList();
    // Ensure "You" is first if present
    if (sortedUsers.contains('You')) {
      sortedUsers.remove('You');
      sortedUsers.insert(0, 'You');
    }
    return sortedUsers;
  }


  void _addExpense(Map<String, dynamic> expenseData) {
    setState(() {
      if (expenseData['date'] is String) {
        expenseData['date'] = DateTime.parse(expenseData['date']);
      }
      _expenses.add(expenseData);
      _recalculateBalances();
    });
  }

  void _recalculateBalances() {
    final newBalances = <String, double>{};
    for (var user in _allExpenseUsers) {
      newBalances[user] = 0.0;
    }

    for (var expense in _expenses) {
      final paidBy = expense['paidBy'] as String;
      final amount = expense['amount'] as double;
      final involvedUsers = expense['users'] as List<String>;
      final splitAmount = expense['splitAmount'] as double;

      // Increase the payer's balance by the full paid amount.
      newBalances[paidBy] = (newBalances[paidBy] ?? 0.0) + amount;

      // Subtract each involved user's share unless the only involved user is the payer.
      for (var user in involvedUsers) {
        if (involvedUsers.length == 1 && user == paidBy) continue;
        newBalances[user] = (newBalances[user] ?? 0.0) - splitAmount;
      }
    }
    _balances = newBalances;
  }


  void _showAddUserModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              // Move errorText outside the builder to persist its value
              return _AddUserModalContent(
                userNameController: _userNameController,
                addedUsers: _addedUsers,
                onAddUser: (String newUserName) {
                  setState(() {
                    _addedUsers.add({
                      'name': newUserName,
                      'color': _getRandomColor(),
                    });
                    if (!_balances.containsKey(newUserName)) {
                      _balances[newUserName] = 0.0;
                    }
                    _recalculateBalances();
                  });
                },

              );
            },
          ),
        );
      },
    );
  }

  Color _getColorFromName(String? name) {
    if (name == null || name.isEmpty) return Color(0xff5B68FF);
    final hash = name.codeUnits.fold(0, (prev, elem) => prev + elem);
    final rand = Random(hash);
    return Color.fromARGB(
      255,
      100 + rand.nextInt(156),
      100 + rand.nextInt(156),
      100 + rand.nextInt(156),
    );
  }

  Color _getRandomColor() {
    // fallback for manual add user
    final random = Random();
    return Color.fromARGB(
      255,
      100 + random.nextInt(156),
      100 + random.nextInt(156),
      100 + random.nextInt(156),
    );
  }


  @override
  Widget build(BuildContext context) {
     List<String> usersForCards = _allExpenseUsers;
     if (usersForCards.isEmpty) {
        // If there are no expenses and no manually added users other than default,
        // ensure at least "You" is shown, or prime with initial added users.
        usersForCards = _addedUsers.isNotEmpty ? List.from(_addedUsers) : ['You'];
         // Ensure all users in usersForCards have an entry in _balances
        for (var user in usersForCards) {
            if (!_balances.containsKey(user)) {
                _balances[user] = 0.0;
            }
        }
    }


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'SplitShare',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Icon(Icons.account_circle),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xff5B68FF),
        backgroundColor: Color(0xffffffff),
        elevation: 0,
        iconSize: 24,
        onTap: (index) {
          if (index == 1) { // Index 1 is 'Add User'
            _showAddUserModal();
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: 'Add User'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15),
            Container(
              height: 170,
              child: usersForCards.isEmpty
                  ? Center(child: Text('No users yet. Add users to see balances.'))
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      itemCount: usersForCards.length,
                      itemBuilder: (context, idx) {
                        final userOnCard = usersForCards[idx];
                        final balance = _balances[userOnCard] ?? 0.0;
                        String debtStatusText = "";

                        if (balance < 0) { // userOnCard needs to pay
                          final creditors = _balances.entries
                              .where((entry) => entry.key != userOnCard && entry.value > 0)
                              .map((entry) => entry.key)
                              .toList();
                          if (userOnCard == 'You') {
                            if (creditors.length == 1) {
                              debtStatusText = "You pay ${creditors.first}";
                            } else if (creditors.length > 1) {
                              debtStatusText = "You pay multiple people";
                            } else {
                              debtStatusText = "You need to pay"; // Fallback
                            }
                          } else { // Card for another user who needs to pay
                            if (creditors.contains('You')) {
                                if (creditors.length == 1) {
                                    debtStatusText = "$userOnCard pays You";
                                } else {
                                    debtStatusText = "$userOnCard pays You & others";
                                }
                            } else if (creditors.isNotEmpty) {
                                if (creditors.length == 1) {
                                    debtStatusText = "$userOnCard pays ${creditors.first}";
                                } else {
                                    debtStatusText = "$userOnCard pays others";
                                }
                            } else {
                              debtStatusText = "$userOnCard needs to pay"; // Fallback
                            }
                          }
                        } else if (balance > 0) { // userOnCard is to be paid
                          final debtors = _balances.entries
                              .where((entry) => entry.key != userOnCard && entry.value < 0)
                              .map((entry) => entry.key)
                              .toList();
                          if (userOnCard == 'You') {
                            if (debtors.length == 1) {
                              debtStatusText = "${debtors.first} pays You";
                            } else if (debtors.length > 1) {
                              debtStatusText = "Multiple people pay You";
                            } else {
                              debtStatusText = "You are to be paid"; // Fallback
                            }
                          } else { // Card for another user who is to be paid
                             if (debtors.contains('You')) {
                                if (debtors.length == 1) { // Only "You" owes this user
                                    debtStatusText = "You pay $userOnCard";
                                } else { // "You" and others owe this user
                                    debtStatusText = "You & others pay $userOnCard";
                                }
                            } else if (debtors.isNotEmpty) {
                                if (debtors.length == 1) {
                                    debtStatusText = "${debtors.first} pays $userOnCard";
                                } else {
                                    debtStatusText = "Others pay $userOnCard";
                                }
                            } else {
                              debtStatusText = "$userOnCard is to be paid"; // Fallback
                            }
                          }
                        } else { // balance is 0
                          debtStatusText = "Settled up";
                        }
                         if (debtStatusText.isEmpty) { // Final safety net
                            if (balance < 0) debtStatusText = (userOnCard == 'You' ? "You need to pay" : "$userOnCard needs to pay");
                            else if (balance > 0) debtStatusText = (userOnCard == 'You' ? "You are to be paid" : "$userOnCard is to be paid");
                            else debtStatusText = "Settled up";
                        }

                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: _carddetails(
                            userOnCard,
                            // Use absolute value for display, color indicates direction
                            '\₹ ${balance.abs().toStringAsFixed(2)}',
                            userOnCard.isNotEmpty ? userOnCard[0].toUpperCase() : '',
                            balance < 0 ? Colors.red : Colors.green,
                            debtStatusText,
                            _addedUsers, // Pass the addedUsers list for color lookup
                          ),
                        );
                      },
                    ),
            ),
            SizedBox(height: 30),
            Text(
              'Recent Activities',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: _expenses.isEmpty
                  ? Center(child: Text('No expenses yet'))
                  : ListView.builder(
                      itemCount: _expenses.length,
                      itemBuilder: (context, idx) {
                        final exp = _expenses[idx];
                        final date = exp['date'] as DateTime;
                        final dateStr = date.toIso8601String(); // <-- Pass ISO string
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _recentdetails(
                            exp['description'] ?? exp['desc'] ?? 'No description',
                            dateStr,
                            '\₹${(exp['amount'] as double).toStringAsFixed(2)}',
                            exp['paidBy'],
                            exp['users'] as List<String>,
                            _addedUsers, // Pass the addedUsers list for color lookup
                          ),
                        );
                      },
                    ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final result = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AddExpensePage(availableUsers: _allExpenseUsers), // Pass users here
                        ),
                      );
                      if (result != null && result is Map<String, dynamic>) {
                        _addExpense(result);
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
                    child: Text('Add New Expense'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

Widget _carddetails(
    String name,
    String amount,
    String avatar,
    Color textcolor,
    String debtStatusText,
    [List<Map<String, dynamic>>? addedUsers] // Add addedUsers as optional param
    ) {
  // Lookup color from addedUsers, fallback to default if not found
  final userColor = (addedUsers ?? []).firstWhere(
    (u) => u['name'] == name,
    orElse: () => {'color': const Color(0xff5B68FF)},
  )['color'] as Color;
  return Card(
    color: Colors.white,
    child: Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xffF3F4F6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Use UserAvatar with color
          UserAvatar(userName: name, backgroundColor: userColor),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              name,
              style: TextStyle(fontSize: 18, color: Color(0xff6E7787), fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textcolor,
            ),
          ),
          Text(
            debtStatusText,
            style: TextStyle(fontSize: 14, color: Color(0xff6E7787)),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ],
      ),
    ),
  );
}

Widget _recentdetails(String? title, String? date, String? price, String? user, List<String>? involvedUsers, [List<Map<String, dynamic>>? addedUsers]) {
  // Provide default values for null fields
  title ??= 'No description';
  date ??= 'Unknown date';
  price ??= '';     // Default price if null
  user ??= 'Unknown';
  involvedUsers ??= [];

  // Format date as DDMMYY HH:MM:am/pm
  String formattedDate = date;
  try {
    DateTime parsedDate = DateTime.parse(date);
    formattedDate = DateFormat('dd/MM/yy hh:mm:a').format(parsedDate);
  } catch (_) {
    formattedDate = date;
  }

  // Map involvedUsers (List<String>) to List<Map<String, dynamic>> with name and color
  List<Map<String, dynamic>> avatarUsers = involvedUsers.map((userName) {
    final match = (addedUsers ?? []).firstWhere(
      (u) => u['name'] == userName,
      orElse: () => {'name': userName, 'color': const Color(0xff5B68FF)},
    );
    return {'name': userName, 'color': match['color']};
  }).toList();

  return Card(
    color: Colors.white,
    child: Container(
      padding: EdgeInsets.all(16),
      width: double.maxFinite,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xffF3F4F6)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  title,
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff1A1D1F),
                  ),
                ),
              ),
              Text(formattedDate, style: TextStyle(color: Colors.grey, fontSize: 12),),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 15),
            child: Text(
              price,
              style: TextStyle(fontSize: 14, color: Color(0xff6E7787)),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SizedBox(
                  height: 30,
                  child: OverlappingAvatars(users: avatarUsers),
                ),
              ),
              RichText(
                text: TextSpan(
                  text: 'Paid by ',
                  style: TextStyle(color: Color(0xff6E7787), fontSize: 14),
                  children: [
                    TextSpan(
                      text: user,
                      style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff1A1D1F)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class _AddUserModalContent extends StatefulWidget {
  final TextEditingController userNameController;
  final List<Map<String, dynamic>> addedUsers;
  final ValueChanged<String> onAddUser;

  const _AddUserModalContent({
    required this.userNameController,
    required this.addedUsers,
    required this.onAddUser,
  });

  @override
  __AddUserModalContentState createState() => __AddUserModalContentState();
}

class __AddUserModalContentState extends State<_AddUserModalContent> {
  String? errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text('Add New User', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 15),
        TextField(
          controller: widget.userNameController,
          decoration: InputDecoration(
            hintText: 'Enter your username',
            hintStyle: TextStyle(color: Color(0xff9F9F9F)),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff9F9F9F)),
              borderRadius: BorderRadius.circular(8),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                width: 1,
                style: BorderStyle.solid,
                color: Color(0xff9F9F9F),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            errorText: errorText,
          ),
          onChanged: (_) {
            setState(() {});
          },

        ),

        SizedBox(height: 20),
        ElevatedButton(
          child: Text('Add User'),
          onPressed: () {
            final newUserName = widget.userNameController.text.trim();
            if (newUserName.isEmpty) {
              setState(() {
                errorText = 'Please enter a username';
              });
              return;
            }
            if (widget.addedUsers.any((u) => u['name'] == newUserName)) {
              setState(() {
                errorText = 'This username already exists';
              });
              return;
            }
            widget.onAddUser(newUserName);
            widget.userNameController.clear(); // Clear the controller after adding
            Navigator.pop(context);
          },
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
