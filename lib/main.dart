import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Words of Grace',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple, // Use a purple primary color
        scaffoldBackgroundColor: const Color(
            0xFFF5F0FF), // Use a lavender-like color as scaffold background
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF573870),
          titleTextStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        textTheme: const TextTheme(
          headline6: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFF573870),
          ),
          subtitle1: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
          bodyText1: TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
          bodyText2: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
          button: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoggedIn = false;
  late Future<List<dynamic>> quotesFuture;
  late List<dynamic> quotes;

  void login(String email, String password) {
    if (email == 'test@gmail.com' && password == 'wordsofgrace') {
      setState(() {
        isLoggedIn = true;
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Wrong Password',
              style: TextStyle(fontSize: 16),
            ),
            content: const Text(
              'Please enter the correct password.',
              style: TextStyle(fontSize: 14),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    quotesFuture = fetchQuotes();
  }

  Future<List<dynamic>> fetchQuotes() async {
    final response = await http.get(Uri.parse('https://type.fit/api/quotes'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to fetch quotes');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoggedIn
          ? FutureBuilder<List<dynamic>>(
              future: quotesFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  quotes = snapshot.data!;
                  return QuotesScreen(quotes);
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text('Failed to fetch quotes'),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            )
          : SingleChildScrollView(child: LoginScreen(login)),
    );
  }
}

class LoginScreen extends StatefulWidget {
  final Function loginCallback;

  const LoginScreen(this.loginCallback, {Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network(
            'https://i.pinimg.com/564x/1c/91/5f/1c915f66071a06ddcb6fe5b623d7d87e.jpg',
            width: double.infinity,
            height: 200,
          ),
          const Text(
            "Words of Grace",
            style: TextStyle(
              color: Color(0xFF573870),
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text('A place to find quotes to make your life prettier ♡',
              style:
                  TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
          const SizedBox(
            height: 30.0,
          ),
          const Text(
            "Login to continue",
            style: TextStyle(
              color: Color.fromARGB(189, 17, 14, 14),
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: "Email",
              prefixIcon: Icon(Icons.email),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          TextField(
            controller: _passwordController,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              hintText: "Password",
              prefixIcon: Icon(Icons.lock),
            ),
          ),
          const SizedBox(
            height: 30.0,
          ),
          const Text(
            "Can't remember password?",
            style: TextStyle(
              color: Color(0xFF573870),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 5.0,
          ),
          const SizedBox(
            height: 30.0,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 66.0),
            width: double.infinity,
            child: RawMaterialButton(
              fillColor: const Color(0xFF573870),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              onPressed: () {
                widget.loginCallback(
                  _emailController.text,
                  _passwordController.text,
                );
              },
              child: const Text(
                "Login",
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 100.0,
          ),
          const Text(
            'made by @gunjaan',
            style: TextStyle(
              color: Color.fromARGB(255, 121, 119, 119),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class QuotesScreen extends StatelessWidget {
  final List<dynamic> quotes;

  const QuotesScreen(this.quotes, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF573870),
        title: const Text(
          'Quotes to make your life prettier ♡',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 5.0,
                  crossAxisSpacing: 5.0,
                ),
                itemCount: quotes.length,
                itemBuilder: (context, index) {
                  return QuoteCard(
                    quote: quotes[index]['text'],
                    author: quotes[index]['author'],
                  );
                },
              ),
            ),
            Container(
              alignment: Alignment.center,
              color: const Color.fromARGB(23, 110, 96, 121),
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: const Text(
                'made by @gunjaan',
                style: TextStyle(
                  color: Color.fromARGB(255, 84, 82, 82),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuoteCard extends StatelessWidget {
  final String? quote;
  final String? author;

  const QuoteCard({required this.quote, required this.author});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (quote != null)
              Expanded(
                child: Text(
                  quote!,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            const SizedBox(height: 10),
            if (author != null)
              Text(
                "- $author",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
