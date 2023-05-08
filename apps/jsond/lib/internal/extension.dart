extension StringExtension on String {
  String unicodeToRawString() {
    const regex = r'\u';
    String content = this;
    int offset = content.indexOf(regex) + regex.length;
    while (offset > 1) {
      final str = content.substring(offset, offset + 4);
      if (str.isNotEmpty) {
        final uni = String.fromCharCode(int.parse(str, radix: 16));
        content = content.replaceFirst(regex + str, uni);
      }
      offset = content.indexOf(regex) + regex.length;
    }
    return content;
  }
}
