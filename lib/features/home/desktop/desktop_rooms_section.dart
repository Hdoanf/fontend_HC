import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:thuctap/core/constants/app_colors.dart';
import '../mobile/room_card.dart';

class DesktopRoomsSection extends StatefulWidget {
  const DesktopRoomsSection({super.key});

  @override
  State<DesktopRoomsSection> createState() => _DesktopRoomsSectionState();
}

class _DesktopRoomsSectionState extends State<DesktopRoomsSection> {
  final List<Map<String, dynamic>> _rooms = [
    {
      'roomName': 'Bed Room',
      'roomDetails': 'Five rooms',
      'backgroundColor': const Color(0xFFFFEEF2),
      'image': 'assets/images/double-bed.png',
    },
    {
      'roomName': 'Living Room',
      'roomDetails': 'Two rooms',
      'backgroundColor': const Color(0xFFE0F7FA),
      'image': 'assets/images/sofa.png',
    },
    {
      'roomName': 'Study Room',
      'roomDetails': 'One room',
      'backgroundColor': const Color(0xFFFFF9C4),
      'image': 'assets/images/chair.png',
    },
    {
      'roomName': 'Guest Room',
      'roomDetails': 'Two rooms',
      'backgroundColor': const Color(0xFFF3E8FF),
      'image': 'assets/images/bed.png',
    },
  ];

  void _addNewRoom(String roomName) {
    setState(() {
      _rooms.add({
        'roomName': roomName,
        'roomDetails': '1 devices',
        'backgroundColor': AppColors.roomCardGuest,
        'image': 'assets/images/bed.png',
      });
    });
  }

  void _showAddRoomDialog() {
    final TextEditingController roomNameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Room'),
          content: TextField(
            controller: roomNameController,
            decoration: const InputDecoration(hintText: "Enter room name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (roomNameController.text.isNotEmpty) {
                  _addNewRoom(roomNameController.text);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Title + Add New
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'My rooms',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ElevatedButton.icon(
              onPressed: _showAddRoomDialog,
              icon: const Icon(Icons.add),
              label: const Text('Add New'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        /// Grid rooms
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.3,
          ),
          itemCount: _rooms.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final room = _rooms[index];
            return RoomCard(
              roomName: room['roomName'],
              roomDetails: room['roomDetails'],
              backgroundColor: room['backgroundColor'],
              image: room['image'],
              onTap: () => GoRouter.of(context).go('/devices'),
            );
          },
        ),
      ],
    );
  }
}
