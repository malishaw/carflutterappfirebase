import 'package:flutter/material.dart';
import 'favorite_page.dart';
import 'product.dart';

class ShopPage extends StatefulWidget {
  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  List<Product> products = [
    Product(name: 'Timing Chain', price: 11000, imageName: 'assets/product1.jpg'),
    Product(name: 'Headlight', price: 20000, imageName: 'assets/product2.jpg'),
    Product(name: 'Brakes', price: 15000, imageName: 'assets/product3.jpg'),
    Product(name: 'Car Bumper', price: 17500, imageName: 'assets/product4.jpg'),
    Product(name: 'Windscreen', price: 68900, imageName: 'assets/product5.jpg'),
    Product(name: 'Clutch', price: 15000, imageName: 'assets/product6.jpg'),
  ];

  List<Product> secondPageProducts = [
    Product(name: 'Air Filters', price: 6000, imageName: 'assets/product7.jpg'),
    Product(name: 'Car Muffler', price: 25000, imageName: 'assets/product8.jpg'),
    Product(name: 'ECU', price: 35000, imageName: 'assets/product9.jpg'),
    Product(name: 'Car Battery', price: 20000, imageName: 'assets/product10.jpg'),
    Product(name: 'Side Mirrors', price: 20000, imageName: 'assets/product11.jpg'),
  ];

  List<Product> favorites = [];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Navigate between shop page and favorites page
      if (index == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FavoritePage(favorites: favorites)),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spare parts shop'),
      ),
      body: _selectedIndex == 0
          ? _buildProductList(products)
          : _buildProductList(secondPageProducts),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.shop),
            label: 'Shop', // Provide a non-nullable string
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites', // Provide a non-nullable string
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _selectedIndex = _selectedIndex == 0 ? 1 : 0;
          });
        },
        child: Icon(Icons.swap_horiz),
      ),
    );
  }

   Widget _buildProductList(List<Product> productList) {
    return GridView.builder(
      itemCount: productList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              // Toggle favorite status
              if (favorites.contains(productList[index])) {
                favorites.remove(productList[index]);
              } else {
                favorites.add(productList[index]);
              }
            });
          },
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      productList[index].imageName,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productList[index].name,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        'LKR ${productList[index].price.toStringAsFixed(2)}', // Updated currency to LKR
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: Icon(
                      favorites.contains(productList[index])
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: favorites.contains(productList[index])
                          ? Colors.red
                          : null,
                    ),
                    onPressed: () {
                      setState(() {
                        // Toggle favorite status
                        if (favorites.contains(productList[index])) {
                          favorites.remove(productList[index]);
                        } else {
                          favorites.add(productList[index]);
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
  