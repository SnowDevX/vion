import 'dart:async';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:grandustionapp/generated/l10n.dart';
import 'package:grandustionapp/services/charge_now_backend.dart';
import 'package:grandustionapp/services/home_backend.dart';

class ChargingPage extends StatefulWidget {
  const ChargingPage({super.key});

  @override
  State<ChargingPage> createState() => _ChargingPageState();
}

class _ChargingPageState extends State<ChargingPage> {
  final ChargingBackend _chargingBackend = ChargingBackend();
  final HomeBackend _homeBackend = HomeBackend();
  
  double _chargingPercent = 0.0;  
  int _usedPoints = 0;
  int _seconds = 0;
  int _userPoints = 0;
  int _batteryLevel = 0;  
  bool _isLoading = true;
  bool _isCharging = false;
  bool _isComplete = false;
  bool _isPointsDeducted = false;

  Timer? _chargingTimer;
  Timer? _batteryMonitorTimer;

  @override
  void initState() {
    super.initState();
    _initializePage();
  }

  Future<void> _initializePage() async {
    setState(() => _isLoading = true);
    
    await _homeBackend.loadUserStats();
    _userPoints = _homeBackend.totalPoints;
    
    _batteryLevel = await _chargingBackend.getCurrentBatteryLevel();
    
    setState(() => _isLoading = false);
  }

  void _startCharging() {
    if (_chargingTimer != null) return;
    
    final lang = S.of(context)!;
    
    if (_batteryLevel >= 100) {
      _showBatteryFullDialog(lang);
      return;
    }
    
    if (_userPoints <= 0) {
      _showNoPointsDialog(lang);
      return;
    }
    
    _isCharging = true;
    
    _chargingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_chargingPercent >= 100.0) {
        _completeCharging();
      } else {
        setState(() {
          _chargingPercent += 1.0;
          if (_chargingPercent > 100) _chargingPercent = 100;
          
          _usedPoints = (_chargingPercent * 10).toInt();
          if (_usedPoints > _userPoints) {
            _usedPoints = _userPoints;
          }
          
          _seconds += 1;
        });
      }
    });
    
    _startBatteryMonitoring();
  }

  void _startBatteryMonitoring() {
    _batteryMonitorTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      final newBatteryLevel = await _chargingBackend.getCurrentBatteryLevel();
      
      setState(() {
        _batteryLevel = newBatteryLevel;
      });
      
      if (_batteryLevel >= 100 && _isCharging) {
        _stopChargingAndDeductPoints(reason: S.of(context)!.batteryChargingComplete);
      }
    });
  }

  Future<void> _stopChargingAndDeductPoints({String reason = 'تم الإيقاف يدوياً'}) async {
    if (!_isCharging || _isPointsDeducted) return;
    
    _chargingTimer?.cancel();
    _chargingTimer = null;
    _batteryMonitorTimer?.cancel();
    _batteryMonitorTimer = null;
    
    _isCharging = false;
    
    if (_usedPoints > 0 && !_isPointsDeducted) {
      _isPointsDeducted = true;
      final success = await _chargingBackend.deductPoints(_usedPoints);
      
      if (success && mounted) {
        await _homeBackend.loadUserStats();
        _userPoints = _homeBackend.totalPoints;
        
        _showStopDialog(
          title: S.of(context)!.chargingStopped,
          message: '${S.of(context)!.chargingStoppedMessage}\n${S.of(context)!.pointsUsedLabel} $_usedPoints\n${S.of(context)!.reason} $reason',
        );
      } else if (mounted) {
        _showStopDialog(
          title: S.of(context)!.deductPointsFailed,
          message: S.of(context)!.deductPointsError,
          isError: true,
        );
      }
    }
  }

  Future<void> _completeCharging() async {
    if (_isComplete) return;
    
    _chargingTimer?.cancel();
    _chargingTimer = null;
    _batteryMonitorTimer?.cancel();
    _batteryMonitorTimer = null;
    
    _isCharging = false;
    _isComplete = true;
    
    setState(() {
      _chargingPercent = 100;
    });
    
    if (_usedPoints > 0 && !_isPointsDeducted) {
      _isPointsDeducted = true;
      final success = await _chargingBackend.deductPoints(_usedPoints);
      
      if (success && mounted) {
        await _homeBackend.loadUserStats();
        _userPoints = _homeBackend.totalPoints;
        _showCompletionDialog();
      } else if (mounted) {
        _showStopDialog(
          title: S.of(context)!.deductPointsFailed,
          message: S.of(context)!.chargeFailedPoints,
          isError: true,
        );
      }
    }
  }

  void _showCompletionDialog() {
    final lang = S.of(context)!;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF182A25),
        title: Text(
          lang.chargingCompleted,
          style: const TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lang.phoneChargedSuccess,
              style: TextStyle(color: Colors.grey.shade300),
            ),
            const SizedBox(height: 8),
            Text(
              '${lang.pointsUsedLabel} $_usedPoints',
              style: const TextStyle(color: Color(0xFF44C37F)),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF44C37F),
              foregroundColor: Colors.black,
            ),
            child: Text(lang.ok),
          ),
        ],
      ),
    );
  }

  void _showStopDialog({required String title, required String message, bool isError = false}) {
    final lang = S.of(context)!;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF182A25),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          message,
          style: const TextStyle(color: Colors.white70),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isError ? Colors.red : const Color(0xFF44C37F),
              foregroundColor: Colors.black,
            ),
            child: Text(lang.ok),
          ),
        ],
      ),
    );
  }

  void _showBatteryFullDialog(S lang) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF182A25),
        title: Text(
          lang.batteryFull,
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          lang.cannotChargeBatteryFull,
          style: const TextStyle(color: Colors.white70),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF44C37F),
              foregroundColor: Colors.black,
            ),
            child: Text(lang.ok),
          ),
        ],
      ),
    );
  }

  void _showNoPointsDialog(S lang) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF182A25),
        title: Text(
          lang.insufficientPoints,
          style: const TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${lang.insufficientPointsMessage.replaceAll('نقطة', '$_userPoints نقطة')}',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Text(
              lang.walkToEarnPoints,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF44C37F),
              foregroundColor: Colors.black,
            ),
            child: Text(lang.ok),
          ),
        ],
      ),
    );
  }

  void _cancelCharging() async {
    if (_isCharging) {
      await _stopChargingAndDeductPoints(reason: S.of(context)!.cancel);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _chargingTimer?.cancel();
    _batteryMonitorTimer?.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final min = seconds ~/ 60;
    final sec = seconds % 60;
    return "$min:${sec.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context)!;
    final remainingPoints = _userPoints - _usedPoints;
    final isRTL = Localizations.localeOf(context).languageCode == 'ar';

    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFF0B1F1A),
        body: const Center(
          child: CircularProgressIndicator(color: Color(0xFF44C37F)),
        ),
      );
    }

    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFF0B1F1A),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            lang.chargeNow,
            style: const TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: _cancelCharging,
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // شحن الجوال الحقيقي
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F3D36),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.phone_android, color: Colors.white70),
                    const SizedBox(width: 8),
                    Text(
                      '${lang.phoneBattery}: $_batteryLevel%',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              
              // نسبة شحن الجوال
              CircularPercentIndicator(
                radius: 95,
                lineWidth: 14,
                percent: _chargingPercent / 100,
                circularStrokeCap: CircularStrokeCap.round,
                animation: true,
                backgroundColor: Colors.white12,
                linearGradient: const LinearGradient(
                  colors: [
                    Color(0xFF00FF73),
                    Color(0xFF01FDCB),
                    Color(0xFF01ECF0),
                  ],
                ),
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${_chargingPercent.toInt()}%",
                      style: const TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _isComplete
                          ? lang.charged
                          : _isCharging
                          ? lang.charging
                          : lang.readyToCharge,
                      style: TextStyle(
                        color: _isComplete
                            ? Colors.greenAccent
                            : _isCharging
                            ? Colors.green
                            : Colors.orangeAccent,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // معلومات النقاط
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _infoBox(
                    title: lang.yourBalance,
                    value: "$_userPoints",
                    valueColor: Colors.blueAccent,
                  ),
                  _infoBox(
                    title: lang.pointsUsed,
                    value: "$_usedPoints",
                    valueColor: Colors.redAccent,
                  ),
                  _infoBox(
                    title: lang.remainingPoints,
                    value: "$remainingPoints",
                    valueColor: Colors.greenAccent,
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // زر بدء الشحن
              if (!_isCharging && !_isComplete)
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF44C37F),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _startCharging,
                    child: Text(
                      lang.startCharging,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoBox({
    required String title,
    required String value,
    required Color valueColor,
  }) {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1F3D36),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}