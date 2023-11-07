import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:priyobanskhali/utils/open_app.dart';

import '/utils/repo.dart';

class ShopDetails extends StatefulWidget {
  const ShopDetails({
    Key? key,
    required this.title,
    required this.image,
    required this.price,
    required this.stock,
    required this.size,
  }) : super(key: key);

  final String title;
  final String image;
  final int price;
  final int stock;
  final List size;

  @override
  State<ShopDetails> createState() => _ShopDetailsState();
}

class _ShopDetailsState extends State<ShopDetails> {
  String _selectedSize = 'm';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          widget.title,
          style: GoogleFonts.poppins().copyWith(
            color: Colors.black,
          ),
        ),
      ),

      //

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //image
          Container(
            color: Colors.white,
            child: Image.network(
              widget.image,
              height: 250,
            ),
          ),

          //
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //name
                    Text(
                      widget.title,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),

                    const SizedBox(width: 8),

                    //
                    Text(
                      '${AppRepo.kTkSymbol} ${widget.price}',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                          ),
                    ),
                  ],
                ),

                //
                Text(
                  'Stock: ${widget.stock}',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: Colors.grey,
                      ),
                ),

                const SizedBox(height: 16),

                Text(
                  'Size',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),

                const SizedBox(height: 8),

                //
                Row(
                  children: widget.size
                      .map(
                        (size) => GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedSize = size;
                            });
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            margin: const EdgeInsets.only(right: 10),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: _selectedSize == size ? Colors.red : null,
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                color: _selectedSize == size
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                            ),
                            child: Text(
                              size.toString().toUpperCase(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _selectedSize == size
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),

                const SizedBox(height: 32),

                //
                ElevatedButton(
                    onPressed: () {
                      //
                      OpenApp.withUrl(AppRepo.kWhatsAppLink);
                    },
                    child: const Text('Buy now'))
              ],
            ),
          )
        ],
      ),
    );
  }
}
