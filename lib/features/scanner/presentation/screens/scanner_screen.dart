import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
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
  double _zoomScale = 0.0; // State variable for the zoom level

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

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_isProcessing) return;

    final String? rawValue = capture.barcodes.first.rawValue;
    if (rawValue != null && rawValue.isNotEmpty) {
      setState(() => _isProcessing = true);
      _cameraController.stop();

      await context.push('/scan/result', extra: rawValue);

      if (mounted) {
        _cameraController.start();
        setState(() => _isProcessing = false);
      }
    }
  }

  Future<void> _scanFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null || !mounted) return;

    setState(() => _isProcessing = true);

    final BarcodeCapture? capture = await _cameraController.analyzeImage(
      pickedFile.path,
    );

    if (capture != null &&
        capture.barcodes.isNotEmpty &&
        capture.barcodes.first.rawValue != null) {
      final String rawValue = capture.barcodes.first.rawValue!;
      _cameraController.stop();
      // ignore: use_build_context_synchronously
      await context.push('/scan/result', extra: rawValue);
      if (mounted) _cameraController.start();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No QR code found in the selected image.'),
          ),
        );
      }
    }
    if (mounted) setState(() => _isProcessing = false);
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
        centerTitle: false,
        title: const Text('Scan QR Code'),
        actions: [
          IconButton(
            onPressed: _isProcessing ? null : _scanFromGallery,
            icon: const Icon(LucideIcons.image),
            tooltip: 'Scan from Gallery',
          ),
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
          if (_isProcessing)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(child: CircularProgressIndicator()),
            ),
          if (!_isProcessing)
            CustomPaint(painter: ScannerOverlayPainter(scanWindow: scanWindow)),

          // --- NEW: ZOOM SLIDER WIDGET ---
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(LucideIcons.zoomOut, color: Colors.white),
                Expanded(
                  child: Slider(
                    value: _zoomScale,
                    min: 0.0,
                    max: 1.0,
                    activeColor: Colors.white,
                    inactiveColor: Colors.white38,
                    onChanged: (value) {
                      setState(() {
                        _zoomScale = value;
                        _cameraController.setZoomScale(value);
                      });
                    },
                  ),
                ),
                const Icon(LucideIcons.zoomIn, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionRequestUI() {
    // This widget remains unchanged
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
