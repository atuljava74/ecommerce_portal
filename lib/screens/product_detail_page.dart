import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_portal/utils/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../blocs/cart/cart_bloc.dart';
import '../blocs/cart/cart_event.dart';
import '../models/product_model.dart';
import '../widgets/custom_app_bar.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  ProductDetailPage({required this.product});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final PageController _pageController = PageController();
  final TextEditingController _promoCodeController = TextEditingController();
  double _promoDiscount = 0;
  String _promoMessage = '';
  bool _isAddedToCart = false; // Track if the item is added to the cart
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final double originalPrice = widget.product.price;
    final double discount = originalPrice * 0.3; // Example 30% discount
    final double discountedPrice = originalPrice - discount;
    final double finalPrice = discountedPrice - _promoDiscount;

    return Scaffold(
      appBar: CustomAppBar(title: widget.product.name),
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              _focusNode.unfocus();
            },
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 80.0), // Leave space for the button
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Carousel
                  Container(
                    height: 300,
                    child: PageView.builder(
                      allowImplicitScrolling: true,
                      controller: _pageController,
                      itemCount: widget.product.imageUrls.length, // Assuming imageUrls is a list of image URLs
                      itemBuilder: (context, index) {
                        return CachedNetworkImage(
                            imageUrl: widget.product.imageUrls[index],
                            fit: BoxFit.fitHeight,
                            progressIndicatorBuilder: (context, url, downloadProgress) =>
                                Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                            errorWidget: (context, url, error) => const Icon(Icons.broken_image,size: 50,
                              color: Colors.grey,),
                          );
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: SmoothPageIndicator(
                      controller: _pageController,
                      count: widget.product.imageUrls.length,
                      effect: WormEffect(
                        dotHeight: 8,
                        dotWidth: 8,
                        activeDotColor: Colors.blueAccent,
                        dotColor: Colors.grey,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(widget.product.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        getRating(3.8),
                        Text(' 3.8 out of 5 stars (156 ratings)', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('100+ bought in the past month', style: TextStyle(fontSize: 16, color: Colors.grey)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Text(
                          '₹${originalPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          '₹${discountedPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text('(52% off)', style: TextStyle(fontSize: 16, color: Colors.red)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('FREE delivery Mon, 26 Aug. Or fastest delivery Sun, 25 Aug.', style: TextStyle(fontSize: 16)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Only 1 left in stock.', style: TextStyle(fontSize: 16, color: Colors.red)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text('Service: ', style: TextStyle(fontSize: 16)),
                        Text('Installation', style: TextStyle(fontSize: 16, color: Colors.blue)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(widget.product.description),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Available Promo Code: SAVE5', style: TextStyle(fontSize: 16, color: Colors.blue)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _promoCodeController,
                            focusNode: _focusNode,
                            decoration: InputDecoration(
                              labelText: 'Enter Promo Code',
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                              fontSize: 12, // Adjust the font size as needed
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            if (_promoCodeController.text == 'SAVE5') {
                              setState(() {
                                _promoDiscount = discountedPrice * 0.05; // 5% discount
                                _promoMessage = 'Promo code applied! ₹${_promoDiscount.toStringAsFixed(2)} discount';
                              });
                            } else {
                              setState(() {
                                _promoMessage = 'Invalid promo code';
                                _promoDiscount = 0;
                              });
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(_promoMessage)),
                            );
                          },
                          child: Text('Apply'),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Divider(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Price Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Original Price'),
                        Text('₹${originalPrice.toStringAsFixed(2)}'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Discount'),
                        Text('-₹${discount.toStringAsFixed(2)}'),
                      ],
                    ),
                  ),
                  if (_promoDiscount > 0)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Promo Discount'),
                          Text('-₹${_promoDiscount.toStringAsFixed(2)}'),
                        ],
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: Divider(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total'),
                        Text('₹${finalPrice.toStringAsFixed(2)}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Sticky Add to Cart Button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: AppConfig.themeColor,
              height: 60,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: _isAddedToCart
                    ? null // Disable the button if item is already added to cart
                    : () {
                  context.read<CartBloc>().add(AddToCart(widget.product.id, 1));
                  setState(() {
                    _isAddedToCart = true; // Disable the button after adding to cart
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Added to cart!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: _isAddedToCart ? Colors.grey : AppConfig.themeColor,
                  minimumSize: Size(double.infinity, 50), // Full-width button
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _isAddedToCart ? 'Item in Cart' : 'Add to Cart', // Update text if item is added
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      _isAddedToCart ? Icons.check : Icons.shopping_cart_outlined,
                      color: Colors.white,
                      size: 24,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  getRating(double rating) {
    return RatingBarIndicator(
      rating: rating,
      itemBuilder: (context, index) => Icon(
        Icons.star,
        color: Colors.amber,
      ),
      itemCount: 5,
      itemSize: 24.0, // Size of the stars
      direction: Axis.horizontal,
    );
  }
}
