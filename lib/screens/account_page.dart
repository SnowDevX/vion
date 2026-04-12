import 'package:flutter/material.dart';
import 'package:grandustionapp/generated/l10n.dart';
import 'package:grandustionapp/providers/language_provider.dart';
import 'package:grandustionapp/screens/help_and_privacy/help_support_page.dart';
import 'package:grandustionapp/screens/help_and_privacy/privacy_policy_page.dart';
import 'package:provider/provider.dart';
import 'package:grandustionapp/services/account_backend.dart';
import 'package:grandustionapp/services/home_backend.dart';  

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final AccountBackend _backend = AccountBackend();
  final HomeBackend _homeBackend = HomeBackend();  

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _stepsGoalController = TextEditingController();

  bool _notificationsEnabled = true;
  bool _isLoading = true;
  int _userPoints = 0;
  String? _photoURL;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }

  Future<void> _loadUserData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    //  جلب بيانات الحساب
    var result = await _backend.loadUserData();
    
    //  جلب totalPoints من HomeBackend
    await _homeBackend.loadUserStats();
    final totalPoints = _homeBackend.totalPoints;

    if (result['success'] && mounted) {
      var data = result['data'];
      setState(() {
        _nameController.text = data['name'];
        _emailController.text = data['email'];
        _heightController.text = data['height'].toString();
        _weightController.text = data['weight'].toString();
        _stepsGoalController.text = data['dailyStepsGoal'].toString();
        _notificationsEnabled = data['notifications'];
        _userPoints = totalPoints;
        _photoURL = data['photoURL'];
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveProfileChanges() async {
    var result = await _backend.saveProfileChanges(
      name: _nameController.text,
      email: _emailController.text,
      height: int.tryParse(_heightController.text) ?? 176,
      weight: int.tryParse(_weightController.text) ?? 82,
      dailyStepsGoal: int.tryParse(_stepsGoalController.text) ?? 10000,
      notifications: _notificationsEnabled,
    );

    if (result['success'] && mounted) {
      await _loadUserData();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("تم حفظ التغييرات بنجاح"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("خطأ: ${result['error']}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _changePassword(String currentPassword, String newPassword) async {
    var result = await _backend.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );

    if (result['success'] && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("تم تغيير كلمة المرور بنجاح"),
          backgroundColor: Colors.green,
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['error']),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _logout() async {
    var result = await _backend.logout();

    if (result['success'] && mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("تم تسجيل الخروج بنجاح"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("خطأ في تسجيل الخروج: ${result['error']}"),
          backgroundColor: Colors.red,
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
                _buildSupportPoliciesSection(lang, isRTL),
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
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.tealAccent.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.tealAccent, width: 2),
            ),
            child: _photoURL != null
                ? CircleAvatar(
                    backgroundImage: NetworkImage(_photoURL!),
                    radius: 35,
                  )
                : const Icon(Icons.person, color: Colors.tealAccent, size: 40),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _nameController.text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
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
                  text: "$_userPoints ",
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
            label: Text(lang.savethechanges),
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

  Widget _buildSupportPoliciesSection(S lang, bool isRTL) {
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
          onTap: () => _navigateToHelpSupport(context, isRTL),
          isRTL: isRTL,
        ),
        const SizedBox(height: 12),
        _buildSettingsItem(
          icon: Icons.privacy_tip_outlined,
          title: lang.privacyPolicy,
          onTap: () => _navigateToPrivacyPolicy(context, isRTL),
          isRTL: isRTL,
        ),
      ],
    );
  }

  void _navigateToHelpSupport(BuildContext context, bool isRTL) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HelpSupportPage(isRTL: isRTL),
      ),
    );
  }

  void _navigateToPrivacyPolicy(BuildContext context, bool isRTL) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PrivacyPolicyPage(isRTL: isRTL),
      ),
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
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 12,
                    ),
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
                      const SnackBar(
                        content: Text("كلمات المرور غير متطابقة"),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  if (newPasswordController.text.length < 6) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
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