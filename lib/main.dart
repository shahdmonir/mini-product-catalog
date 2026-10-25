/*
Lifecycle Questions:

1. initState():
   Called once when the State object is first created.

2. didChangeDependencies():
   Called after initState and when inherited dependencies change.

3. build():
   Builds the widget UI and may be called multiple times.

4. deactivate():
   Called when the State object is removed from the widget tree.

5. dispose():
   Called when the State object is permanently removed.

Routing Questions:

6. Navigator vs go_router:
   Navigator uses imperative navigation, while go_router
   uses declarative routing with named routes and URL paths.

7. Why use StatefulWidget?
   Because the pages contain changing state, such as the
   favorites counter and cart message.

8. Why use MediaQuery?
   To get screen dimensions and make the UI responsive.
*/

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'product_widgets.dart';

final List<Map<String, dynamic>> products = [
  {'name': 'Laptop', 'price': 1200},
  {'name': 'Phone', 'price': 800},
  {'name': 'Headphones', 'price': 150},
  {'name': 'Keyboard', 'price': 100},
  {'name': 'Mouse', 'price': 50},
  {'name': 'Monitor', 'price': 300},
];

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/products',
      name: 'products',
      builder: (context, state) {
        final username =
            state.uri.queryParameters['user'] ?? 'Guest';

        return ProductsPage(username: username);
      },
    ),
    GoRoute(
      path: '/details/:name/:price',
      name: 'details',
      builder: (context, state) {
        final name = state.pathParameters['name']!;
        final price = int.parse(state.pathParameters['price']!);

        return DetailsPage(
          productName: name,
          price: price,
        );
      },
    ),
  ],
);

void main() {
  runApp(const MiniProductCatalogApp());
}

class MiniProductCatalogApp extends StatelessWidget {
  const MiniProductCatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Mini Product Catalog',
      routerConfig: router,
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    print('LoginPage: initState');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('LoginPage: didChangeDependencies');
  }

  @override
  Widget build(BuildContext context) {
    print('LoginPage: build');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.goNamed(
              'products',
              queryParameters: {'user': 'Guest'},
            );
          },
          child: const Text('Login'),
        ),
      ),
    );
  }

  @override
  void deactivate() {
    print('LoginPage: deactivate');
    super.deactivate();
  }

  @override
  void dispose() {
    print('LoginPage: dispose');
    super.dispose();
  }
}

class ProductsPage extends StatefulWidget {
  final String username;

  const ProductsPage({
    super.key,
    required this.username,
  });

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  int favorites = 0;
  double screenWidth = 0;
  String cartMessage = '';

  @override
  void initState() {
    super.initState();
    print('ProductsPage: initState');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final size = MediaQuery.sizeOf(context);
    screenWidth = size.width;

    print(
      'ProductsPage: didChangeDependencies -> '
      'width: ${size.width}, height: ${size.height}',
    );
  }

  @override
  Widget build(BuildContext context) {
    print('ProductsPage: build');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, ${widget.username}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text('Favorites: $favorites'),
            Text('Screen width: $screenWidth'),
            if (cartMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(cartMessage),
              ),
            const SizedBox(height: 12),
            Expanded(
              child: screenWidth < 600
                  ? ProductsListView(
                      products: products,
                      onFavoritePressed: () {
                        setState(() {
                          favorites++;
                        });
                      },
                      onProductTap: (index) async {
                        final product = products[index];

                        final result =
                            await context.pushNamed<String>(
                          'details',
                          pathParameters: {
                            'name': product['name'].toString(),
                            'price': product['price'].toString(),
                          },
                        );

                        if (!mounted) return;

                        if (result != null) {
                          setState(() {
                            cartMessage = result;
                          });
                        }
                      },
                    )
                  : ProductsGridView(
                      products: products,
                      onFavoritePressed: () {
                        setState(() {
                          favorites++;
                        });
                      },
                      onProductTap: (index) async {
                        final product = products[index];

                        final result =
                            await context.pushNamed<String>(
                          'details',
                          pathParameters: {
                            'name': product['name'].toString(),
                            'price': product['price'].toString(),
                          },
                        );

                        if (!mounted) return;

                        if (result != null) {
                          setState(() {
                            cartMessage = result;
                          });
                        }
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void deactivate() {
    print('ProductsPage: deactivate');
    super.deactivate();
  }

  @override
  void dispose() {
    print('ProductsPage: dispose');
    super.dispose();
  }
}

class DetailsPage extends StatefulWidget {
  final String productName;
  final int price;

  const DetailsPage({
    super.key,
    required this.productName,
    required this.price,
  });

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  void initState() {
    super.initState();
    print('DetailsPage: initState');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('DetailsPage: didChangeDependencies');
  }

  @override
  Widget build(BuildContext context) {
    print('DetailsPage: build');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.productName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Price: \$${widget.price}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.pop(
                  '${widget.productName} added to cart',
                );
              },
              child: const Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void deactivate() {
    print('DetailsPage: deactivate');
    super.deactivate();
  }

  @override
  void dispose() {
    print('DetailsPage: dispose');
    super.dispose();
  }
}
/*
Navigator example (old implementation):

// Navigate to ProductsPage:
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const ProductsPage(username: 'Guest'),
  ),
);

// Navigate back:
Navigator.pop(context);
*/