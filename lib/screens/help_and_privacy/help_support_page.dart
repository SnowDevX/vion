import 'package:flutter/material.dart';
import 'package:grandustionapp/generated/l10n.dart'; 
import '../../components/help_and_privacy.dart';

class HelpSupportPage extends StatelessWidget {
  final bool isRTL;

  const HelpSupportPage({super.key, required this.isRTL});

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
            lang.helpSupport, 
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
          child: Column(
            children: [
              _buildFaqSection(context, lang), 
              const SizedBox(height: helpPadding),
              _buildContactSection(context, lang), 
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFaqSection(BuildContext context, S lang) {
    return Container(
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
              const Icon(Icons.help_center, color: helpAccent, size: helpIconSize),
              const SizedBox(width: 12),
              Text(
                lang.faq, 
                style: const TextStyle(
                  color: helpTextWhite,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: helpPadding),

          _buildFaqItem(
            question: lang.how_are_points_calculated, 
            answer: lang.points_calculation_answer,   
          ),
          const SizedBox(height: helpSmallPadding),

          _buildFaqItem(
            question: lang.can_points_be_converted,   
            answer: lang.points_conversion_answer,    
          ),
          const SizedBox(height: helpSmallPadding),

          _buildFaqItem(
            question: lang.how_to_use_points,         
            answer: lang.use_points_answer,           
          ),
          const SizedBox(height: helpSmallPadding),

          _buildFaqItem(
            question: lang.max_points_per_day,        
            answer: lang.max_points_answer,           
          ),
          const SizedBox(height: helpSmallPadding),

          _buildFaqItem(
            question: lang.steps_not_counted,         
            answer: lang.steps_not_counted_answer,    
          ),
          const SizedBox(height: helpSmallPadding),

          _buildFaqItem(
            question: lang.app_offline,              
            answer: lang.app_offline_answer,         
          ),
          const SizedBox(height: helpSmallPadding),

          _buildFaqItem(
            question: lang.data_security,             
            answer: lang.data_security_answer,       
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem({
    required String question,
    required String answer,
  }) {
    return ExpansionTile(
      backgroundColor: helpPrimaryBackground,
      collapsedBackgroundColor: helpPrimaryBackground,
      title: Text(
        question,
        style: const TextStyle(color: helpTextWhite),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(helpSmallPadding),
          child: Text(
            answer,
            style: const TextStyle(color: helpTextGrey),
          ),
        ),
      ],
    );
  }

  Widget _buildContactSection(BuildContext context, S lang) {
    return Container(
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
              const Icon(Icons.support_agent, color: helpAccent, size: helpIconSize),
              const SizedBox(width: 12),
              Text(
                lang.contact_support, 
                style: const TextStyle(
                  color: helpTextWhite,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: helpPadding),

          _buildContactItem(
            icon: Icons.email_outlined,
            title: lang.email,           
            value: lang.support_email,   
            lang: lang,
          ),
          const SizedBox(height: helpSmallPadding),

          _buildContactItem(
            icon: Icons.phone_outlined,
            title: lang.phone,           
            value: lang.support_phone,  
            lang: lang,
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String value,
    required S lang,
  }) {
    return Row(
      children: [
        Icon(icon, color: helpAccent, size: helpSmallIconSize),
        const SizedBox(width: helpSmallPadding),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: helpTextGrey, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(color: helpTextWhite, fontSize: 16),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.copy, color: helpAccent),
          onPressed: () {
          },
        ),
      ],
    );
  }
}