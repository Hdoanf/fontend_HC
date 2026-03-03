import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../providers/home_providers.dart';

class MyHomesPage extends ConsumerWidget {
  const MyHomesPage({super.key});

  void _showAddHomeDialog(BuildContext context, WidgetRef ref) {
    final TextEditingController homeNameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(29)),
        title: const Text('Add New Home', style: TextStyle(fontWeight: FontWeight.w800)),
        content: TextField(
          controller: homeNameController,
          decoration: InputDecoration(
            hintText: "Enter home name",
            filled: true,
            fillColor: AppColors.background,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (homeNameController.text.isNotEmpty) {
                await ref.read(homeControllerProvider.notifier).createHome(homeNameController.text);
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homesAsync = ref.watch(homesProvider);
    final currentHomeId = ref.watch(currentHomeIdProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('My Homes', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w800)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: homesAsync.when(
        data: (homes) {
          if (homes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.home_work_outlined, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text("No homes found", style: TextStyle(color: Colors.grey, fontSize: 18)),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _showAddHomeDialog(context, ref),
                    icon: const Icon(Icons.add),
                    label: const Text("Create First Home"),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: homes.length,
            itemBuilder: (context, index) {
              final home = homes[index];
              final dynamic rawId = home['homeId'] ?? home['HomeId'] ?? home['id'] ?? home['Id'];
              final int? homeId = rawId is int ? rawId : int.tryParse(rawId?.toString() ?? '');
              final bool isSelected = currentHomeId == homeId;

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(24),
                  border: isSelected ? Border.all(color: AppColors.primary, width: 2) : null,
                  boxShadow: [
                    BoxShadow(color: AppColors.textPrimary.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 8)),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  leading: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: (isSelected ? AppColors.primary : Colors.grey).withOpacity(0.1), shape: BoxShape.circle),
                    child: Icon(Icons.home_rounded, color: isSelected ? AppColors.primary : Colors.grey),
                  ),
                  title: Text(home['name'] ?? 'Smart Home', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                  subtitle: Text(isSelected ? "Currently Active" : "Tap to switch", style: TextStyle(color: isSelected ? AppColors.primary : Colors.grey)),
                  trailing: isSelected ? const Icon(Icons.check_circle_rounded, color: AppColors.primary) : null,
                  onTap: () {
                    ref.read(currentHomeIdProvider.notifier).state = homeId;
                    // Tự động làm mới danh sách phòng khi đổi nhà
                    ref.invalidate(roomsProvider);
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text("Error: $err")),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddHomeDialog(context, ref),
        label: const Text("Add New Home"),
        icon: const Icon(Icons.add),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}
