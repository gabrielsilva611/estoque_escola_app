import 'package:flutter/material.dart';

class StockScreen extends StatefulWidget {
  @override
  _StockScreenState createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  final TextEditingController codeController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  List<Map<String, dynamic>> stockMovements = [];

  void _showAddStockPopup() {
    String selectedDepot = 'Padrão';
    String selectedMovementType = 'Entrada';
    final TextEditingController productController = TextEditingController();
    final TextEditingController quantityController = TextEditingController();
    final TextEditingController observationController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Adicionar Movimento de Estoque"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: selectedDepot,
              items: ['Padrão', 'Depósito 1', 'Depósito 2']
                  .map((depot) => DropdownMenuItem(
                        value: depot,
                        child: Text(depot),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedDepot = value!;
                });
              },
              decoration: InputDecoration(labelText: "Depósito"),
            ),
            TextField(
              controller: productController,
              decoration: InputDecoration(labelText: "Produto"),
            ),
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Quantidade"),
            ),
            DropdownButtonFormField<String>(
              value: selectedMovementType,
              items: ['Entrada', 'Saída', 'Ajuste de estoque']
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedMovementType = value!;
                });
              },
              decoration: InputDecoration(labelText: "Tipo de movimentação"),
            ),
            TextField(
              controller: observationController,
              decoration: InputDecoration(labelText: "Observação"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                stockMovements.add({
                  'depot': selectedDepot,
                  'product': productController.text,
                  'quantity': int.tryParse(quantityController.text) ?? 0,
                  'type': selectedMovementType,
                  'observation': observationController.text,
                });
              });
              Navigator.pop(context);
            },
            child: Text("Confirmar"),
          ),
        ],
      ),
    );
  }

  Widget _buildStockMovementItem(Map<String, dynamic> movement) {
    return ListTile(
      title: Text("${movement['product']} - ${movement['quantity']}"),
      subtitle: Text(
          "Depósito: ${movement['depot']}, Tipo: ${movement['type']}, Observação: ${movement['observation']}"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Movimentações de Estoque"),
        backgroundColor: Colors.grey[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: codeController,
                    decoration: InputDecoration(
                      hintText: "Código",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: stockController,
                    decoration: InputDecoration(
                      hintText: "Estoque",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _showAddStockPopup,
                  child: Text("Adicionar"),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: stockMovements.length,
                itemBuilder: (context, index) =>
                    _buildStockMovementItem(stockMovements[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
