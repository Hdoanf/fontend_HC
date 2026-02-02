import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

// Data class for a scheduled action
class ScheduledAction {
  final String deviceName;
  String action; // e.g., 'Turn On', 'Turn Off'
  TimeOfDay time;
  List<String> daysOfWeek; // e.g., ['Mon', 'Wed', 'Fri']
  final String iconType; // e.g., 'light', 'tv', 'ac'

  ScheduledAction({
    required this.deviceName,
    required this.action,
    required this.time,
    required this.daysOfWeek,
    required this.iconType,
  });
}

class MobileSchedulerPage extends StatefulWidget {
  const MobileSchedulerPage({super.key});

  @override
  State<MobileSchedulerPage> createState() => _MobileSchedulerPageState();
}

class _MobileSchedulerPageState extends State<MobileSchedulerPage> {
  // Generates mock scheduled actions
  List<ScheduledAction> _scheduledActions = [
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
        title: const Text(
          'Scheduler',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: _buildScheduledActionList(_scheduledActions),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement adding a new scheduled action
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add New Schedule (Not Implemented)')),
          );
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.desktopTextPrimary),
      ),
    );
  }

  // Builds a list of scheduled actions
  Widget _buildScheduledActionList(List<ScheduledAction> actions) {
    if (actions.isEmpty) {
      return const Center(
        child: Text(
          'No scheduled actions found. Add a new one!',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return Card(
          color: AppColors.surfaceLight,
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: Icon(
              _getIconForType(action.iconType),
              color: _getColorForType(action.iconType),
            ),
            title: Text(
              '${action.deviceName} - ${action.action}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            subtitle: Text(
              '${action.time.format(context)} | ${action.daysOfWeek.join(', ')}',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.edit, color: AppColors.primary),
              onPressed: () async {
                final updatedAction = await showDialog<ScheduledAction>(
                  context: context,
                  builder: (context) =>
                      _EditScheduleDialog(initialAction: action),
                );

                if (updatedAction != null) {
                  setState(() {
                    _scheduledActions[index] = updatedAction;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Schedule for ${updatedAction.deviceName} updated!',
                      ),
                    ),
                  );
                }
              },
            ),
            onTap: () {
              // TODO: View details or toggle enable/disable
            },
          ),
        );
      },
    );
  }

  // Returns a color for a given device type (from AppColors)
  Color _getColorForType(String type) {
    switch (type) {
      case 'light':
        return AppColors.chartOrange;
      case 'tv':
        return AppColors.chartPurple;
      case 'appliance':
        return AppColors.chartGreen;
      case 'ac':
        return AppColors.chartRed;
      case 'electronics':
        return AppColors.chartBlue;
      default:
        return AppColors.disabled;
    }
  }

  // Gets an icon for a given device type
  IconData _getIconForType(String type) {
    switch (type) {
      case 'light':
        return Icons.lightbulb_outline;
      case 'tv':
        return Icons.tv_outlined;
      case 'appliance':
        return Icons.kitchen_outlined;
      case 'ac':
        return Icons.ac_unit_outlined;
      case 'electronics':
        return Icons.power_outlined;
      default:
        return Icons.device_unknown_outlined;
    }
  }
}

// Dialog for editing a scheduled action
class _EditScheduleDialog extends StatefulWidget {
  final ScheduledAction initialAction;

  const _EditScheduleDialog({required this.initialAction});

  @override
  State<_EditScheduleDialog> createState() => _EditScheduleDialogState();
}

class _EditScheduleDialogState extends State<_EditScheduleDialog> {
  late TimeOfDay _selectedTime;
  late String _selectedAction;
  late List<String> _selectedDays;

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.initialAction.time;
    _selectedAction = widget.initialAction.action;
    _selectedDays = List.from(widget.initialAction.daysOfWeek);
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Edit ${widget.initialAction.deviceName} Schedule',
        style: const TextStyle(color: AppColors.textPrimary),
      ),
      backgroundColor: AppColors.background,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.access_time, color: AppColors.primary),
              title: const Text(
                'Time',
                style: TextStyle(color: AppColors.textPrimary),
              ),
              trailing: TextButton(
                onPressed: _pickTime,
                child: Text(
                  _selectedTime.format(context),
                  style: const TextStyle(color: AppColors.primary),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.power_settings_new,
                color: AppColors.primary,
              ),
              title: const Text(
                'Action',
                style: TextStyle(color: AppColors.textPrimary),
              ),
              trailing: DropdownButton<String>(
                value: _selectedAction,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedAction = newValue!;
                  });
                },
                items: <String>['Turn On', 'Turn Off']
                    .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(color: AppColors.textPrimary),
                        ),
                      );
                    })
                    .toList(),
              ),
            ),
            // TODO: Implement editing days of week
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Days of Week (Not editable yet)',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Dismiss dialog
          },
          child: const Text(
            'Cancel',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
        TextButton(
          onPressed: () {
            final updatedAction = ScheduledAction(
              deviceName: widget.initialAction.deviceName,
              action: _selectedAction,
              time: _selectedTime,
              daysOfWeek: _selectedDays,
              iconType: widget.initialAction.iconType,
            );
            Navigator.of(
              context,
            ).pop(updatedAction); // Pass updated action back
          },
          child: const Text('Save', style: TextStyle(color: AppColors.primary)),
        ),
      ],
    );
  }
}
