import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/top_notice.dart';

// Data class for a scheduled action
class ScheduledAction {
  final String deviceName;
  String action; // e.g., 'Turn On', 'Turn Off'
  TimeOfDay time;
  List<String> daysOfWeek; // e.g., ['Mon', 'Wed', 'Fri']
  final String iconType; // e.g., 'light', 'tv', 'ac'
  bool isEnabled;

  ScheduledAction({
    required this.deviceName,
    required this.action,
    required this.time,
    required this.daysOfWeek,
    required this.iconType,
    this.isEnabled = true,
  });
}

class MobileSchedulerPage extends StatefulWidget {
  const MobileSchedulerPage({super.key});

  @override
  State<MobileSchedulerPage> createState() => _MobileSchedulerPageState();
}

class _MobileSchedulerPageState extends State<MobileSchedulerPage> {
  // Generates mock scheduled actions
  final List<ScheduledAction> _scheduledActions = [
    ScheduledAction(
      deviceName: 'Smart Light',
      action: 'Turn On',
      time: const TimeOfDay(hour: 7, minute: 0),
      daysOfWeek: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'],
      iconType: 'light',
    ),
    ScheduledAction(
      deviceName: 'Bedroom AC',
      action: 'Turn Off',
      time: const TimeOfDay(hour: 22, minute: 30),
      daysOfWeek: ['Everyday'],
      iconType: 'ac',
    ),
    ScheduledAction(
      deviceName: 'Living Room TV',
      action: 'Turn Off',
      time: const TimeOfDay(hour: 0, minute: 0),
      daysOfWeek: ['Sat', 'Sun'],
      iconType: 'tv',
    ),
    ScheduledAction(
      deviceName: 'Coffee Machine',
      action: 'Turn On',
      time: const TimeOfDay(hour: 6, minute: 45),
      daysOfWeek: ['Mon', 'Wed', 'Fri'],
      iconType: 'appliance',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text(
          'Scheduler',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(
            left: AppSizes.paddingMedium,
            top: 8,
            bottom: 8,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              boxShadow: [
                BoxShadow(
                  color: AppColors.textPrimary.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.textPrimary,
                size: 18,
              ),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
          ),
        ),
      ),
      body: _buildScheduledActionList(_scheduledActions),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showTopNotice(
            context: context,
            message: 'Feature coming soon!',
            type: TopNoticeType.info,
          );
        },
        backgroundColor: AppColors.primary,
        elevation: 8,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
          'Add Schedule',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // Builds a list of scheduled actions
  Widget _buildScheduledActionList(List<ScheduledAction> actions) {
    if (actions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.schedule_rounded,
              size: 64,
              color: AppColors.textLight.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'No scheduled actions found.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.textPrimary.withValues(alpha: 0.05),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                final updatedAction = await showDialog<ScheduledAction>(
                  context: context,
                  builder: (context) =>
                      _EditScheduleDialog(initialAction: action),
                );
                if (updatedAction != null) {
                  setState(() {
                    _scheduledActions[index] = updatedAction;
                  });
                }
              },
              borderRadius: BorderRadius.circular(24),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: _getColorForType(
                          action.iconType,
                        ).withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getIconForType(action.iconType),
                        color: _getColorForType(action.iconType),
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${action.deviceName} • ${action.action}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${action.time.format(context)} | ${action.daysOfWeek.join(', ')}',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: action.isEnabled,
                      onChanged: (val) {
                        setState(() {
                          action.isEnabled = val;
                        });
                      },
                      activeColor: AppColors.success,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'light':
        return const Color(0xFFFFB236);
      case 'tv':
        return const Color(0xFF9D63F4);
      case 'appliance':
        return const Color(0xFF22C55E);
      case 'ac':
        return const Color(0xFFFF5252);
      default:
        return AppColors.primary;
    }
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'light':
        return Icons.lightbulb_rounded;
      case 'tv':
        return Icons.tv_rounded;
      case 'appliance':
        return Icons.kitchen_rounded;
      case 'ac':
        return Icons.ac_unit_rounded;
      default:
        return Icons.device_hub_rounded;
    }
  }
}

class _EditScheduleDialog extends StatefulWidget {
  final ScheduledAction initialAction;
  const _EditScheduleDialog({required this.initialAction});

  @override
  State<_EditScheduleDialog> createState() => _EditScheduleDialogState();
}

class _EditScheduleDialogState extends State<_EditScheduleDialog> {
  late TimeOfDay _selectedTime;
  late String _selectedAction;

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.initialAction.time;
    _selectedAction = widget.initialAction.action;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surfaceLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      title: Text(
        'Edit Schedule',
        style: const TextStyle(
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
          color: AppColors.textPrimary,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Time',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              trailing: Text(
                _selectedTime.format(context),
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              onTap: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: _selectedTime,
                );
                if (picked != null) setState(() => _selectedTime = picked);
              },
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(16),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedAction,
                isExpanded: true,
                onChanged: (val) => setState(() => _selectedAction = val!),
                items: ['Turn On', 'Turn Off']
                    .map(
                      (val) => DropdownMenuItem(
                        value: val,
                        child: Text(
                          val,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Cancel',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(
              ScheduledAction(
                deviceName: widget.initialAction.deviceName,
                action: _selectedAction,
                time: _selectedTime,
                daysOfWeek: widget.initialAction.daysOfWeek,
                iconType: widget.initialAction.iconType,
                isEnabled: widget.initialAction.isEnabled,
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Save',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
