import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Text('''
Last updated: October 20, 2025

This is a placeholder Privacy Policy.

1. Information Collection
Our app, QRX Pro, may collect anonymous usage data to improve our services. This includes features like scan counts for Hub Pages. All data is anonymized and cannot be used to identify you personally.

2. Offline Secure Mode
When "Offline Secure Mode" is enabled in the settings, QRX Pro will not make any network calls. Features like URL safety analysis will be disabled to ensure your complete privacy.

3. Data Storage
All your data, including scan history and created QR codes, is stored locally on your device. We do not have access to this data.

4. Third-Party Services
This app may use third-party services for features like URL safety analysis (e.g., Google Safe Browsing API). These services have their own privacy policies.

5. Changes to This Privacy Policy
We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page.

6. Contact Us
If you have any questions about this Privacy Policy, please contact us.
          '''),
      ),
    );
  }
}
