import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            height: 150,
            alignment: Alignment.center,
            child: Image.asset('images/logo.png'),
          ),
          Text(
            'Split and Share',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xff2962FF),
            ),
          ),
          SizedBox(height: 40),
          Text(
            'Welcome Back!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 6),
          Text(
            'Easily split bills and settle up with friends',
            style: TextStyle(fontSize: 16, color: Color(0xff53433F)),
          ),
          SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Email',

                prefixIcon: Icon(Icons.mail_rounded),
                prefixIconColor: Color(0xff9F9F9F),
                hintText: 'Enter your email',
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
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Password',

                prefixIcon: Icon(Icons.lock),
                prefixIconColor: Color(0xff9F9F9F),
                suffixIcon: Icon(Icons.visibility),
                suffixIconColor: Color(0xff9F9F9F),
                hintText: 'Enter your password',
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
              ),
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Color(0xff2962FF),
                  ),
                  onPressed: () {},
                  child: Text('Forget Passoword?'),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff5B68FF),
                      foregroundColor: Color(0xffFFFFFF),
                      padding: EdgeInsets.symmetric(vertical: 18),
                      textStyle: TextStyle(fontSize: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Log In'),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Divider(thickness: 1)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text('or continue with'),
                ),
                Expanded(child: Divider(thickness: 1)),
              ],
            ),
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: MediaQuery.of(context).size.width - 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(width: 1, color: Color(0xff8F8F8F)),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('images/g-logo.png', width: 22),
                      SizedBox(width: 8),
                      Text(
                        'Google',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
