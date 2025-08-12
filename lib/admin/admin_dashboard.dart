import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '/admin/admins/admin_list.dart';
import '/admin/blog/blog_screen.dart';
import '/admin/emergency/emergency_admin.dart';
import '/admin/shop/shop_admin.dart';
import '/admin/users/users_admin.dart';
import 'banner/all_banner_admin.dart';
import 'book/all_book_admin.dart';
import 'ebook/all_ebook_admin.dart';
import 'notification/notification_admin.dart';
import 'orders/orders.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final gridItems = [
      AdminMenuItem(Icons.receipt_long, 'Orders', 'Manage orders',
          () => Get.to(const Orders())),
      AdminMenuItem(Icons.people_alt_outlined, 'Users', 'Manage users',
          () => Get.to(const UsersAdmin())),
      AdminMenuItem(Icons.notifications_active, 'Notifications', 'Push updates',
          () => Get.to(const NotificationAdmin())),
      AdminMenuItem(Icons.article_outlined, 'Blogs', 'Manage blogs',
          () => Get.to(const BlogScreen())),
    ];

    final listItems = [
      AdminMenuItem(Icons.menu_book_outlined, 'Books', 'Manage books',
          () => Get.to(const AllBookAdmin())),
      AdminMenuItem(Icons.book_online, 'Ebooks', 'Manage ebooks',
          () => Get.to(const AllEbookAdmin())),
      AdminMenuItem(Icons.shopping_bag_outlined, 'Shop', 'Manage products',
          () => Get.to(const ShopAdmin())),
      AdminMenuItem(Icons.contact_mail_outlined, 'Emergency', 'Manage contacts',
          () => Get.to(const EmergencyAdmin())),
      AdminMenuItem(Icons.image_outlined, 'Banners', 'Manage banners',
          () => Get.to(const AllBannerAdmin())),
      AdminMenuItem(Icons.admin_panel_settings, 'Admins', 'Manage admins',
          () => Get.to(const AdminList())),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard',
            style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: gridItems.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
            ),
            itemBuilder: (_, i) => DashboardGridItem(item: gridItems[i]),
          ),
          const SizedBox(height: 24),
          const Text('More Options',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...listItems.map((item) => DashboardListItem(item: item)),
        ],
      ),
    );
  }
}

//model
class AdminMenuItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  AdminMenuItem(this.icon, this.title, this.subtitle, this.onTap);
}

//color
Color getColor(item) {
  switch (item.title) {
    case 'Orders':
      return Colors.deepOrangeAccent;
    case 'Users':
      return Colors.teal;
    case 'Blogs':
      return Colors.purple;
    case 'Notifications':
      return Colors.indigo;
    case 'Books':
      return Colors.teal;
    case 'Ebooks':
      return Colors.green;
    case 'Banners':
      return Colors.redAccent;
    case 'Shop':
      return Colors.amber;
    case 'Emergency':
      return Colors.cyan;
    case 'Admin':
      return Colors.pinkAccent;
    default:
      return Colors.blueAccent;
  }
}

// grid
class DashboardGridItem extends StatelessWidget {
  final AdminMenuItem item;

  const DashboardGridItem({super.key, required this.item});

  Stream<int> getCountStream() {
    final firestore = FirebaseFirestore.instance;

    switch (item.title) {
      case 'Orders':
        return firestore
            .collection('orders')
            .where('status', isEqualTo: 'Pending')
            .snapshots()
            .map((snapshot) => snapshot.docs.length);

      case 'Users':
        return firestore
            .collection('users')
            .snapshots()
            .map((snapshot) => snapshot.docs.length);

      case 'Blogs':
        return firestore
            .collection('blog')
            .snapshots()
            .map((snapshot) => snapshot.docs.length);

      case 'Notifications':
        return firestore
            .collection('notifications')
            .snapshots()
            .map((snapshot) => snapshot.docs.length);

      default:
        return Stream<int>.value(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: item.onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: getColor(item),
                    child: Icon(item.icon, size: 26, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  StreamBuilder<int>(
                    stream: getCountStream(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        );
                      }

                      final count = snapshot.data ?? 0;
                      return Text(
                        '$count',
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 30,
                          height: 1,
                          fontWeight: FontWeight.bold,
                          color: getColor(item),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(item.title,
                  style: GoogleFonts.hindSiliguri(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              Text(item.subtitle,
                  style: GoogleFonts.hindSiliguri(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

// list
class DashboardListItem extends StatelessWidget {
  final AdminMenuItem item;

  const DashboardListItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        leading: CircleAvatar(
            backgroundColor: getColor(item),
            child: Icon(
              item.icon,
              size: 24,
              color: Colors.white,
            )),
        title: Text(
          item.title,
          style: GoogleFonts.hindSiliguri().copyWith(),
        ),
        subtitle: Text(item.subtitle, style: GoogleFonts.hindSiliguri()),
        onTap: item.onTap,
      ),
    );
  }
}
