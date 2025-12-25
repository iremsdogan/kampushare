import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget{
  const NotificationsPage({super.key});

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>{
  List<Map<String, String>> notifications = [
    {
      'title': 'Yeni ürün indirimi!',
      'subtitle': 'Elektronik kategorisinde %20 indirim başladı.'
    },
    {
      'title': 'Siparişin onaylandı',
      'subtitle': 'Ürün bugün kargoya verilecek.'
    },
    {
      'title': 'Favori ürün indirime girdi!',
      'subtitle': 'Takip ettiğin kitap %15 indirimde.'
    },
  ];
  bool _isLoading = false;

  Future<void> _refreshNotifications() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      notifications.insert(0, {
        'title': 'Yeni duyuru!',
        'subtitle': 'KampüShare uygulaması güncellendi 🎉'
      });
      _isLoading = false;
    });
  }

  void _clearAll() {
    setState(() {
      notifications.clear();
    });
  }

  @override
  Widget build (BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bildirimler', style: TextStyle(color: Colors.black)),
        backgroundColor: Color(0xFFFFFFFF),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
        actions: [
          if (notifications.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Tümünü Sil',
              onPressed: _clearAll,
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshNotifications,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : notifications.isEmpty
                ? const Center(child: Text('Hiç bildirimin yok', style: TextStyle(fontSize: 16, color: Colors.grey),),
                )
                : Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F5F5),
                  ),
                  child: ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      return _buildNotificationCard(notifications[index]);
                    },
                  ),
                ),
        
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, String> item) {
    return Card(
      color: Color(0xFFFFFFFF),
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Icon(Icons.notifications_active, color: Colors.red[400],),
        title: Text(item['title']!, style: const TextStyle(fontWeight: FontWeight.bold),),
        subtitle: Text(item['subtitle']!),
        onTap: () {}
      ),
    );
  }
}