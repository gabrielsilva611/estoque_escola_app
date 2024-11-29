import 'package:flutter/material.dart';
import '/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:postgres/postgres.dart';


void main() async {
  // Inicialize o Supabase
  await Supabase.initialize(
    url: 'https://ykppnlhznvhlfsgngzuy.supabase.co', // Substitua pela URL do seu Supabase
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlrcHBubGh6bnZobGZzZ25nenV5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzA4NDUzMjMsImV4cCI6MjA0NjQyMTMyM30.tNYUmX3pHwxE9YiYCdQdvX3fKVRiAF33yFCTpdfVVx4', // Substitua pela sua anonKey
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DatabaseTestScreen(),
    );
  }
}

class DatabaseTestScreen extends StatefulWidget {
  @override
  _DatabaseTestScreenState createState() => _DatabaseTestScreenState();
}

class _DatabaseTestScreenState extends State<DatabaseTestScreen> {
  String connectionStatus = 'Clique no botão para testar a conexão';

  Future<void> connectToDatabase() async {
    final connection = PostgreSQLConnection(
      'aws-0-sa-east-1.pooler.supabase.com', // Host do banco
      6543, // Porta
      'Controle de Estoque', // Nome do banco
      username: 'postgres', // Usuário
      password: 'Gordo@viado', // Substitua pela senha real do banco
      useSSL: true, // Supabase exige SSL
    );

    try {
      // Abrir a conexão
      await connection.open();
      setState(() {
        connectionStatus = 'Conexão estabelecida com sucesso!';
      });

      // Realizar uma consulta
      final results = await connection.query('SELECT NOW();');
      print('Data/Hora do servidor: ${results[0][0]}');

      // Atualizar o status na interface
      setState(() {
        connectionStatus = 'Consulta realizada com sucesso: ${results[0][0]}';
      });

      // Fechar a conexão
      await connection.close();
    } catch (e) {
      setState(() {
        connectionStatus = 'Erro ao conectar: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teste de Conexão ao PostgreSQL'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(connectionStatus, textAlign: TextAlign.center),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: connectToDatabase,
              child: Text('Conectar ao Banco'),
            ),
          ],
        ),
      ),
    );
  }
  
  PostgreSQLConnection(String s, int i, String t, {required String username, required String password, required bool useSSL}) {}
}
