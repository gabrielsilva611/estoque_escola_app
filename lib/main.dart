import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_screen.dart';


void main() async {

  await Supabase.initialize(
    url: 'https://ykppnlhznvhlfsgngzuy.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlrcHBubGh6bnZobGZzZ25nenV5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzA4NDUzMjMsImV4cCI6MjA0NjQyMTMyM30.tNYUmX3pHwxE9YiYCdQdvX3fKVRiAF33yFCTpdfVVx4',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
    );
  }
}
