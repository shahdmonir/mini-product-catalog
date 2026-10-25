// ============================================================
//  HELPER FILE: Product widgets
// ============================================================
//  Ready widgets to show a list of products.
//  Use ProductsListView or ProductsGridView inside your page.
//
//  Each product is a Map like: {"name": "Laptop", "price": 1200}
//
//  Example:
//  ProductsListView(
//    products: products,
//    onFavoritePressed: () {
//      setState(() {
//        favorites++;
//      });
//    },
//    onProductTap: (index) {
//      print(products[index]["name"]);
//    },
//  )

import 'package:flutter/material.dart';

class ProductsListView extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final void Function() onFavoritePressed;
  final void Function(int index) onProductTap;

  ProductsListView({
    required this.products,
    required this.onFavoritePressed,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ProductTile(
          name: products[index]["name"],
          price: products[index]["price"],
          onFavoritePressed: onFavoritePressed,
          onTap: () {
            onProductTap(index);
          },
        );
      },
    );
  }
}

class ProductsGridView extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final void Function() onFavoritePressed;
  final void Function(int index) onProductTap;

  ProductsGridView({
    required this.products,
    required this.onFavoritePressed,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 4,
      ),
      itemBuilder: (context, index) {
        return ProductTile(
          name: products[index]["name"],
          price: products[index]["price"],
          onFavoritePressed: onFavoritePressed,
          onTap: () {
            onProductTap(index);
          },
        );
      },
    );
  }
}

class ProductTile extends StatelessWidget {
  final String name;
  final int price;
  final void Function() onFavoritePressed;
  final void Function() onTap;

  ProductTile({
    required this.name,
    required this.price,
    required this.onFavoritePressed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(name),
        subtitle: Text("\$$price"),
        trailing: IconButton(
          icon: Icon(Icons.favorite),
          color: Colors.red,
          onPressed: onFavoritePressed,
        ),
        onTap: onTap,
      ),
    );
  }
}
