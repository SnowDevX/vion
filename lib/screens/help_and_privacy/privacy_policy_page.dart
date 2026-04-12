import 'package:flutter/material.dart';
import 'package:grandustionapp/generated/l10n.dart';
import '../../components/help_and_privacy.dart';

class PrivacyPolicyPage extends StatelessWidget {
  final bool isRTL;

  const PrivacyPolicyPage({super.key, required this.isRTL});

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context)!;
    
    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: helpPrimaryBackground,
        appBar: AppBar(
          backgroundColor: helpPrimaryBackground,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: helpTextWhite),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            lang.privacyPolicy,
            style: const TextStyle(
              color: helpTextWhite,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(helpPadding),
          child: Container(
            padding: const EdgeInsets.all(helpPadding),
            decoration: BoxDecoration(
              color: helpCardBackground,
              borderRadius: BorderRadius.circular(helpBorderRadius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.privacy_tip, color: helpAccent, size: helpIconSize),
                    const SizedBox(width: 12),
                    Text(
                      lang.privacyPolicy,
                      style: const TextStyle(
                        color: helpTextWhite,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildPrivacySection(
                  title: lang.information_collection,
                  content: lang.information_collection_content,
                ),
                const SizedBox(height: helpPadding),
                _buildPrivacySection(
                  title: lang.information_usage,
                  content: lang.information_usage_content,
                ),
                const SizedBox(height: helpPadding),
                _buildPrivacySection(
                  title: lang.information_sharing,
                  content: lang.information_sharing_content,
                ),
                const SizedBox(height: helpPadding),
                _buildPrivacySection(
                  title: lang.data_security_policy,
                  content: lang.data_security_content,
                ),
                const SizedBox(height: helpPadding),
                _buildPrivacySection(
                  title: lang.your_rights,
                  content: lang.your_rights_content,
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(helpSmallPadding),
                  decoration: BoxDecoration(
                    color: helpAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(helpSmallBorderRadius),
                    border: Border.all(color: helpAccent.withOpacity(0.3)),
                  ),
                  child: Center(
                    child: Text(
                      "${lang.last_update}: 1 أبريل 2026",
                      style: const TextStyle(color: helpAccent, fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPrivacySection({
    required String title,
    required String content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: helpAccent,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(color: helpTextGrey, height: 1.5),
        ),
      ],
    );
  }
}