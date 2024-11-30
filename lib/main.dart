import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


void main() async {
  // Inicialize o Supabase
  await Supabase.initialize(
    url: 'https://ykppnlhznvhlfsgngzuy.supabase.co', // Substitua pela URL do seu Supabase
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlrcHBubGh6bnZobGZzZ25nenV5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzA4NDUzMjMsImV4cCI6MjA0NjQyMTMyM30.tNYUmX3pHwxE9YiYCdQdvX3fKVRiAF33yFCTpdfVVx4', // Substitua pela sua anonKey
  );
  runApp(MyApp());

  Data();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Text(''),
    );
  }
}

class Data {
  void getData() async {
    final data =
        await     Supabase.instance.client.from('produto').select('nome_produto');

    print(data);
  }
}