import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resume_generator/providers.dart';
import 'package:resume_generator/api_service.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() {
  runApp(const ProviderScope(child: ResumeApp()));
}

class ResumeApp extends StatelessWidget {
  const ResumeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Resume Craft',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4A6BFF),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const ResumeScreen(),
    );
  }
}

class ResumeScreen extends ConsumerStatefulWidget {
  const ResumeScreen({super.key});

  @override
  ConsumerState<ResumeScreen> createState() => _ResumeScreenState();
}

class _ResumeScreenState extends ConsumerState<ResumeScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _loading = false;
  final ScrollController _scrollController = ScrollController();

  Future<void> _generateResume() async {
    if (_nameController.text.isEmpty) return;
    
    setState(() => _loading = true);
    try {
      final resume = await fetchResume(_nameController.text.trim());
      ref.read(resumeTextProvider.notifier).state = resume;
    } catch (e) {
      ref.read(resumeTextProvider.notifier).state = 'Error: $e';
    }
    setState(() => _loading = false);
    
    // Scroll to top after generating resume
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fontSize = ref.watch(fontSizeProvider);
    final fontColor = ref.watch(fontColorProvider);
    final bgColor = ref.watch(bgColorProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('RESUME GENERATOR'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top - 20,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).padding.bottom,
          ),
          child: Column(
            children: [
              // Search Card
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Enter your name',
                          hintText: 'e.g. John Doe',
                          prefixIcon: const Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: _loading ? null : _generateResume,
                          ),
                        ),
                        onSubmitted: (_) => _generateResume(),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'We\'ll fetch your resume details automatically',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Resume Preview Card
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      constraints: BoxConstraints(
                        minHeight: 200,
                        maxHeight: MediaQuery.of(context).size.height * 0.5,
                      ),
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          ref.watch(resumeTextProvider),
                          style: TextStyle(
                            fontSize: fontSize,
                            color: fontColor,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: FloatingActionButton(
                        mini: true,
                        onPressed: _loading ? null : _generateResume,
                        child: _loading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Icon(Icons.autorenew),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Customization Controls
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Customization',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      
                      // Font Size Slider
                      Row(
                        children: [
                          const Icon(Icons.text_fields, size: 20),
                          const SizedBox(width: 8),
                          const Text('Font Size'),
                          const Spacer(),
                          Text('${fontSize.toInt()}'),
                        ],
                      ),
                      Slider(
                        value: fontSize,
                        min: 10,
                        max: 30,
                        divisions: 20,
                        onChanged: (value) {
                          ref.read(fontSizeProvider.notifier).state = value;
                        },
                      ),
                      const SizedBox(height: 8),

                      // Color Pickers
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildColorPickerButton(
                            context,
                            color: fontColor,
                            label: 'Text Color',
                            onColorPicked: (color) {
                              ref.read(fontColorProvider.notifier).state = color;
                            },
                          ),
                          _buildColorPickerButton(
                            context,
                            color: bgColor,
                            label: 'Background',
                            onColorPicked: (color) {
                              ref.read(bgColorProvider.notifier).state = color;
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Reset Button
                      Center(
                        child: TextButton(
                          onPressed: () {
                            ref.read(fontSizeProvider.notifier).state = 16.0;
                            ref.read(fontColorProvider.notifier).state = Colors.black;
                            ref.read(bgColorProvider.notifier).state = Colors.white;
                          },
                          child: const Text('Reset to Default'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColorPickerButton(
    BuildContext context, {
    required Color color,
    required String label,
    required ValueChanged<Color> onColorPicked,
  }) {
    return Column(
      children: [
        Text(label),
        const SizedBox(height: 8),
        InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Choose $label'),
                content: SingleChildScrollView(
                  child: ColorPicker(
                    pickerColor: color,
                    onColorChanged: onColorPicked,
                    showLabel: true,
                    pickerAreaHeightPercent: 0.7,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300),
            ),
          ),
        ),
      ],
    );
  }
}