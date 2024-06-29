import 'package:flutter/material.dart';
import 'package:food_for_thought/user-interface/user-functions/forgot_password_page.dart';
import 'package:food_for_thought/user-interface/side-menu/help_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'user-interface/home_page.dart';
import 'user-interface/user-functions/login_page.dart';
import 'user-interface/user-functions/registration_page.dart';
import 'back-end/supabase_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  runApp(MyApp());
}

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final _future = Supabase.instance.client.from('todos').select();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final todos = snapshot.data!;
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return ListTile(
                title: Text(todo['name']),
              );
            },
          );
        },
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          scaffoldBackgroundColor: Color.fromARGB(242, 255, 255, 255)),
      debugShowCheckedModeBanner: false,
      initialRoute: 'login_page',
      routes: {
        'registration_page': (context) => RegistrationPage(),
        'login_page': (context) => LoginPage(),
        'home_page': (context) => HomePage(),
        'forgot_password_page': (context) => ForgotPasswordPage(),
        'help_page': (context) => HelpPage(),
        'todo_page': (context) => TodoPage(),
      },
    );
  }
}
