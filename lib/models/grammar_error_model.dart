class GrammarIssue {
  final String type;
  final String message;
  final String suggestion;

  GrammarIssue({
    required this.type,
    required this.message,
    required this.suggestion,
  });

  factory GrammarIssue.fromJson(Map<String, dynamic> json) {
    return GrammarIssue(
      type: (json['rule']['issueType'] ?? 'Grammar').toString().toUpperCase(),
      message: json['message'] ?? 'Unknown error.',
      suggestion: (json['replacements'] != null && json['replacements'].isNotEmpty)
          ? json['replacements'][0]['value']
          : 'No suggestion',
    );
  }
}