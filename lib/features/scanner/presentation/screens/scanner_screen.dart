import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qrx_pro/core/di/service_locator.dart';
import 'package:qrx_pro/core/services/permissions/permission_service.dart';
import 'package:qrx_pro/features/home/presentation/widgets/scanner_overlay_painter.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final MobileScannerController _cameraController = MobileScannerController();
  final PermissionService _permissionService = getIt<PermissionService>();

  bool _isPermissionGranted = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _checkAndRequestPermission();
  }

  Future<void> _checkAndRequestPermission() async {
    final hasPermission = await _permissionService.isCameraGranted();
    if (!mounted) return;
    setState(() => _isPermissionGranted = hasPermission);

    if (!hasPermission) {
      final wasGranted = await _permissionService.requestCameraPermission();
      if (!mounted) return;
      setState(() => _isPermissionGranted = wasGranted);
    }
  }

  void _onDetect(BarcodeCapture capture) {
    if (_isProcessing) return;

    final String? rawValue = capture.barcodes.first.rawValue;
    if (rawValue != null && rawValue.isNotEmpty) {
      setState(() => _isProcessing = true);
      _cameraController.stop();
      context.push('/scan/result', extra: rawValue);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route?.isCurrent ?? false) {
      if (_isPermissionGranted) {
        _cameraController.start();
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isPermissionGranted
        ? _buildScannerUI()
        : _buildPermissionRequestUI();
  }

  Widget _buildScannerUI() {
    final scanWindow = Rect.fromCenter(
      center: MediaQuery.of(context).size.center(Offset.zero),
      width: 250,
      height: 250,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        actions: [
          ValueListenableBuilder(
            valueListenable: _cameraController,
            builder: (context, state, child) {
              return IconButton(
                onPressed: () => _cameraController.toggleTorch(),
                icon: state.torchState == TorchState.on
                    ? const Icon(LucideIcons.zap, color: Colors.yellow)
                    : const Icon(LucideIcons.zapOff, color: Colors.grey),
              );
            },
          ),
          IconButton(
            onPressed: () => _cameraController.switchCamera(),
            icon: const Icon(LucideIcons.rotateCw),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            controller: _cameraController,
            scanWindow: scanWindow,
            onDetect: _onDetect,
          ),
          CustomPaint(painter: ScannerOverlayPainter(scanWindow: scanWindow)),
        ],
      ),
    );
  }

  Widget _buildPermissionRequestUI() {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR Code')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(LucideIcons.cameraOff, size: 60),
              const SizedBox(height: 20),
              const Text(
                'Camera Permission Required',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'To scan QR codes, please grant camera access.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: _checkAndRequestPermission,
                icon: const Icon(LucideIcons.shieldCheck),
                label: const Text('Grant Permission'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
