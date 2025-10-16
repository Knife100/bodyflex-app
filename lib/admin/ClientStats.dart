import 'package:flutter/material.dart';

class ClientStats extends StatelessWidget {
  const ClientStats({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;

    const stats = [
      _StatCard(
        title: 'Total Clientes',
        value: '1,234',
        subtitle: '+45 este mes',
        icon: Icons.group,
      ),
      _StatCard(
        title: 'Clientes Activos',
        value: '1,156',
        subtitle: '94% del total',
        icon: Icons.check_circle_outline,
      ),
      _StatCard(
        title: 'Nuevos Este Mes',
        value: '45',
        subtitle: '+25% vs mes anterior',
        icon: Icons.person_add_alt_1,
      ),
      _StatCard(
        title: 'Plan Más Popular',
        value: 'MENSUALIDAD',
        subtitle: '45% de los clientes',
        icon: Icons.star_border,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: isWide
          ? Wrap(
              spacing: 16,
              runSpacing: 16,
              children: stats
                  .map((stat) => SizedBox(
                        width: MediaQuery.of(context).size.width / 2 - 24,
                        child: stat,
                      ))
                  .toList(),
            )
          : Column(
              children: stats
                  .map((stat) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: stat,
                      ))
                  .toList(),
            ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 247, 247, 247),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: Colors.grey[200],
              child: Icon(icon, size: 24, color: Colors.grey[600]),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(color: Colors.grey[600]),
                  ),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
