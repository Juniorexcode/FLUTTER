/// Represents a single navigation destination.
///
/// Pure data class — belongs in the Domain layer (no UI dependency).
class NavItem {
  final String title;
  final double scrollOffset;

  const NavItem({
    required this.title,
    required this.scrollOffset,
  });
}
