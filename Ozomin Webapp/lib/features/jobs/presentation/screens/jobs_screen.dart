import 'package:flutter/material.dart';

class JobsScreen extends StatelessWidget {
  const JobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Job Management',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.05),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recent Jobs',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.filter_list),
                        label: const Text('Filter'),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingTextStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      dataTextStyle: const TextStyle(color: Colors.white70),
                      columns: const [
                        DataColumn(label: Text('Job ID')),
                        DataColumn(label: Text('Type')),
                        DataColumn(label: Text('Requestor')),
                        DataColumn(label: Text('Address')),
                        DataColumn(label: Text('Status')),
                        DataColumn(label: Text('Worker')),
                        DataColumn(label: Text('Time Taken')),
                        DataColumn(label: Text('Waste Logged')),
                        DataColumn(label: Text('Actions')),
                      ],
                      rows: [
                        _buildRow(
                          'JOB-8422',
                          'Commercial Pickup',
                          'Priya Sharma',
                          'Sector 14 High Street',
                          'Completed',
                          'Ramesh K.',
                          '45 mins',
                          '12 kg',
                        ),
                        _buildRow(
                          'JOB-8423',
                          'Residential Pickup',
                          'Amit Patel',
                          'Green Park, Block C',
                          'In Progress',
                          'Sunita D.',
                          '15 mins',
                          '--',
                        ),
                        _buildRow(
                          'JOB-8424',
                          'Sewer Blockage',
                          'Municipal Corp',
                          'Line 4, Phase 2',
                          'Open',
                          'Unassigned',
                          '--',
                          '--',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  DataRow _buildRow(
    String id,
    String type,
    String requestor,
    String address,
    String status,
    String worker,
    String time,
    String waste,
  ) {
    Color statusColor;
    if (status == 'Completed') {
      statusColor = Colors.green;
    } else if (status == 'In Progress')
      statusColor = Colors.orange;
    else
      statusColor = Colors.blueGrey;

    return DataRow(
      cells: [
        DataCell(Text(id, style: const TextStyle(fontWeight: FontWeight.bold))),
        DataCell(Text(type)),
        DataCell(Text(requestor)),
        DataCell(Text(address)),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(status, style: TextStyle(color: statusColor)),
          ),
        ),
        DataCell(Text(worker)),
        DataCell(Text(time)),
        DataCell(Text(waste)),
        DataCell(
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, size: 16),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
