import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> fetchResume(String name) async {
  try {
    final url = Uri.parse('https://expressjs-api-resume-random.onrender.com/resume?name=$name');
    final response = await http.get(url).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      
      // Create a formatted resume string with proportional spacing
      StringBuffer buffer = StringBuffer();
      
      // Header Section (simplified for variable font sizes)
      buffer.writeln('RESUME PROFILE');
      buffer.writeln('═══════════════════════');
      buffer.writeln('\n');
      
      // Personal Information
      buffer.writeln('PERSONAL INFORMATION');
      buffer.writeln('────────────────────');
      buffer.writeln('Name:    ${data['name'] ?? 'Not specified'}');
      buffer.writeln('Phone:   ${data['phone'] ?? 'Not specified'}');
      buffer.writeln('Email:   ${data['email'] ?? 'Not specified'}');
      buffer.writeln('Twitter: ${data['twitter'] ?? 'Not specified'}');
      buffer.writeln('Address: ${data['address'] ?? 'Not specified'}');
      buffer.writeln('\n');
      
      // Summary
      buffer.writeln('PROFESSIONAL SUMMARY');
      buffer.writeln('────────────────────');
      buffer.writeln(wrapText(data['summary'] ?? 'No summary provided.', 60));
      buffer.writeln('\n');
      
      // Skills
      buffer.writeln('TECHNICAL SKILLS');
      buffer.writeln('────────────────────');
      if (data['skills'] != null && data['skills'] is List && data['skills'].isNotEmpty) {
        for (var skill in data['skills']) {
          buffer.writeln('• ${wrapText(skill, 58, indent: 2)}');
        }
      } else {
        buffer.writeln('No skills listed.');
      }
      buffer.writeln('\n');
      
      // Projects
      buffer.writeln('PROJECT EXPERIENCE');
      buffer.writeln('────────────────────');
      if (data['projects'] != null && data['projects'] is List && data['projects'].isNotEmpty) {
        for (var project in data['projects']) {
          buffer.writeln('  • ${project['title'] ?? 'Untitled Project'}');
          buffer.writeln(wrapText(project['description'] ?? 'No description provided.', 58, indent: 4));
          buffer.writeln('    Period: ${project['startDate'] ?? 'N/A'} - ${project['endDate'] ?? 'Present'}');
          buffer.writeln();
        }
      } else {
        buffer.writeln('No projects listed.');
      }
      
      return buffer.toString();
    } else if (response.statusCode == 404) {
      return 'No resume found for "$name". Please check the name and try again.';
    } else {
      return 'Error: Unable to fetch resume (Status code: ${response.statusCode})';
    }
  } catch (e) {
    return 'Error occurred while fetching resume:\n$e';
  }
}

// Helper function to wrap text at specified width
String wrapText(String text, int width, {int indent = 0}) {
  if (text.isEmpty) return '';
  
  final indentStr = ' ' * indent;
  final words = text.split(' ');
  final buffer = StringBuffer(indentStr);
  var currentLineLength = indent;

  for (final word in words) {
    if (currentLineLength + word.length + 1 > width) {
      buffer.writeln();
      buffer.write(indentStr);
      currentLineLength = indent;
    }
    buffer.write('$word ');
    currentLineLength += word.length + 1;
  }

  return buffer.toString();
}