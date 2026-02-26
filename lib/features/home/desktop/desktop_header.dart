import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thuctap/features/fire_alert/fire_alert_routes.dart';
import 'package:thuctap/features/fire_alert/presentation/fire_alert_controller.dart';

class DesktopHeader extends ConsumerWidget {
  const DesktopHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadCount = ref.watch(
      fireAlertControllerProvider.select((state) => state.unreadCount),
    );

    return Row(
      children: [
        const CircleAvatar(
          radius: 22,
          backgroundImage: NetworkImage(
            'https://scontent.fhan19-1.fna.fbcdn.net/v/t39.30808-6/480687439_997331652508361_7218280523185220920_n.jpg?_nc_cat=108&ccb=1-7&_nc_sid=a5f93a&_nc_eui2=AeHMlg0OzlB3v-_6hDYcMD1EjP0bODaIebmM_Rs4Noh5uToEf218ndixjOCvYE883Al_tzYdV9XlSw8EBjNKdvhw&_nc_ohc=4KNq08NCV2EQ7kNvwEnf5z8&_nc_oc=AdlZm3-XbWS9wUTMn6yG-PPtXJEDHTWSicQ-ame6EL57lAq48OuTF3iKpxeAs1_cT6s&_nc_zt=23&_nc_ht=scontent.fhan19-1.fna&_nc_gid=oD2HaRilSSwSImxXAL9RLQ&oh=00_AfoCmenKOfxUe5915P18MWyJxBYQz8e_nH0wyLW6BdQrYw&oe=697F507D',
          ),
        ),
        const SizedBox(width: 16),

        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi, User!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              'Welcome back to your smart Home.',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),

        const Spacer(),

        IconButton(
          onPressed: () => context.go(FireAlertRoutes.alerts),
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.notifications_none),
              if (unreadCount > 0)
                Positioned(
                  top: -6,
                  right: -8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDC2626),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      unreadCount > 99 ? '99+' : unreadCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
