// lib/widgets/timer_display.dart

import 'package:flutter/material.dart';

class TimerDisplay extends StatelessWidget {
  final String currentPhase;
  final int totalSeconds;
  final int currentRepetition;
  final int totalRepetitions;
  final bool isRunning;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onReset;

  const TimerDisplay({
    super.key,
    required this.currentPhase,
    required this.totalSeconds,
    required this.currentRepetition,
    required this.totalRepetitions,
    required this.isRunning,
    required this.onStart,
    required this.onPause,
    required this.onReset,
  });

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$remainingSeconds';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final phaseColor = currentPhase == "Hızlı Tempo"
        ? theme.colorScheme.secondary
        : theme.colorScheme.primary;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                currentPhase,
                style: textTheme.displaySmall?.copyWith(color: phaseColor),
              ),
              const SizedBox(height: 10),
              Text(
                _formatTime(totalSeconds),
                style: textTheme.displayMedium,
              ),
              const SizedBox(height: 10),
              if (currentRepetition > 0)
                Text(
                  'Tekrar: $currentRepetition / $totalRepetitions',
                  style: textTheme.bodyLarge,
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.refresh),
                iconSize: 35,
                onPressed: onReset,
                tooltip: 'Seviye Seçimine Dön',
              ),
              ElevatedButton(
                onPressed: isRunning ? onPause : onStart,
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(25),
                  backgroundColor: phaseColor,
                ),
                child: Icon(
                  isRunning ? Icons.pause : Icons.play_arrow,
                  size: 50,
                ),
              ),
              const SizedBox(width: 35),
            ],
          ),
        ),
        if (currentPhase != "Antrenman Bitti!")
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'ÖNEMLİ: Kalp hastalığı, tansiyon veya şeker ilacı kullanıyorsanız bu antrenmana başlamadan önce mutlaka doktorunuza danışın.',
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium
                    ?.copyWith(color: Colors.white54, fontStyle: FontStyle.italic, fontSize: 13),
              ),
            ),
          ),
      ],
    );
  }
}