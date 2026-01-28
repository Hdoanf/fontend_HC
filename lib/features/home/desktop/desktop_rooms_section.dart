import 'package:flutter/material.dart';
import '../mobile/room_card.dart';

class DesktopRoomsSection extends StatelessWidget {
  const DesktopRoomsSection({super.key});

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
              onPressed: () {},
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
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.3,
          children: const [
            RoomCard(
              roomName: 'Bed Room',
              roomDetails: 'Five rooms',
              backgroundColor: Color(0xFFFFEEF2),
              image: 'assets/images/double-bed.png',
            ),
            RoomCard(
              roomName: 'Living Room',
              roomDetails: 'Two rooms',
              backgroundColor: Color(0xFFE0F7FA),
              image: 'assets/images/sofa.png',
            ),
            RoomCard(
              roomName: 'Study Room',
              roomDetails: 'One room',
              backgroundColor: Color(0xFFFFF9C4),
              image: 'assets/images/chair.png',
            ),
            RoomCard(
              roomName: 'Guest Room',
              roomDetails: 'Two rooms',
              backgroundColor: Color(0xFFF3E8FF),
              image: 'assets/images/bed.png',
            ),
          ],
        ),
      ],
    );
  }
}
