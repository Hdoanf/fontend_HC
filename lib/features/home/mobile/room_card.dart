import 'package:flutter/material.dart';

class RoomCard extends StatelessWidget {
  final String roomName;
  final String roomDetails;
  final Color backgroundColor;
  final String image; // URL ảnh mạng

  const RoomCard({
    super.key,
    required this.roomName,
    required this.roomDetails,
    required this.backgroundColor,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 160),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          /// 🔵 Vòng tròn trang trí phía sau ảnh
          Positioned(
            top: -20,
            right: -10,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.25),
              ),
            ),
          ),

          /// 🖼 Ảnh phòng (ảnh mạng – có loading + error)
          Positioned(
            top: 12,
            right: 8,
            child: Image.network(
              image,
              width: 110,
              height: 110,
              fit: BoxFit.contain,

              /// Loading
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const SizedBox(
                  width: 110,
                  height: 110,
                  child: Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              },

              /// Error
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox(
                  width: 110,
                  height: 110,
                  child: Icon(
                    Icons.image_not_supported,
                    size: 40,
                    color: Colors.grey,
                  ),
                );
              },
            ),
          ),

          /// 📝 Nội dung chữ
          Positioned(
            left: 20,
            bottom: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  roomName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  roomDetails,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black.withOpacity(0.55),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
