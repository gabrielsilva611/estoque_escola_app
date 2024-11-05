import 'package:flutter/material.dart';
import './icon_card.dart';
import 'product_screen.dart';
import 'stock_screen.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[700],
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.grey[700],
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProductScreen()),
                    );
                  },
                  child: IconCard(icon: Icons.card_giftcard, label: "Produtos"),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => StockScreen()),
                    );
                  },
                  child: IconCard(icon: Icons.inventory, label: "Estoques"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
