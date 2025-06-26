import 'package:flutter/material.dart';
import 'package:split_share_app/OverlappingAvatars.dart';
import 'package:split_share_app/add_expense_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Split & Share',
          style: TextStyle(fontWeight: FontWeight.bold),
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
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add'),
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
              height: 174,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: _carddetails('You', '\$ 45.50', 'Y', Colors.red),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: _carddetails('Sarah', '\$ 25.50', 'A', Colors.green),
                  ),
                  _carddetails('Bablu Sam', '\$ 5.50', 'B', Colors.green),
                ],
              ),
            ),
            SizedBox(height: 30),
            Text(
              'Recent Activities',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                scrollDirection: Axis.vertical,
                children: [
                  _recentdetails(
                    'Dinner at Italian Restaurant',
                    'Today',
                    '\$156.00',
                    'Sarah',
                  ),
                  SizedBox(height: 12),
                  _recentdetails(
                    'Grocery Shopping',
                    'Yesterday',
                    '\$89.50',
                    'You',
                  ),
                  SizedBox(height: 12),
                  _recentdetails(
                    'Movie Tickets',
                    '2 days ago',
                    '\$45.00',
                    'Mike',
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AddExpensePage(),
                        ),
                      );
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
) {
  return Card(
    color: Colors.white,
    child: Container(
      height: 160,
      width: 160,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xffF3F4F6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xff5B68FF),
            ),
            alignment: Alignment.center,
            child: Text(
              avatar,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              name,
              style: TextStyle(fontSize: 16, color: Color(0xff6E7787)),
            ),
          ),

          Text(
            amount,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textcolor,
              // letterSpacing: 0,
            ),
          ),
          Text(
            'you owe',
            style: TextStyle(fontSize: 14, color: Color(0xff6E7787)),
          ),
        ],
      ),
    ),
  );
}

Widget _recentdetails(String title, String Date, String price, String user) {
  return Card(
    color: Colors.white,
    child: Container(
      padding: EdgeInsets.all(16),
      height: 135,
      width: double.maxFinite,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xffF3F4F6)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff1A1D1F),
                ),
              ),
              Text(Date),
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
                  child: Stack(children: [OverlappingAvatars(count: 4)]),
                ),
              ),
              Text('Paid by $user'),
            ],
          ),
        ],
      ),
    ),
  );
}
