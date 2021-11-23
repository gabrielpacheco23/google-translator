String? describeEnum(Object? object) {
  if (object != null) {
    final nameParts = object.toString().split(".");
    if (nameParts.isNotEmpty && nameParts.length == 2) return nameParts[1];
  }
  return null;
}
