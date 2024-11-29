import 'package:flutter/material.dart';

class StockScreen extends StatefulWidget {
  @override
  _StockScreenState createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  final TextEditingController codeController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> stockMovements = [
    {
      'code': '001',
      'depot': 'Padrão',
      'product': 'Produto A',
      'quantity': 10,
      'type': 'Entrada',
      'observation': 'Estoque inicial'
    },
    {
      'code': '002',
      'depot': 'Depósito 1',
      'product': 'Produto B',
      'quantity': 5,
      'type': 'Entrada',
      'observation': 'Novo lote'
    },
  ];

  List<Map<String, dynamic>> filteredStockMovements = [];

  @override
  void initState() {
    super.initState();
    filteredStockMovements = stockMovements;
  }

  void _filterStockMovements(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredStockMovements = stockMovements;
      } else {
        filteredStockMovements = stockMovements.where((movement) {
          final product = movement['product'].toLowerCase();
          final code = movement['code'].toLowerCase();
          final lowerQuery = query.toLowerCase();
          return product.contains(lowerQuery) || code.contains(lowerQuery);
        }).toList();
      }
    });
  }

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
                  'code': (stockMovements.length + 1).toString().padLeft(3, '0'),
                  'depot': selectedDepot,
                  'product': productController.text,
                  'quantity': int.tryParse(quantityController.text) ?? 0,
                  'type': selectedMovementType,
                  'observation': observationController.text,
                });
                filteredStockMovements = List.from(stockMovements);
              });
              Navigator.pop(context);
            },
            child: Text("Confirmar"),
          ),
        ],
      ),
    );
  }

  void _showEditDepotPopup(int index) {
    String selectedDepot = filteredStockMovements[index]['depot'];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Alterar Local de Estoque"),
        content: DropdownButtonFormField<String>(
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
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                filteredStockMovements[index]['depot'] = selectedDepot;
                int originalIndex = stockMovements.indexWhere((movement) =>
                    movement['code'] == filteredStockMovements[index]['code']);
                if (originalIndex != -1) {
                  stockMovements[originalIndex]['depot'] = selectedDepot;
                }
              });
              Navigator.pop(context);
            },
            child: Text("Salvar"),
          ),
        ],
      ),
    );
  }

  Widget _buildStockMovementItem(Map<String, dynamic> movement, int index) {
    return ListTile(
      title: Text("${movement['product']} - ${movement['quantity']}"),
      subtitle: Text(
          "Código: ${movement['code']}, Depósito: ${movement['depot']}, Tipo: ${movement['type']}"),
      trailing: IconButton(
        icon: Icon(Icons.edit_location),
        onPressed: () => _showEditDepotPopup(index),
      ),
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
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: "Pesquisar por Código ou Nome",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: _filterStockMovements,
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
                itemCount: filteredStockMovements.length,
                itemBuilder: (context, index) =>
                    _buildStockMovementItem(filteredStockMovements[index], index),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
