// lib/screens/walking_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:interval_walking/models/difficulty_level.dart';
import 'package:interval_walking/services/auth_service.dart';
import 'package:interval_walking/widgets/level_selection.dart';
import 'package:interval_walking/widgets/timer_display.dart';

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
          return;
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

    setState(() => _isRunning = true);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_totalSeconds > 0) {
        setState(() => _totalSeconds--);
      } else {
        _handlePhaseChange();
      }
    });
  }

  void _handlePhaseChange() {
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

  void _pauseTimer() {
    if (!_isRunning) return;
    _timer?.cancel();
    setState(() => _isRunning = false);
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

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Aralıklı Yürüyüş'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Çıkış Yap',
            onPressed: () async => await authService.signOut(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: _selectedLevel == DifficultyLevel.none
              ? LevelSelection(onLevelSelected: _selectLevel)
              : TimerDisplay(
            currentPhase: _currentPhase,
            totalSeconds: _totalSeconds,
            currentRepetition: _currentRepetition,
            totalRepetitions: _totalRepetitions,
            isRunning: _isRunning,
            onStart: _startTimer,
            onPause: _pauseTimer,
            onReset: _resetApp,
          ),
        ),
      ),
    );
  }
}