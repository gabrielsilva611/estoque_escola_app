import 'package:flutter/material.dart';

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController groupNameController = TextEditingController();
  final TextEditingController productNameController = TextEditingController();

  String? selectedUnit;
  String? selectedGroup;

  final List<String> units = ['Unidade', 'Kg', 'Litros'];
  final List<String> groups = ['Grupo A', 'Grupo B'];

  final List<Map<String, dynamic>> productList = [
    {'name': 'Produto A', 'quantity': 10, 'unit': 'kg'},
    {'name': 'Produto B', 'quantity': 5, 'unit': 'litros'},
    {'name': 'Produto C', 'quantity': 8, 'unit': 'unidades'},
  ];

  late List<Map<String, dynamic>> filteredProducts;

  @override
  void initState() {
    super.initState();
    filteredProducts = productList;
    selectedUnit = units.first;
    selectedGroup = groups.isNotEmpty ? groups.first : null;
  }

  void _filterProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredProducts = productList;
      } else {
        filteredProducts = productList
            .where((product) =>
                product['name'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _showGroupDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Criar Grupo"),
        content: TextField(
          controller: groupNameController,
          decoration: InputDecoration(
            hintText: "Nome do grupo",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                groups.add(groupNameController.text);
              });
              groupNameController.clear();
              Navigator.pop(context);
            },
            child: Text("Confirmar"),
          ),
        ],
      ),
    );
  }

  void _showProductDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Novo Produto"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: productNameController,
              decoration: InputDecoration(
                hintText: "Nome do produto",
              ),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedUnit,
              items: units
                  .map((unit) => DropdownMenuItem(
                        value: unit,
                        child: Text(unit),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedUnit = value!;
                });
              },
              decoration: InputDecoration(
                labelText: "Unidade de medida",
              ),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedGroup,
              items: groups
                  .map((group) => DropdownMenuItem(
                        value: group,
                        child: Text(group),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedGroup = value!;
                });
              },
              decoration: InputDecoration(
                labelText: "Grupo",
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                productList.add({
                  'name': productNameController.text,
                  'quantity': 1,
                  'unit': selectedUnit,
                });
                filteredProducts = List.from(productList);
              });

              productNameController.clear();
              selectedUnit = units.first;
              selectedGroup = groups.isNotEmpty ? groups.first : null;

              Navigator.pop(context);
            },
            child: Text("Confirmar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.blue[200],
        title: Text("Produtos"),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Botões "Grupo" e "Novo Produto"
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton.icon(
                  onPressed: _showGroupDialog,
                  icon: Icon(Icons.bookmark),
                  label: Text("Grupo"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Cor de fundo azul
                    foregroundColor: Colors.white, // Texto branco
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: _showProductDialog,
                  icon: Icon(Icons.add),
                  label: Text("Novo Produto"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Cor de fundo verde
                    foregroundColor: Colors.white, // Texto branco
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Barra de Pesquisa
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Pesquisar produtos",
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: _filterProducts,
            ),
            SizedBox(height: 20),

            // Lista de produtos com o filtro aplicado
            Expanded(
              child: ListView.builder(
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  return _buildProductItem(
                    filteredProducts[index]['name'],
                    filteredProducts[index]['quantity'],
                    filteredProducts[index]['unit'],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductItem(String name, int quantity, String unit) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.radio_button_unchecked, color: Colors.grey),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "$name - $quantity $unit",
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
            ),
          ),
        ],
      ),
    );
  }
}