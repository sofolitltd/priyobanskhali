import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../book/see_more_book.dart';
import '../ebook/see_more_ebook.dart';

const List<String> list = <String>['Book', 'Ebook'];

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchField = '';
  String dropdownValue = list.first;
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: false,
        title: const Text(
          'Search',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: DropdownMenu<String>(
                width: 120,
                initialSelection: list.first,
                inputDecorationTheme: const InputDecorationTheme(
                  contentPadding: EdgeInsets.only(left: 12),
                  isDense: true,
                  border: OutlineInputBorder(gapPadding: 0),
                  constraints: BoxConstraints(maxHeight: 40),
                ),
                onSelected: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    dropdownValue = value!;
                  });
                },
                dropdownMenuEntries:
                    list.map<DropdownMenuEntry<String>>((String value) {
                  return DropdownMenuEntry<String>(value: value, label: value);
                }).toList(),
              ),
            ),
          ),
        ],
      ),

      //
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          //
          TextField(
            controller: _controller,
            onChanged: (value) {
              searchField = value;
              setState(() {});
            },
            style: GoogleFonts.hindSiliguri(),
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.black),
              ),
              hintText: 'Search here...',
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        searchField = '';
                        _controller.clear();
                        setState(() {});
                      },
                      icon: const Icon(
                        Icons.clear,
                        size: 20,
                        color: Colors.black,
                      ),
                    )
                  : null,
            ),
          ),

          const SizedBox(height: 8),

          //
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection(dropdownValue.toLowerCase())
                .orderBy("title")
                .startAt([searchField]).endAt(
                    ["$searchField\uf8ff"]).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const SizedBox();
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox();
              }

              var data = snapshot.data!.docs;
              if (data.isEmpty) {
                return const Center(
                    child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('No item!'),
                ));
              }
              //

              return ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemCount: data.length,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  itemBuilder: (context, index) {
                    //
                    if (dropdownValue.toLowerCase() == 'book') {
                      return BookCardFull(data: data[index]);
                    } else {
                      return EbookCardFull(data: data[index]);
                    }
                  });
            },
          ),
        ],
      ),
    );
  }
}
