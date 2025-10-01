import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget{
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], 
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(
                "https://randomuser.me/api/portraits/men/44.jpg"),
              ),
            SizedBox(width: 10,),
            Text("Merdo", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {}, 
            icon: const Icon(Icons.more_vert, color: Colors.black87),
          )
        ],
      ),
      body: Column(
        children: [
          //mesaj listesi
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildReceiverMessage("Hey, how Are you?"),
                const SizedBox(height: 8,),
                _buildSenderMessage("I'm good, thanks! What about you?"),
                const SizedBox(height: 8),
                _buildReceiverMessage("Also good, working on a project 😊"),
              ],
            ),
          ),
          // alt kısım - mesaj yazma
          _buildMessageInput(),
        ],
      )
    );
  }
  // Karşı taraf mesaj balonu
  Widget _buildReceiverMessage(String text){
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 250),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)
          ],
        ),
        child: Text(text, style: const TextStyle(color: Colors.black87),),
      ),
    );
  }
  // Senin mesaj balonu
  Widget _buildSenderMessage(String text){
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 250),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(text, style: const TextStyle(color: Colors.white),),
      ),
    );
  }
  // Alt kısımdaki input bar
  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black87.withOpacity(0.05), blurRadius: 6),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(30),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Type a message...",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8,),
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xFF4facfe),
            child: const Icon(Icons.send, color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}