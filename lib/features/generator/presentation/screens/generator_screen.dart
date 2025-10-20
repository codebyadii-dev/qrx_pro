import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

// --- Data Models (from Step 1) ---
enum QrGenType { text, wifi, phone, email, sms, geo, vcard }

const Map<QrGenType, Map<String, dynamic>> qrGenTypeDetails = {
  QrGenType.text: {'icon': LucideIcons.text, 'label': 'Text/URL'},
  QrGenType.wifi: {'icon': LucideIcons.wifi, 'label': 'WiFi'},
  QrGenType.phone: {'icon': LucideIcons.phone, 'label': 'Phone'},
  QrGenType.email: {'icon': LucideIcons.mail, 'label': 'Email'},
  QrGenType.sms: {'icon': LucideIcons.messageSquare, 'label': 'SMS'},
  QrGenType.geo: {'icon': LucideIcons.mapPin, 'label': 'Location'},
  QrGenType.vcard: {'icon': LucideIcons.contact, 'label': 'Contact'},
};
// ------------------------------------

class GeneratorScreen extends StatefulWidget {
  const GeneratorScreen({super.key});

  @override
  State<GeneratorScreen> createState() => _GeneratorScreenState();
}

class _GeneratorScreenState extends State<GeneratorScreen> {
  // State for the currently selected QR type
  QrGenType _selectedType = QrGenType.text;

  // --- Controllers (Added vCard fields) ---
  final _textController = TextEditingController();
  final _wifiSsidController = TextEditingController();
  final _wifiPasswordController = TextEditingController();
  String _wifiEncryption = 'WPA';
  final _phoneController = TextEditingController();
  final _emailToController = TextEditingController();
  final _emailSubjectController = TextEditingController();
  final _emailBodyController = TextEditingController();
  final _smsPhoneController = TextEditingController();
  final _smsMessageController = TextEditingController();
  final _geoLatController = TextEditingController();
  final _geoLonController = TextEditingController();
  final _vcardFirstNameController = TextEditingController();
  final _vcardLastNameController = TextEditingController();
  final _vcardPhoneController = TextEditingController();
  final _vcardEmailController = TextEditingController();
  final _vcardOrgController = TextEditingController();
  final _vcardTitleController = TextEditingController();
  final _vcardStreetController = TextEditingController();
  final _vcardCityController = TextEditingController();
  final _vcardZipController = TextEditingController();
  final _vcardCountryController = TextEditingController();
  final _vcardWebsiteController = TextEditingController();
  // ------------------------------------

  @override
  void dispose() {
    _textController.dispose();
    _wifiSsidController.dispose();
    _wifiPasswordController.dispose();
    _phoneController.dispose();
    _emailToController.dispose();
    _emailSubjectController.dispose();
    _emailBodyController.dispose();
    _smsPhoneController.dispose();
    _smsMessageController.dispose();
    _geoLatController.dispose();
    _geoLonController.dispose();
    _vcardFirstNameController.dispose();
    _vcardLastNameController.dispose();
    _vcardPhoneController.dispose();
    _vcardEmailController.dispose();
    _vcardOrgController.dispose();
    _vcardTitleController.dispose();
    _vcardStreetController.dispose();
    _vcardCityController.dispose();
    _vcardZipController.dispose();
    _vcardCountryController.dispose();
    _vcardWebsiteController.dispose();
    super.dispose();
  }

  // Logic to format the data based on the selected type

  String _getFormattedData() {
    switch (_selectedType) {
      case QrGenType.wifi:
        return 'WIFI:S:${_wifiSsidController.text};T:$_wifiEncryption;P:${_wifiPasswordController.text};;';
      case QrGenType.phone:
        return 'tel:${_phoneController.text}';
      case QrGenType.email:
        return 'mailto:${_emailToController.text}?subject=${_emailSubjectController.text}&body=${_emailBodyController.text}';
      case QrGenType.sms:
        return 'smsto:${_smsPhoneController.text}:${_smsMessageController.text}';
      case QrGenType.geo:
        return 'geo:${_geoLatController.text},${_geoLonController.text}';
      case QrGenType.vcard: // <-- Added vcard formatting
        return '''BEGIN:VCARD
VERSION:3.0
FN:${_vcardFirstNameController.text} ${_vcardLastNameController.text}
N:${_vcardLastNameController.text};${_vcardFirstNameController.text};;;
TEL;TYPE=CELL:${_vcardPhoneController.text}
EMAIL:${_vcardEmailController.text}
ORG:${_vcardOrgController.text}
TITLE:${_vcardTitleController.text}
ADR;TYPE=WORK:;;${_vcardStreetController.text};${_vcardCityController.text};;${_vcardZipController.text};${_vcardCountryController.text}
URL:${_vcardWebsiteController.text}
END:VCARD''';
      case QrGenType.text:
        return _textController.text;
    }
  }

  void _onPreview() {
    final formattedData = _getFormattedData().trim();
    // Basic validation for vCard (at least a name is needed)
    if (_selectedType == QrGenType.vcard &&
        _vcardFirstNameController.text.isEmpty &&
        _vcardLastNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter at least a first or last name for the contact.',
          ),
        ),
      );
      return;
    }
    if (formattedData.isNotEmpty &&
        formattedData !=
            'BEGIN:VCARD\nVERSION:3.0\nFN: \nN:;;;;\nTEL;TYPE=CELL:\nEMAIL:\nORG:\nTITLE:\nADR;TYPE=WORK:;;;;;;\nURL:\nEND:VCARD') {
      // Avoid empty vCard
      context.push('/generator/preview', extra: formattedData);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in the required fields.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create QR Code')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildTypeSelector(),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          _buildInputForm(), // This will show the correct form
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _onPreview,
            icon: const Icon(LucideIcons.eye),
            label: const Text('Preview & Style'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
          const SizedBox(height: 24),
          Card(
            child: ListTile(
              onTap: () => context.push('/generator/batch'),
              leading: const Icon(LucideIcons.binary),
              title: const Text('Batch Generate from CSV'),
              subtitle: const Text('Create multiple QR codes at once'),
              trailing: const Icon(LucideIcons.chevronRight),
            ),
          ),
        ],
      ),
    );
  }

  // --- UI BUILDER METHODS ---

  Widget _buildTypeSelector() {
    return SizedBox(
      height: 90,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          mainAxisSpacing: 12,
        ),
        itemCount: qrGenTypeDetails.length,
        itemBuilder: (context, index) {
          final type = QrGenType.values[index];
          final details = qrGenTypeDetails[type]!;
          final isSelected = _selectedType == type;
          return GestureDetector(
            onTap: () => setState(() => _selectedType = type),
            child: Card(
              color: isSelected
                  ? Theme.of(context).colorScheme.primaryContainer
                  : null,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    details['icon'],
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    details['label'],
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputForm() {
    switch (_selectedType) {
      case QrGenType.wifi:
        return _buildWifiForm();
      case QrGenType.phone:
        return _buildPhoneForm();
      case QrGenType.email:
        return _buildEmailForm();
      case QrGenType.sms:
        return _buildSmsForm();
      case QrGenType.geo:
        return _buildGeoForm();
      case QrGenType.vcard:
        return _buildVCardForm();
      case QrGenType.text:
        return _buildTextForm();
    }
  }

  // --- SPECIFIC FORM WIDGETS ---

  Widget _buildTextForm() => _buildTextField(
    controller: _textController,
    label: 'Text / URL',
    icon: LucideIcons.text,
    maxLines: 5,
  );
  Widget _buildPhoneForm() => _buildTextField(
    controller: _phoneController,
    label: 'Phone Number',
    icon: LucideIcons.phone,
    keyboardType: TextInputType.phone,
  );
  Widget _buildSmsForm() => Column(
    children: [
      _buildTextField(
        controller: _smsPhoneController,
        label: 'Phone Number',
        icon: LucideIcons.phone,
        keyboardType: TextInputType.phone,
      ),
      const SizedBox(height: 16),
      _buildTextField(
        controller: _smsMessageController,
        label: 'Message',
        icon: LucideIcons.messageSquare,
        maxLines: 3,
      ),
    ],
  );
  Widget _buildGeoForm() => Row(
    children: [
      Expanded(
        child: _buildTextField(
          controller: _geoLatController,
          label: 'Latitude',
          icon: LucideIcons.arrowUp,
          keyboardType: TextInputType.number,
        ),
      ),
      const SizedBox(width: 16),
      Expanded(
        child: _buildTextField(
          controller: _geoLonController,
          label: 'Longitude',
          icon: LucideIcons.arrowRight,
          keyboardType: TextInputType.number,
        ),
      ),
    ],
  );
  Widget _buildEmailForm() => Column(
    children: [
      _buildTextField(
        controller: _emailToController,
        label: 'To',
        icon: LucideIcons.user,
        keyboardType: TextInputType.emailAddress,
      ),
      const SizedBox(height: 16),
      _buildTextField(
        controller: _emailSubjectController,
        label: 'Subject',
        icon: LucideIcons.type,
      ),
      const SizedBox(height: 16),
      _buildTextField(
        controller: _emailBodyController,
        label: 'Body',
        icon: LucideIcons.fileText,
        maxLines: 4,
      ),
    ],
  );
  Widget _buildWifiForm() => Column(
    children: [
      _buildTextField(
        controller: _wifiSsidController,
        label: 'Network Name (SSID)',
        icon: LucideIcons.signal,
      ),
      const SizedBox(height: 16),
      _buildTextField(
        controller: _wifiPasswordController,
        label: 'Password',
        icon: LucideIcons.lock,
      ),
      const SizedBox(height: 16),
      DropdownButtonFormField<String>(
        value: _wifiEncryption,
        decoration: InputDecoration(
          labelText: 'Encryption',
          prefixIcon: const Icon(LucideIcons.shield),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
        ),
        items: ['WPA', 'WEP', 'nopass']
            .map(
              (String value) =>
                  DropdownMenuItem<String>(value: value, child: Text(value)),
            )
            .toList(),
        onChanged: (String? newValue) =>
            setState(() => _wifiEncryption = newValue!),
      ),
    ],
  );

  // --- NEW vCard Form Widget ---
  Widget _buildVCardForm() => Column(
    children: [
      Row(
        children: [
          Expanded(
            child: _buildTextField(
              controller: _vcardFirstNameController,
              label: 'First Name',
              icon: LucideIcons.user,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildTextField(
              controller: _vcardLastNameController,
              label: 'Last Name',
              icon: LucideIcons.user,
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      _buildTextField(
        controller: _vcardPhoneController,
        label: 'Phone',
        icon: LucideIcons.phone,
        keyboardType: TextInputType.phone,
      ),
      const SizedBox(height: 16),
      _buildTextField(
        controller: _vcardEmailController,
        label: 'Email',
        icon: LucideIcons.mail,
        keyboardType: TextInputType.emailAddress,
      ),
      const SizedBox(height: 16),
      Row(
        children: [
          Expanded(
            child: _buildTextField(
              controller: _vcardOrgController,
              label: 'Organization',
              icon: LucideIcons.building,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildTextField(
              controller: _vcardTitleController,
              label: 'Job Title',
              icon: LucideIcons.briefcase,
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      _buildTextField(
        controller: _vcardStreetController,
        label: 'Street Address',
        icon: LucideIcons.mapPin,
      ),
      const SizedBox(height: 16),
      Row(
        children: [
          Expanded(
            child: _buildTextField(
              controller: _vcardCityController,
              label: 'City',
              icon: LucideIcons.mapPin,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildTextField(
              controller: _vcardZipController,
              label: 'ZIP Code',
              icon: LucideIcons.mapPin,
              keyboardType: TextInputType.number,
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      _buildTextField(
        controller: _vcardCountryController,
        label: 'Country',
        icon: LucideIcons.mapPin,
      ),
      const SizedBox(height: 16),
      _buildTextField(
        controller: _vcardWebsiteController,
        label: 'Website',
        icon: LucideIcons.globe,
        keyboardType: TextInputType.url,
      ),
    ],
  );
  // -----------------------------

  // Generic text field helper
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );
  }
}
