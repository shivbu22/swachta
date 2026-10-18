import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/colors.dart';

// ─── NOTIFICATION CENTER ───
class NotificationCenterScreen extends StatelessWidget {
  const NotificationCenterScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final notifs = [
      {'title': 'SOS Alert — Worker Rajesh K.', 'body': 'Fall detected at Zone A, Andheri. GPS coords sent.', 'time': '5 min ago', 'type': 'alert', 'read': false},
      {'title': 'Warehouse B Capacity Warning', 'body': 'Current fill: 92%. Dispatch team recommended.', 'time': '1h ago', 'type': 'warning', 'read': false},
      {'title': 'Payroll Processed', 'body': 'April payroll for 120 workers processed successfully.', 'time': '3h ago', 'type': 'info', 'read': true},
      {'title': 'Route RT-003 Completed', 'body': 'Amit Sharma completed Dadar Central with 245 kg collected.', 'time': '4h ago', 'type': 'success', 'read': true},
      {'title': 'CPCB Report Due', 'body': 'Q1 Hazardous Waste Manifest due in 5 days.', 'time': '6h ago', 'type': 'warning', 'read': true},
      {'title': 'New Complaint Filed', 'body': 'Missed pickup reported in Zone D by Sunita Devi.', 'time': '8h ago', 'type': 'alert', 'read': true},
      {'title': 'AI Insight: Demand Spike', 'body': 'Plastic collection forecast to increase 15% next week.', 'time': '12h ago', 'type': 'info', 'read': true},
    ];
    return Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Text('Notification Center', style: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        const Spacer(),
        Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: AppColors.errorRed.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
          child: Text('${notifs.where((n) => n['read'] == false).length} Unread', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.errorRed))),
      ]),
      const SizedBox(height: 16),
      Expanded(child: ListView.builder(itemCount: notifs.length, itemBuilder: (_, i) {
        final n = notifs[i];
        final tc = {'alert': AppColors.errorRed, 'warning': AppColors.warningAmber, 'info': AppColors.infoCyan, 'success': AppColors.successGreen};
        final ti = {'alert': Icons.error, 'warning': Icons.warning, 'info': Icons.info, 'success': Icons.check_circle};
        final c = tc[n['type']] ?? AppColors.textMuted;
        final read = n['read'] as bool;
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: read ? AppColors.darkCard : AppColors.darkCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: read ? AppColors.darkBorder : c.withValues(alpha: 0.3)),
          ),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: c.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
              child: Icon(ti[n['type']] ?? Icons.info, size: 20, color: c)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                if (!read) Container(width: 8, height: 8, margin: const EdgeInsets.only(right: 8), decoration: BoxDecoration(shape: BoxShape.circle, color: c)),
                Expanded(child: Text(n['title'] as String, style: GoogleFonts.inter(fontSize: 14, fontWeight: read ? FontWeight.w500 : FontWeight.w700, color: AppColors.textPrimary))),
                Text(n['time'] as String, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted)),
              ]),
              const SizedBox(height: 4),
              Text(n['body'] as String, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary)),
            ])),
          ]),
        );
      })),
    ]));
  }
}

// ─── WORKER MESSAGING ───
class WorkerMessagingScreen extends StatelessWidget {
  const WorkerMessagingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final chats = [
      {'name': 'Rajesh Kumar', 'last': 'Completed Zone A sweep ✅', 'time': '2m', 'unread': 2},
      {'name': 'All Collectors', 'last': 'New PPE available at Warehouse A', 'time': '30m', 'unread': 0},
      {'name': 'Suresh Patil', 'last': 'Vehicle breakdown at Bandra', 'time': '1h', 'unread': 1},
      {'name': 'Kiran Kumari', 'last': 'Request for overtime tomorrow', 'time': '2h', 'unread': 0},
      {'name': 'Zone A Team', 'last': 'Morning briefing at 6 AM sharp', 'time': '3h', 'unread': 0},
      {'name': 'Amit Sharma', 'last': 'Medical leave from Monday', 'time': '5h', 'unread': 0},
    ];
    return Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Worker Messaging', style: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      const SizedBox(height: 16),
      Expanded(child: Row(children: [
        SizedBox(width: 340, child: Container(
          decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.darkBorder)),
          child: Column(children: [
            Padding(padding: const EdgeInsets.all(16), child: TextField(
              style: GoogleFonts.inter(fontSize: 13, color: AppColors.textPrimary),
              decoration: InputDecoration(hintText: 'Search conversations...', hintStyle: GoogleFonts.inter(fontSize: 13, color: AppColors.textMuted),
                prefixIcon: const Icon(Icons.search, size: 18, color: AppColors.textMuted), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.darkBorder)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.darkBorder)),
                contentPadding: const EdgeInsets.symmetric(vertical: 10), filled: true, fillColor: AppColors.darkSurface),
            )),
            Expanded(child: ListView.builder(itemCount: chats.length, itemBuilder: (_, i) {
              final c = chats[i];
              final unread = (c['unread'] as int) > 0;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.darkBorder.withValues(alpha: 0.5)))),
                child: Row(children: [
                  CircleAvatar(radius: 20, backgroundColor: AppColors.deepForest, child: Text((c['name'] as String).split(' ').map((n) => n[0]).take(2).join(), style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.neonGreen))),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(c['name'] as String, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    Text(c['last'] as String, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.inter(fontSize: 12, color: unread ? AppColors.textPrimary : AppColors.textMuted)),
                  ])),
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text(c['time'] as String, style: GoogleFonts.inter(fontSize: 10, color: AppColors.textMuted)),
                    if (unread) Container(margin: const EdgeInsets.only(top: 4), padding: const EdgeInsets.all(4), decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primaryGreen),
                      child: Text('${c['unread']}', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white))),
                  ]),
                ]),
              );
            })),
          ]),
        )),
        const SizedBox(width: 16),
        Expanded(child: Container(
          decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.darkBorder)),
          child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.chat_bubble_outline, size: 48, color: AppColors.textMuted.withValues(alpha: 0.3)),
            const SizedBox(height: 12),
            Text('Select a conversation', style: GoogleFonts.inter(fontSize: 16, color: AppColors.textMuted)),
          ])),
        )),
      ])),
    ]));
  }
}

// ─── ACTIVITY LOGS ───
class ActivityLogsScreen extends StatelessWidget {
  const ActivityLogsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final activities = List.generate(25, (i) {
      final actions = ['Logged in', 'Updated pay rates', 'Approved leave', 'Generated report', 'Added worker', 'Modified route', 'Sent bulk SMS', 'Changed zone'];
      final users = ['admin@ozohouse.com', 'supervisor@ozohouse.com', 'manager@ozohouse.com'];
      return {'action': actions[i%actions.length], 'user': users[i%3], 'time': '${i*8+2} min ago', 'module': i%4==0?'System':i%4==1?'People':i%4==2?'Operations':'Finance'};
    });
    return Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Activity Logs', style: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      const SizedBox(height: 16),
      Expanded(child: Container(
        decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.darkBorder)),
        child: ListView.separated(padding: const EdgeInsets.all(16), itemCount: activities.length, separatorBuilder: (_, __) => const SizedBox(height: 4),
          itemBuilder: (_, i) {
            final a = activities[i];
            return Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: i%2==0 ? AppColors.darkSurface : Colors.transparent, borderRadius: BorderRadius.circular(6)),
              child: Row(children: [
                SizedBox(width: 100, child: Text(a['time']!, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted))),
                SizedBox(width: 200, child: Text(a['user']!, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary))),
                Expanded(child: Text(a['action']!, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textPrimary))),
                Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: AppColors.primaryGreen.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(6)),
                  child: Text(a['module']!, style: GoogleFonts.inter(fontSize: 11, color: AppColors.primaryGreen))),
              ]));
          }),
      )),
    ]));
  }
}

// ─── ROLES & PERMISSIONS ───
class RolesPermissionsScreen extends StatelessWidget {
  const RolesPermissionsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final roles = [
      {'name': 'Super Admin', 'users': 1, 'perms': 'Full Access', 'color': AppColors.errorRed},
      {'name': 'Admin', 'users': 3, 'perms': 'All except System Config', 'color': AppColors.warningAmber},
      {'name': 'Supervisor', 'users': 8, 'perms': 'Operations, People, Reports', 'color': AppColors.primaryGreen},
      {'name': 'Warehouse Manager', 'users': 5, 'perms': 'Inventory, Stock, Fleet', 'color': AppColors.infoCyan},
      {'name': 'Field Officer', 'users': 12, 'perms': 'Workers, Jobs, Live Map', 'color': AppColors.chartEwaste},
      {'name': 'Finance Officer', 'users': 2, 'perms': 'Finance, Compliance, GST', 'color': AppColors.statusBreak},
    ];
    return Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Roles & Permissions', style: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      const SizedBox(height: 16),
      Expanded(child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 1.5),
        itemCount: roles.length,
        itemBuilder: (_, i) {
          final r = roles[i];
          final c = r['color'] as Color;
          return Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: c.withValues(alpha: 0.3))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: c.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
                  child: Icon(Icons.admin_panel_settings, size: 22, color: c)),
                const Spacer(),
                Text('${r['users']} users', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted)),
              ]),
              const Spacer(),
              Text(r['name'] as String, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              Text(r['perms'] as String, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
            ]));
        },
      )),
    ]));
  }
}

// ─── INTEGRATIONS ───
class IntegrationsScreen extends StatelessWidget {
  const IntegrationsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final integrations = [
      {'name': 'Supabase', 'desc': 'Database & Auth', 'status': 'connected', 'icon': Icons.storage},
      {'name': 'Google Maps', 'desc': 'Live Tracking & Routing', 'status': 'connected', 'icon': Icons.map},
      {'name': 'Razorpay', 'desc': 'Payment Gateway', 'status': 'connected', 'icon': Icons.payment},
      {'name': 'Firebase FCM', 'desc': 'Push Notifications', 'status': 'connected', 'icon': Icons.notifications},
      {'name': 'WhatsApp Business', 'desc': 'Citizen Notifications', 'status': 'pending', 'icon': Icons.message},
      {'name': 'GST Portal', 'desc': 'Tax Filing API', 'status': 'disconnected', 'icon': Icons.receipt_long},
    ];
    return Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Integrations', style: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      const SizedBox(height: 16),
      Expanded(child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 2.0),
        itemCount: integrations.length,
        itemBuilder: (_, i) {
          final ig = integrations[i];
          final sc = {'connected': AppColors.successGreen, 'pending': AppColors.warningAmber, 'disconnected': AppColors.errorRed};
          final c = sc[ig['status']] ?? AppColors.textMuted;
          return Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.darkBorder)),
            child: Row(children: [
              Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: c.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                child: Icon(ig['icon'] as IconData, size: 24, color: c)),
              const SizedBox(width: 16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(ig['name'] as String, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                Text(ig['desc'] as String, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
              ])),
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: c.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
                child: Text((ig['status'] as String).toUpperCase(), style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: c))),
            ]));
        },
      )),
    ]));
  }
}
