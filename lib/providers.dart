import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fontSizeProvider = StateProvider<double>((ref) => 16.0);
final fontColorProvider = StateProvider<Color>((ref) => Colors.black);
final bgColorProvider = StateProvider<Color>((ref) => Colors.white);
final resumeTextProvider = StateProvider<String>((ref) => 
  'Enter your name to generate a professional resume\n\n'
  'Your resume will appear here with:\n'
  '- Personal details\n'
  '- Skills\n'
  '- Projects\n'
  '- And more!');