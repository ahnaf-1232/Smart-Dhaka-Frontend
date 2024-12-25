import 'package:flutter/material.dart';

class SystemSettingsScreen extends StatefulWidget {
  const SystemSettingsScreen({Key? key}) : super(key: key);

  @override
  _SystemSettingsScreenState createState() => _SystemSettingsScreenState();
}

class _SystemSettingsScreenState extends State<SystemSettingsScreen> {
  bool _maintenanceMode = false;
  bool _debugMode = false;
  String _selectedTheme = 'Light';
  double _sessionTimeout = 30;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('System Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSwitchTile(
            title: 'Maintenance Mode',
            subtitle: 'Enable maintenance mode for system updates',
            value: _maintenanceMode,
            onChanged: (value) {
              setState(() {
                _maintenanceMode = value;
              });
              _updateSetting('maintenance_mode', value);
            },
          ),
          _buildSwitchTile(
            title: 'Debug Mode',
            subtitle: 'Enable debug mode for additional logging',
            value: _debugMode,
            onChanged: (value) {
              setState(() {
                _debugMode = value;
              });
              _updateSetting('debug_mode', value);
            },
          ),
          _buildDropdownTile(
            title: 'Theme',
            subtitle: 'Select the application theme',
            value: _selectedTheme,
            items: ['Light', 'Dark', 'System'],
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedTheme = newValue;
                });
                _updateSetting('theme', newValue);
              }
            },
          ),
          _buildSliderTile(
            title: 'Session Timeout',
            subtitle: 'Set the session timeout duration (in minutes)',
            value: _sessionTimeout,
            min: 5,
            max: 60,
            divisions: 11,
            onChanged: (value) {
              setState(() {
                _sessionTimeout = value;
              });
              _updateSetting('session_timeout', value);
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _resetToDefaults,
            child: const Text('Reset to Defaults'),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      child: SwitchListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDropdownTile({
    required String title,
    required String subtitle,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: DropdownButton<String>(
          value: value,
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSliderTile({
    required String title,
    required String subtitle,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
  }) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subtitle),
            Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              label: value.round().toString(),
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }

  void _updateSetting(String key, dynamic value) {
    // TODO: Implement setting update logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Updated $key to $value')),
    );
  }

  void _resetToDefaults() {
    setState(() {
      _maintenanceMode = false;
      _debugMode = false;
      _selectedTheme = 'Light';
      _sessionTimeout = 30;
    });
    // TODO: Implement reset to defaults logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reset all settings to defaults')),
    );
  }
}

