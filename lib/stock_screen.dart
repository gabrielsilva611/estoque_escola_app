import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StockScreen extends StatefulWidget {
  @override
  _StockScreenState createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  final supabase = Supabase.instance.client;

  List<Map<String, dynamic>> schoolStock = [];
  List<Map<String, dynamic>> foodCleaningStock = [];

  @override
  void initState() {
    super.initState();
    fetchStocks();
  }

  Future<void> fetchStocks() async {
    try {
      final schoolResponse = await supabase
          .from('produto')
          .select()
          .eq('location', 'Estoque escolar');

      final foodCleaningResponse = await supabase
          .from('produto')
          .select()
          .eq('location', 'Estoque comida, limpeza');

      setState(() {
        schoolStock = List<Map<String, dynamic>>.from(schoolResponse);
        foodCleaningStock = List<Map<String, dynamic>>.from(foodCleaningResponse);
      });
    } catch (e) {
      _showError(e.toString());
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Erro: $message")),
    );
  }

  Widget _buildStockList(List<Map<String, dynamic>> stockList) {
    if (stockList.isEmpty) {
      return Center(
        child: Text("Nenhum produto encontrado."),
      );
    }

    return ListView.builder(
      itemCount: stockList.length,
      itemBuilder: (context, index) {
        final product = stockList[index];
        return ListTile(
          title: Text(product['name']),
          subtitle: Text(
              "Quantidade: ${product['quantity']} \nEstoque: ${product['location']}"),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Estoque"),
          bottom: TabBar(
            tabs: [
              Tab(text: "Estoque Escolar"),
              Tab(text: "Comida e Limpeza"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildStockList(schoolStock),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildStockList(foodCleaningStock),
            ),
          ],
        ),
      ),
    );
  }
}
