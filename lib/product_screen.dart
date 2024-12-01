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
  final TextEditingController locationController = TextEditingController();

  String? selectedUnit;
  final List<String> units = ['Unidade', 'Kg', 'Litros'];

  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> filteredProducts = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
    selectedUnit = units.first;
  }

  Future<void> fetchProducts() async {
    try {
      final response = await supabase.from('produto').select();
      if (response != null) {
        setState(() {
          products = response;
          filteredProducts = products;
        });
      } else {
        _showError('Erro ao buscar produtos');
      }
    } catch (e) {
      _showError(e.toString());
    }
  }

  Future<void> addProduct(String name, int quantity, String unit, String location) async {
    try {
      final response = await supabase.from('produto').insert({
        'name': name,
        'quantity': quantity,
        'unit': unit,
        'location': location,
      });

      if (response != null) {
        fetchProducts();
      } else {
        _showError('Erro ao adicionar o produto');
      }
    } catch (e) {
      _showError(e.toString());
    }
  }

  Future<void> updateProduct(int id, int quantity, String location) async {
    try {
      final response = await supabase.from('produto').update({
        'quantity': quantity,
        'location': location,
      }).eq('id', id);

      if (response != null) {
        fetchProducts();
      } else {
        _showError('Erro ao atualizar o produto');
      }
    } catch (e) {
      _showError(e.toString());
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      final response = await supabase.from('produto').delete().eq('id', id);

      if (response != null) {
        fetchProducts();
      } else {
        _showError('Erro ao deletar o produto');
      }
    } catch (e) {
      _showError(e.toString());
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

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Erro: $message")),
    );
  }

  void _showProductDialog() {
    productNameController.clear();
    quantityController.clear();
    locationController.clear();
    selectedUnit = units.first;

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
            TextField(
              controller: locationController,
              decoration: InputDecoration(hintText: "Local de Armazenamento"),
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
                locationController.text,
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
    locationController.text = product['location'];

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
            TextField(
              controller: locationController,
              decoration: InputDecoration(hintText: "Local de Armazenamento"),
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
                locationController.text,
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
