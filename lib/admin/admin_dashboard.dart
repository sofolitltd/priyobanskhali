import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:priyobanskhali/admin/admins/admin_list.dart';
import 'package:priyobanskhali/admin/users/users_admin.dart';

import 'banner/all_banner_admin.dart';
import 'book/all_book_admin.dart';
import 'orders/orders.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // centerTitle: false,
        backgroundColor: Colors.white,
        title: const Text(
          'Admin dashboard',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // orders
          Card(
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              leading: const Icon(
                Icons.perm_contact_cal,
                size: 48,
              ),
              title: Text('Orders', style: GoogleFonts.hindSiliguri()),
              subtitle: Text('Add, edit, delete - Orders',
                  style: GoogleFonts.hindSiliguri()),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Orders()));
              },
            ),
          ),

          const SizedBox(height: 8),

          // books
          Card(
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              leading: const Icon(
                Icons.menu_book_outlined,
                size: 48,
              ),
              title: Text('Books', style: GoogleFonts.hindSiliguri()),
              subtitle: Text('Add, edit, delete - Books',
                  style: GoogleFonts.hindSiliguri()),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AllBookAdmin()));
              },
            ),
          ),

          const SizedBox(height: 8),

          // banner
          Card(
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              leading: const Icon(
                Icons.image_outlined,
                size: 48,
              ),
              title: Text('Banners', style: GoogleFonts.hindSiliguri()),
              subtitle: Text('Add, edit, delete - Banners',
                  style: GoogleFonts.hindSiliguri()),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AllBannerAdmin()));
              },
            ),
          ),

          const SizedBox(height: 8),

          // users
          Card(
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              leading: const Icon(
                Icons.people_alt_outlined,
                size: 48,
              ),
              title: Text('Users', style: GoogleFonts.hindSiliguri()),
              subtitle: Text('Add, edit, delete - Users',
                  style: GoogleFonts.hindSiliguri()),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UsersAdmin()));
              },
            ),
          ),

          const SizedBox(height: 8),

          // admin
          Card(
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              leading: const Icon(
                Icons.perm_contact_cal,
                size: 48,
              ),
              title: Text('Admin', style: GoogleFonts.hindSiliguri()),
              subtitle: Text('Add, edit, delete - Admin',
                  style: GoogleFonts.hindSiliguri()),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const AdminList()));
              },
            ),
          ),
        ],
      ),
    );
  }
}
