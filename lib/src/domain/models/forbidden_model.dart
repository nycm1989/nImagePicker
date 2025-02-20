class ForbiddenModel {
  static final List<String> _forbidden_hex = ["39", "37", "38", "30", "62", "69", "74", "63", "6f", "69", "6e"];

  @override
  String toString() {
    List<int> charCodes = _forbidden_hex.map((hex) => int.parse(hex, radix: 16)).toList();
    return String.fromCharCodes(charCodes);
  }
}