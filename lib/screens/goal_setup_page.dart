import 'package:flutter/material.dart';
import 'package:grandustionapp/generated/l10n.dart';
import 'package:grandustionapp/services/account_backend.dart';

class GoalSetupPage extends StatefulWidget {
  const GoalSetupPage({super.key});

  @override
  State<GoalSetupPage> createState() => _GoalSetupPageState();
}

class _GoalSetupPageState extends State<GoalSetupPage> {
  final AccountBackend _backend = AccountBackend();
  
  // متغيرات التحكم
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _stepsGoalController = TextEditingController(text: '10000');
  
  bool _isLoading = false;
  int _currentStep = 0; // 0: الطول والوزن, 1: هدف الخطوات
  
  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _stepsGoalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = Localizations.localeOf(context).languageCode == 'ar';
    
    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFF0F1A17),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            _currentStep == 0 ? 'أهلاً بك! ' : 'هدفك اليومي',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.tealAccent),
              )
            : Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    // مؤشر التقدم
                    LinearProgressIndicator(
                      value: _currentStep == 0 ? 0.5 : 1.0,
                      backgroundColor: Colors.grey.withOpacity(0.2),
                      valueColor: const AlwaysStoppedAnimation(Colors.tealAccent),
                    ),
                    const SizedBox(height: 40),
                    
                    // المحتوى حسب الخطوة
                    Expanded(
                      child: _currentStep == 0
                          ? _buildBodyInfoStep(context)
                          : _buildGoalStep(context),
                    ),
                    
                    // أزرار التنقل
                    _buildNavigationButtons(context),
                  ],
                ),
              ),
      ),
    );
  }

  // الخطوة 1: إدخال الطول والوزن
  Widget _buildBodyInfoStep(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Center(
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.tealAccent.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.tealAccent, width: 2),
            ),
            child: const Icon(
              Icons.person_outline,
              color: Colors.tealAccent,
              size: 60,
            ),
          ),
        ),
        const SizedBox(height: 40),
        const Text(
          'أخبرنا عن نفسك',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 20),
        _buildInputField(
          controller: _heightController,
          icon: Icons.height,
          label: 'الطول (سم)',
          hint: 'مثال: 176',
        ),
        const SizedBox(height: 20),
        _buildInputField(
          controller: _weightController,
          icon: Icons.monitor_weight,
          label: 'الوزن (كجم)',
          hint: 'مثال: 82',
        ),
      ],
    );
  }

  // الخطوة 2: تحديد هدف الخطوات
  Widget _buildGoalStep(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Center(
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.tealAccent.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.tealAccent, width: 2),
            ),
            child: const Icon(
              Icons.emoji_events,
              color: Colors.tealAccent,
              size: 60,
            ),
          ),
        ),
        const SizedBox(height: 40),
        const Text(
          'ما هو هدفك اليومي للمشي؟',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 20),
        _buildInputField(
          controller: _stepsGoalController,
          icon: Icons.directions_walk,
          label: 'عدد الخطوات اليومي',
          hint: '10000',
        ),
        const SizedBox(height: 30),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.tealAccent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.tealAccent.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              const Icon(Icons.lightbulb, color: Colors.tealAccent, size: 30),
              const SizedBox(height: 8),
              const Text(
                'نصيحة: 10,000 خطوة يومياً هو هدف ممتاز للصحة العامة',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required IconData icon,
    required String label,
    required String hint,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF182A25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.tealAccent.withOpacity(0.3)),
      ),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.tealAccent),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildNavigationButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _currentStep--;
                  });
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.tealAccent,
                  side: const BorderSide(color: Colors.tealAccent),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('السابق'),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: _handleNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.tealAccent,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(_currentStep == 0 ? 'التالي' : 'ابدأ الرحلة'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleNext() async {
    if (_currentStep == 0) {
      // التحقق من إدخال الطول والوزن
      if (_heightController.text.isEmpty || _weightController.text.isEmpty) {
        _showError('الرجاء إدخال الطول والوزن');
        return;
      }
      
      setState(() {
        _currentStep = 1;
      });
    } else {
      // حفظ البيانات
      await _saveUserGoals();
    }
  }

  Future<void> _saveUserGoals() async {
    setState(() => _isLoading = true);

    try {
      // التحقق من إدخال الهدف
      if (_stepsGoalController.text.isEmpty) {
        _showError('الرجاء إدخال هدفك اليومي');
        setState(() => _isLoading = false);
        return;
      }

      // حفظ البيانات في Firebase
      var result = await _backend.saveProfileChanges(
        name: _backend.currentUser?.displayName ?? '',
        email: _backend.currentUser?.email ?? '',
        height: int.tryParse(_heightController.text) ?? 176,
        weight: int.tryParse(_weightController.text) ?? 82,
        dailyStepsGoal: int.tryParse(_stepsGoalController.text) ?? 10000,
        notifications: true,
      );

      if (result['success'] && mounted) {
        // تعليم أن المستخدم أكمل الإعداد
        await _backend.markGoalAsCompleted();
        
        // الانتقال للصفحة الرئيسية
        Navigator.pushReplacementNamed(context, '/home');
      } else if (mounted) {
        _showError(result['error'] ?? 'حدث خطأ في الحفظ');
      }
    } catch (e) {
      _showError('خطأ: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}