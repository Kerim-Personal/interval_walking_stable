// lib/screens/walking_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:interval_walking/models/difficulty_level.dart';

class WalkingScreen extends StatefulWidget {
  const WalkingScreen({super.key});

  @override
  State<WalkingScreen> createState() => _WalkingScreenState();
}

class _WalkingScreenState extends State<WalkingScreen> {
  Timer? _timer;
  DifficultyLevel _selectedLevel = DifficultyLevel.none;

  int _normalTempoSeconds = 0;
  int _fastTempoSeconds = 0;
  int _totalRepetitions = 0;

  int _totalSeconds = 0;
  bool _isRunning = false;
  String _currentPhase = "Seviye Seçin";
  int _currentRepetition = 0;

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$remainingSeconds';
  }

  void _selectLevel(DifficultyLevel level) {
    setState(() {
      _selectedLevel = level;
      switch (level) {
        case DifficultyLevel.baslangic:
          _normalTempoSeconds = 2 * 60;
          _fastTempoSeconds = 1 * 60;
          _totalRepetitions = 5;
          _currentPhase = "Başlangıç Hazır";
          break;
        case DifficultyLevel.orta:
          _normalTempoSeconds = 3 * 60;
          _fastTempoSeconds = 3 * 60;
          _totalRepetitions = 5;
          _currentPhase = "Orta Seviye Hazır";
          break;
        case DifficultyLevel.ileri:
          _normalTempoSeconds = 3 * 60;
          _fastTempoSeconds = 5 * 60;
          _totalRepetitions = 4;
          _currentPhase = "İleri Seviye Hazır";
          break;
        case DifficultyLevel.none:
          _resetApp();
          break;
      }
      _totalSeconds = _normalTempoSeconds;
      _currentRepetition = 0;
    });
  }

  void _startTimer() {
    if (_isRunning || _selectedLevel == DifficultyLevel.none) return;

    if (_currentRepetition == 0) {
      _currentRepetition = 1;
      _currentPhase = "Normal Tempo";
      _totalSeconds = _normalTempoSeconds;
    }

    setState(() {
      _isRunning = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_totalSeconds > 0) {
        setState(() {
          _totalSeconds--;
        });
      } else {
        if (_currentPhase == "Normal Tempo") {
          setState(() {
            _currentPhase = "Hızlı Tempo";
            _totalSeconds = _fastTempoSeconds;
          });
        } else if (_currentPhase == "Hızlı Tempo") {
          if (_currentRepetition < _totalRepetitions) {
            _currentRepetition++;
            setState(() {
              _currentPhase = "Normal Tempo";
              _totalSeconds = _normalTempoSeconds;
            });
          } else {
            _stopTimer(finished: true);
          }
        }
      }
    });
  }

  void _pauseTimer() {
    if (!_isRunning) return;
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  void _resetApp() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _selectedLevel = DifficultyLevel.none;
      _currentPhase = "Seviye Seçin";
      _currentRepetition = 0;
      _totalSeconds = 0;
    });
  }

  void _stopTimer({bool finished = false}) {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      if (finished) {
        _currentPhase = "Antrenman Bitti!";
        _currentRepetition = _totalRepetitions;
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // --- SEVİYE SEÇİM EKRANI DEVRİMİ ---
  Widget _buildLevelSelection() {
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
            level: DifficultyLevel.baslangic,
            title: "Başlangıç",
            subtitle: "5 Tekrar | 2dk Normal / 1dk Hızlı",
            icon: Icons.grass, // Başlangıcı simgeleyen filiz
            color: Colors.green.shade300,
          ),
          const SizedBox(height: 20),
          _buildLevelButton(
            level: DifficultyLevel.orta,
            title: "Orta",
            subtitle: "5 Tekrar | 3dk Normal / 3dk Hızlı",
            icon: Icons.directions_walk,
            color: Colors.blue.shade300,
          ),
          const SizedBox(height: 20),
          _buildLevelButton(
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

  // --- YENİ YARDIMCI WIDGET: SEVİYE BUTON KARTI ---
  Widget _buildLevelButton({
    required DifficultyLevel level,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias, // Taşan InkWell efektini kesmek için
      child: InkWell(
        onTap: () => _selectLevel(level),
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

  Widget _buildTimerScreen() {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final phaseColor = _currentPhase == "Hızlı Tempo"
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
                _currentPhase,
                style: textTheme.displaySmall?.copyWith(color: phaseColor),
              ),
              const SizedBox(height: 10),
              Text(
                _formatTime(_totalSeconds),
                style: textTheme.displayMedium,
              ),
              const SizedBox(height: 10),
              if (_currentRepetition > 0)
                Text(
                  'Tekrar: $_currentRepetition / $_totalRepetitions',
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
                onPressed: _resetApp,
                tooltip: 'Seviye Seçimine Dön',
              ),
              ElevatedButton(
                onPressed: _isRunning ? _pauseTimer : _startTimer,
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(25),
                  backgroundColor: phaseColor,
                ),
                child: Icon(
                  _isRunning ? Icons.pause : Icons.play_arrow,
                  size: 50,
                ),
              ),
              const SizedBox(width: 35), // Denge için boşluk
            ],
          ),
        ),
        if (_currentPhase != "Antrenman Bitti!")
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aralıklı Yürüyüş'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: _selectedLevel == DifficultyLevel.none
              ? _buildLevelSelection()
              : _buildTimerScreen(),
        ),
      ),
    );
  }
}