import 'package:flutter/material.dart';
import 'package:grandustionapp/generated/l10n.dart';
import 'package:grandustionapp/providers/language_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  // بيانات المستخدم
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _stepsGoalController = TextEditingController();

  bool _notificationsEnabled = true;
  bool _isLoading = true;
  User? _currentUser;
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }

  Future<void> _loadUserData() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    print("=== بدء تحميل بيانات المستخدم ===");

    try {
      _currentUser = FirebaseAuth.instance.currentUser;

      if (_currentUser != null) {
        print(" UID: ${_currentUser!.uid}");
        print(" Email من Auth: ${_currentUser!.email}");
        print(" DisplayName من Auth: ${_currentUser!.displayName}");

        print(" جلب البيانات من Firestore...");
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(_currentUser!.uid)
            .get();

        if (userDoc.exists && userDoc.data() != null) {
          _userData = userDoc.data() as Map<String, dynamic>;

          print(" وجدت بيانات في Firestore:");
          print(" الاسم: ${_userData!['name']}");
          print(" الإيميل: ${_userData!['email']}");
          print(" الطول: ${_userData!['height']}");
          print("  الوزن: ${_userData!['weight']}");

          _nameController.text = _userData!['name']?.toString() ?? "ادخل اسمك";
          _emailController.text =
              _userData!['email']?.toString() ??
              _currentUser!.email ??
              "example@email.com";
          _heightController.text = _userData!['height']?.toString() ?? "176";
          _weightController.text = _userData!['weight']?.toString() ?? "82";
          _stepsGoalController.text =
              _userData!['dailyStepsGoal']?.toString() ?? "10000";
          _notificationsEnabled = _userData!['notifications'] ?? true;

          print(" تم تعيين البيانات:");
          print("   الاسم: ${_nameController.text}");
          print("   الإيميل: ${_emailController.text}");
        } else {
          print(" لا يوجد بيانات في Firestore، استخدام البيانات الافتراضية");
          _nameController.text = _currentUser!.displayName ?? "زائر";
          _emailController.text = _currentUser!.email ?? "غير مسجل";
          _heightController.text = "176";
          _weightController.text = "82";
          _stepsGoalController.text = "10000";
        }
      } else {
        print(" لا يوجد مستخدم مسجل دخول");
        _nameController.text = "زائر";
        _emailController.text = "غير مسجل";
        _heightController.text = "176";
        _weightController.text = "82";
        _stepsGoalController.text = "10000";
      }
    } catch (e) {
      print(" خطأ في تحميل البيانات: $e");
      _nameController.text = "حدث خطأ";
      _emailController.text = "error@example.com";
      _heightController.text = "176";
      _weightController.text = "82";
      _stepsGoalController.text = "10000";
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      print(" انتهى تحميل البيانات");
    }
  }

  // دالة لحفظ التعديلات في Firebase
  Future<void> _saveProfileChanges() async {
    if (_currentUser == null) return;

    try {
      if (_nameController.text != _currentUser!.displayName) {
        await _currentUser!.updateDisplayName(_nameController.text);
        print(" تم تحديث الاسم في Firebase Auth");
      }

      // تحديث البيانات في Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.uid)
          .set({
            'name': _nameController.text,
            'email': _emailController.text,
            'height': int.tryParse(_heightController.text) ?? 176,
            'weight': int.tryParse(_weightController.text) ?? 82,
            'dailyStepsGoal': int.tryParse(_stepsGoalController.text) ?? 10000,
            'notifications': _notificationsEnabled,
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));

      print(" تم حفظ البيانات في Firestore");

      // إعادة تحميل البيانات
      await _loadUserData();

      // إظهار رسالة نجاح
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("تم حفظ التغييرات بنجاح"),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      print(" خطأ في Firebase Auth: ${e.message}");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("خطأ في المصادقة: ${e.message}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print(" خطأ عام: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("حدث خطأ في الحفظ: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // دالة لتغيير كلمة المرور
  Future<void> _changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    if (_currentUser == null || _currentUser!.email == null) return;

    try {
      // إعادة المصادقة
      AuthCredential credential = EmailAuthProvider.credential(
        email: _currentUser!.email!,
        password: currentPassword,
      );

      await _currentUser!.reauthenticateWithCredential(credential);
      await _currentUser!.updatePassword(newPassword);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("تم تغيير كلمة المرور بنجاح"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = "فشل تغيير كلمة المرور";
      if (e.code == 'wrong-password') {
        errorMessage = "كلمة المرور الحالية غير صحيحة";
      } else if (e.code == 'weak-password') {
        errorMessage = "كلمة المرور الجديدة ضعيفة";
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
        );
      }
    }
  }

  // دالة تسجيل الخروج
  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();

      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("تم تسجيل الخروج بنجاح"),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print("❌ خطأ في تسجيل الخروج: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("خطأ في تسجيل الخروج: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // دالة لفحص البيانات (للتشخيص)
  Future<void> _debugCheckData() async {
    print("=== فحص بيانات المستخدم ===");

    User? user = FirebaseAuth.instance.currentUser;
    print("1. Firebase Auth:");
    print("   - UID: ${user?.uid}");
    print("   - Email: ${user?.email}");
    print("   - DisplayName: ${user?.displayName}");

    if (user != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        print("2. Firestore Data:");
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data.forEach((key, value) {
          print("   - $key: $value");
        });
      } else {
        print("2. لا يوجد مستند في Firestore!");
      }
    }

    print("3. الـ Controllers المحلية:");
    print("   - Name: ${_nameController.text}");
    print("   - Email: ${_emailController.text}");
    print("   - Height: ${_heightController.text}");
    print("   - Weight: ${_weightController.text}");

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("تم فحص البيانات، انظر الـ console"),
          backgroundColor: Colors.tealAccent,
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _stepsGoalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context)!;
    final isRTL = Localizations.localeOf(context).languageCode == 'ar';
    final currentLanguage = isRTL ? lang.arabic : lang.english;

    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFF0F1A17),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.tealAccent),
              )
            : _buildBody(context, lang, currentLanguage, isRTL),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    S lang,
    String currentLanguage,
    bool isRTL,
  ) {
    return Column(
      children: [
        // AppBar
        Container(
          padding: const EdgeInsets.only(
            top: 40,
            bottom: 20,
            right: 16,
            left: 16,
          ),
          color: const Color(0xFF0F1A17),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.white),
                onPressed: () {},
              ),
              Expanded(
                child: Text(
                  lang.account,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // زر تحديث البيانات
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.tealAccent),
                onPressed: _loadUserData,
                tooltip: "تحديث البيانات",
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(lang),

                const SizedBox(height: 32),
                _buildAccountManagementSection(lang, isRTL),
                const SizedBox(height: 24),
                _buildActivityGoalsSection(lang),
                const SizedBox(height: 24),
                _buildAppSettingsSection(context, lang, currentLanguage, isRTL),
                const SizedBox(height: 24),
                _buildSupportPoliciesSection(lang),
                const SizedBox(height: 40),
                _buildLogoutButton(lang, isRTL),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileHeader(S lang) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF182A25),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // صورة البروفايل
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.tealAccent.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.tealAccent, width: 2),
            ),
            child: _currentUser?.photoURL != null
                ? CircleAvatar(
                    backgroundImage: NetworkImage(_currentUser!.photoURL!),
                    radius: 35,
                  )
                : const Icon(Icons.person, color: Colors.tealAccent, size: 40),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // الاسم - من Firebase
                Text(
                  _nameController.text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                // الإيميل - من Firebase
                Text(
                  _emailController.text,
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                ),
                const SizedBox(height: 12),
                _buildEnergyPoints(lang),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDebugButton() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: ElevatedButton(
        onPressed: _debugCheckData,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.withOpacity(0.1),
          foregroundColor: Colors.blue,
        ),
        child: const Text("فحص بيانات Firebase"),
      ),
    );
  }

  Widget _buildEnergyPoints(S lang) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.tealAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.tealAccent.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.bolt, color: Colors.tealAccent, size: 16),
          const SizedBox(width: 6),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "${_userData?['energyPoints'] ?? '2,340'} ",
                  style: const TextStyle(
                    color: Colors.tealAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: lang.totalEnergy,
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountManagementSection(S lang, bool isRTL) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            right: isRTL ? 8 : 0,
            left: isRTL ? 0 : 8,
            bottom: 12,
          ),
          child: Text(
            lang.accountSecurityManagement,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        _buildSettingsItem(
          icon: Icons.person_outline,
          title: lang.editProfile,
          subtitle: lang.changeNameAndEmail,
          onTap: () => _showEditProfileDialog(context, lang, isRTL),
          isRTL: isRTL,
        ),
        const SizedBox(height: 12),
        _buildSettingsItem(
          icon: Icons.lock_outline,
          title: lang.changePassword,
          subtitle: lang.updateCurrentPassword,
          onTap: () => _showChangePasswordDialog(context, lang, isRTL),
          isRTL: isRTL,
        ),
      ],
    );
  }

  Widget _buildActivityGoalsSection(S lang) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8, bottom: 12),
          child: Text(
            lang.activityGoalsSettings,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        _buildEditableSettingsItem(
          icon: Icons.height,
          title: lang.heightCm,
          controller: _heightController,
        ),
        const SizedBox(height: 12),
        _buildEditableSettingsItem(
          icon: Icons.monitor_weight,
          title: lang.weightKg,
          controller: _weightController,
        ),
        const SizedBox(height: 12),
        _buildEditableSettingsItem(
          icon: Icons.directions_walk,
          title: lang.dailyStepsGoal,
          controller: _stepsGoalController,
        ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerLeft,
          child: ElevatedButton.icon(
            onPressed: _saveProfileChanges,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.tealAccent,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.save),
            label: const Text("حفظ التغييرات"),
          ),
        ),
      ],
    );
  }

  Widget _buildAppSettingsSection(
    BuildContext context,
    S lang,
    String currentLanguage,
    bool isRTL,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8, bottom: 12),
          child: Text(
            lang.appSettings,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        _buildSettingsItem(
          icon: Icons.language,
          title: lang.language,
          trailing: Row(
            children: [
              Text(
                currentLanguage,
                style: const TextStyle(color: Colors.tealAccent),
              ),
              const SizedBox(width: 8),
              Icon(
                isRTL ? Icons.arrow_left : Icons.arrow_right,
                color: Colors.tealAccent,
              ),
            ],
          ),
          onTap: () => _showLanguageDialog(context, isRTL),
          isRTL: isRTL,
        ),
        const SizedBox(height: 12),
        _buildToggleSettingsItem(
          icon: Icons.notifications_outlined,
          title: lang.notifications,
          subtitle: lang.receiveAlertsAndUpdates,
          value: _notificationsEnabled,
          onChanged: (value) {
            setState(() {
              _notificationsEnabled = value;
            });
            _saveProfileChanges();
          },
        ),
      ],
    );
  }

  Widget _buildSupportPoliciesSection(S lang) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8, bottom: 12),
          child: Text(
            lang.supportPolicies,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        _buildSettingsItem(
          icon: Icons.help_outline,
          title: lang.helpSupport,
          onTap: () {},
          isRTL: true,
        ),
        const SizedBox(height: 12),
        _buildSettingsItem(
          icon: Icons.privacy_tip_outlined,
          title: lang.privacyPolicy,
          onTap: () {},
          isRTL: true,
        ),
      ],
    );
  }

  Widget _buildLogoutButton(S lang, bool isRTL) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _showLogoutConfirmation(context, lang, isRTL),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: const BorderSide(color: Colors.red),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: Icon(
          Icons.logout,
          color: Colors.red,
          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
        ),
        label: Text(
          lang.logout,
          style: const TextStyle(
            color: Colors.red,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    required VoidCallback? onTap,
    required bool isRTL,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF182A25),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.tealAccent),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
            trailing ??
                Icon(
                  isRTL ? Icons.arrow_left : Icons.arrow_right,
                  color: Colors.tealAccent,
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableSettingsItem({
    required IconData icon,
    required String title,
    required TextEditingController controller,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF182A25),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.tealAccent),
          const SizedBox(width: 12),
          Expanded(
            child: TextFormField(
              controller: controller,
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: title,
                labelStyle: const TextStyle(color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleSettingsItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF182A25),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.tealAccent),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                  ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.tealAccent,
            activeTrackColor: Colors.tealAccent.withOpacity(0.5),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context, S lang, bool isRTL) {
    showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
          child: AlertDialog(
            backgroundColor: const Color(0xFF182A25),
            title: Text(
              lang.editProfile,
              style: const TextStyle(color: Colors.white),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildCustomTextField(
                    controller: _nameController,
                    label: lang.name,
                  ),
                  const SizedBox(height: 16),
                  _buildCustomTextField(
                    controller: _emailController,
                    label: lang.email,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  lang.cancel,
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _saveProfileChanges();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent,
                  foregroundColor: Colors.black,
                ),
                child: Text(lang.save),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showChangePasswordDialog(BuildContext context, S lang, bool isRTL) {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
          child: AlertDialog(
            backgroundColor: const Color(0xFF182A25),
            title: Text(
              lang.changePassword,
              style: const TextStyle(color: Colors.white),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildCustomTextField(
                    controller: oldPasswordController,
                    label: lang.currentPassword,
                    obscure: true,
                  ),
                  const SizedBox(height: 16),
                  _buildCustomTextField(
                    controller: newPasswordController,
                    label: lang.newPassword,
                    obscure: true,
                  ),
                  const SizedBox(height: 16),
                  _buildCustomTextField(
                    controller: confirmPasswordController,
                    label: lang.confirmPassword,
                    obscure: true,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  lang.cancel,
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (newPasswordController.text !=
                      confirmPasswordController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text("كلمات المرور غير متطابقة"),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  if (newPasswordController.text.length < 6) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          "كلمة المرور يجب أن تكون 6 أحرف على الأقل",
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  await _changePassword(
                    oldPasswordController.text,
                    newPasswordController.text,
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent,
                  foregroundColor: Colors.black,
                ),
                child: Text(lang.change),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLanguageDialog(BuildContext context, bool isRTL) {
    showDialog(
      context: context,
      builder: (context) {
        final lang = S.of(context)!;

        return Directionality(
          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
          child: AlertDialog(
            backgroundColor: const Color(0xFF182A25),
            title: Text(
              lang.chooseLanguage,
              style: const TextStyle(color: Colors.white),
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView(
                shrinkWrap: true,
                children: [
                  ListTile(
                    title: Text(
                      lang.arabic,
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: isRTL
                        ? const Icon(Icons.check, color: Colors.tealAccent)
                        : null,
                    onTap: () {
                      _changeLanguage(context, const Locale('ar', 'SA'));
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text(
                      lang.english,
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: !isRTL
                        ? const Icon(Icons.check, color: Colors.tealAccent)
                        : null,
                    onTap: () {
                      _changeLanguage(context, const Locale('en', 'US'));
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _changeLanguage(BuildContext context, Locale newLocale) {
    final languageProvider = Provider.of<LanguageProvider>(
      context,
      listen: false,
    );
    languageProvider.setLocale(newLocale);
  }

  void _showLogoutConfirmation(BuildContext context, S lang, bool isRTL) {
    showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
          child: AlertDialog(
            backgroundColor: const Color(0xFF182A25),
            title: Text(
              lang.logout,
              style: const TextStyle(color: Colors.white),
            ),
            content: Text(
              lang.logoutConfirm,
              style: const TextStyle(color: Colors.grey),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  lang.cancel,
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await _logout();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: Text(lang.logout),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String label,
    bool obscure = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.tealAccent),
        ),
      ),
    );
  }
}
