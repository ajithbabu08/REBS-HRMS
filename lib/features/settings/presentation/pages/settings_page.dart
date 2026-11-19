import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../app/config/environment.dart';
import '../../../../core/di/service_locator.dart';
import 'debug_panel_page.dart';

class SettingsPage extends StatelessWidget {
  final String employeeId;

  const SettingsPage({super.key, required this.employeeId});

  @override
  Widget build(BuildContext context) {
    final config = sl<AppConfig>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Profile card
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: const Text(
                      'AB',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ajith Babu',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Flutter Developer',
                          style: TextStyle(
                            fontSize: 13,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'ID: $employeeId  •  Engineering',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Workspace Information Section
          _buildSectionHeader('Workspace Configuration'),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                _buildInfoTile(
                  icon: Icons.business,
                  title: 'Company Office',
                  subtitle: 'Teqbae Innovations & Solutions India Pvt Ltd, Kakkanad',
                ),
                const Divider(height: 1),
                _buildInfoTile(
                  icon: Icons.my_location,
                  title: 'Office Coordinates',
                  subtitle: '${config.officeLatitude}, ${config.officeLongitude}',
                ),
                const Divider(height: 1),
                _buildInfoTile(
                  icon: Icons.radar,
                  title: 'Geofence Radius',
                  subtitle: '${config.officeRadiusMeters.toInt()} meters (strict enforcement)',
                ),
                const Divider(height: 1),
                _buildInfoTile(
                  icon: Icons.schedule,
                  title: 'Company Timezone',
                  subtitle: config.companyTimezone,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // System info
          _buildSectionHeader('Application Info'),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                _buildInfoTile(
                  icon: Icons.apps,
                  title: 'Version',
                  subtitle: '1.0.0 (Build 1)',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Debug Panel action (available in debug builds)
          if (kDebugMode)
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const DebugPanelPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.developer_mode),
                label: const Text(
                  'Open Debug Simulation Panel',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.indigo.shade700, size: 22),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      dense: true,
    );
  }
}
