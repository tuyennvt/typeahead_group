class TypeAheadDataGroup<T> {
  final String title;
  final List<T> items;

  const TypeAheadDataGroup({
    required this.title,
    required this.items,
  });

  TypeAheadDataGroup<T> copyWith({
    String? title,
    List<T>? items,
  }) {
    return TypeAheadDataGroup<T>(
      title: title ?? this.title,
      items: items ?? this.items,
    );
  }
}
