class Magazine {
  const Magazine({
    required this.id,
    required this.assetImage,
    required this.tags,
  });

  final String id;
  final String assetImage;
  final String tags;
  static final List<Magazine> fakeMagazinesValues = List.generate(
    3,
    (index) => Magazine(
      id: '$index',
      assetImage: 'assets/poster/season_${index + 1}.webp',
      tags:"S0${index + 1}",
    ),
  );
}
