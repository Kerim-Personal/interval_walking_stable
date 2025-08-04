// lib/widgets/level_selection.dart

import 'package:flutter/material.dart';
import 'package:interval_walking/models/difficulty_level.dart';

class LevelSelection extends StatelessWidget {
  final Function(DifficultyLevel) onLevelSelected;

  const LevelSelection({super.key, required this.onLevelSelected});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Antrenman Seviyenizi Seçin",
            style: textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 50),
          _buildLevelButton(
            context,
            level: DifficultyLevel.baslangic,
            title: "Başlangıç",
            subtitle: "5 Tekrar | 2dk Normal / 1dk Hızlı",
            icon: Icons.grass,
            color: Colors.green.shade300,
          ),
          const SizedBox(height: 20),
          _buildLevelButton(
            context,
            level: DifficultyLevel.orta,
            title: "Orta",
            subtitle: "5 Tekrar | 3dk Normal / 3dk Hızlı",
            icon: Icons.directions_walk,
            color: Colors.blue.shade300,
          ),
          const SizedBox(height: 20),
          _buildLevelButton(
            context,
            level: DifficultyLevel.ileri,
            title: "İleri",
            subtitle: "4 Tekrar | 3dk Normal / 5dk Hızlı",
            icon: Icons.directions_run,
            color: Colors.red.shade300,
          ),
        ],
      ),
    );
  }

  Widget _buildLevelButton(
      BuildContext context, {
        required DifficultyLevel level,
        required String title,
        required String subtitle,
        required IconData icon,
        required Color color,
      }) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => onLevelSelected(level),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.white54),
            ],
          ),
        ),
      ),
    );
  }
}