import 'package:flutter/material.dart';

class AddExpensePage extends StatelessWidget {
  const AddExpensePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Add New Expense'),
        titleTextStyle: TextStyle(fontSize: 18),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(height: 1, color: Color(0xffF3F4F6)),
          TextFormField(
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_month_outlined),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text('Today', style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
                Icon(Icons.arrow_forward_ios_rounded, color: Color(0xff9CA3AF)),
              ],
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage('images/avatar.jpg'),
                          minRadius: 18,
                        ),
                        SizedBox(width: 10),
                        Text('Sarah Wilson'),
                      ],
                    ),
                    Switch(value: true, onChanged: (bool value) {}),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage('images/avatar.jpg'),
                          minRadius: 18,
                        ),
                        SizedBox(width: 10),
                        Text('Sarah Wilson'),
                      ],
                    ),
                    Switch(value: true, onChanged: (bool value) {}),
                  ],
                ),
                SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
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
    );
  }
}
