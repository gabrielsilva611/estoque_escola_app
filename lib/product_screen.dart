import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final supabase = Supabase.instance.client;

  final TextEditingController searchController = TextEditingController();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  String? selectedUnit;
  final List<String> units = ['Unidade', 'Kg', 'Litros'];

  String? selectedStock;
  final List<String> stocks = ['Estoque escolar', 'Estoque comida, limpeza'];

  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> filteredProducts = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
    selectedUnit = units.first;
    selectedStock = stocks.first;
  }

  Future<void> fetchProducts() async {
    try {
      final response = await supabase.from('produto').select();
      setState(() {
        products = response;
        filteredProducts = products;
      });
    } catch (e) {
      // Log error or handle it silently
    }
  }

  Future<void> addProduct(String name, int quantity, String unit, String stock) async {
    try {
      final response = await supabase.from('produto').insert({
        'name': name,
        'quantity': quantity,
        'unit': unit,
        'location': stock,
      });

      if (response != null) {
        fetchProducts();
      }
    } catch (e) {
      // Log error or handle it silently
    }
  }

  Future<void> updateProduct(int id, int quantity, String stock) async {
    try {
      final response = await supabase.from('produto').update({
        'quantity': quantity,
        'location': stock,
      }).eq('id', id);

      if (response != null) {
        fetchProducts();
      }
    } catch (e) {
      // Log error or handle it silently
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      final response = await supabase.from('produto').delete().eq('id', id);

      if (response != null) {
        fetchProducts();
      }
    } catch (e) {
      // Log error or handle it silently
    }
  }

  void _filterProducts(String query) {
    setState(() {
      filteredProducts = query.isEmpty
          ? products
          : products
              .where((product) =>
                  product['name'].toLowerCase().contains(query.toLowerCase()))
              .toList();
    });
  }

  void _showProductDialog() {
    productNameController.clear();
    quantityController.clear();
    selectedUnit = units.first;
    selectedStock = stocks.first;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Novo Produto"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: productNameController,
              decoration: InputDecoration(hintText: "Nome do Produto"),
            ),
            TextField(
              controller: quantityController,
              decoration: InputDecoration(hintText: "Quantidade"),
              keyboardType: TextInputType.number,
            ),
            DropdownButtonFormField<String>(
              value: selectedStock,
              items: stocks
                  .map((stock) =>
                      DropdownMenuItem(value: stock, child: Text(stock)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedStock = value!;
                });
              },
              decoration: InputDecoration(labelText: "Estoque"),
            ),
            DropdownButtonFormField<String>(
              value: selectedUnit,
              items: units
                  .map((unit) =>
                      DropdownMenuItem(value: unit, child: Text(unit)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedUnit = value!;
                });
              },
              decoration: InputDecoration(labelText: "Unidade de Medida"),
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
              addProduct(
                productNameController.text,
                int.tryParse(quantityController.text) ?? 1,
                selectedUnit!,
                selectedStock!,
              );
              Navigator.pop(context);
            },
            child: Text("Salvar"),
          ),
        ],
      ),
    );
  }

  void _showEditProductDialog(Map<String, dynamic> product) {
    quantityController.text = product['quantity'].toString();
    selectedStock = product['location'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Editar Produto"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: "Quantidade"),
            ),
            DropdownButtonFormField<String>(
              value: selectedStock,
              items: stocks
                  .map((stock) =>
                      DropdownMenuItem(value: stock, child: Text(stock)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedStock = value!;
                });
              },
              decoration: InputDecoration(labelText: "Estoque"),
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
              updateProduct(
                product['id'],
                int.tryParse(quantityController.text) ?? product['quantity'],
                selectedStock!,
              );
              Navigator.pop(context);
            },
            child: Text("Salvar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Produtos")),
      body: Column(
        children: [
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: "Pesquisar...",
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: _filterProducts,
          ),
          ElevatedButton(
            onPressed: _showProductDialog,
            child: Text("Novo Produto"),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return ListTile(
                  title: Text("${product['name']}"),
                  subtitle: Text(
                      "${product['quantity']} ${product['unit']} - ${product['location']}"),
                  onTap: () => _showEditProductDialog(product),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => deleteProduct(product['id']),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
