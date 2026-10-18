import 'dart:ui';

class AppColors {
  AppColors._();

  // Primary Eco Palette
  static const Color primaryGreen = Color(0xFF52B788);
  static const Color deepForest = Color(0xFF1A3D2B);
  static const Color lightLeaf = Color(0xFFD8F3DC);
  static const Color mintGlow = Color(0xFF52B788);
  static const Color neonGreen = Color(0xFF6FCF97);
  static const Color emerald = Color(0xFF2D6A4F);

  // Dark Mode Surfaces
  static const Color darkBackground = Color(0xFF05100B);
  static const Color darkSurface = Color(0xFF0D1F17);
  static const Color darkCard = Color(0xFF092015);
  static const Color darkCardHover = Color(0xFF12281D);
  static const Color darkBorder = Color(0x3052B788);
  static const Color sidebarBg = Color(0xFF05100B);

  // Glassmorphism
  static const Color glassWhite = Color(0x15FFFFFF);
  static const Color glassGreen = Color(0x1552B788);
  static const Color glassBorder = Color(0x3052B788);

  // Status Colors
  static const Color statusOnline = Color(0xFF00C853);
  static const Color statusOnJob = Color(0xFF2196F3);
  static const Color statusBreak = Color(0xFFFFB300);
  static const Color statusOffline = Color(0xFF757575);

  // Job Type Colors
  static const Color jobPickup = Color(0xFF00C853);
  static const Color jobSorting = Color(0xFF2196F3);
  static const Color jobTransport = Color(0xFFFFB300);
  static const Color jobIdle = Color(0xFFFF5252);

  // Semantic Colors
  static const Color warningAmber = Color(0xFFFFB300);
  static const Color errorRed = Color(0xFFFF5252);
  static const Color successGreen = Color(0xFF00E676);
  static const Color infoCyan = Color(0xFF00BCD4);

  // Text Colors
  static const Color textPrimary = Color(0xFFE8E8E8);
  static const Color textSecondary = Color(0xFF9E9E9E);
  static const Color textMuted = Color(0xFF6B6B6B);
  static const Color textOnGreen = Color(0xFFFFFFFF);

  // Chart Colors  
  static const Color chartPlastic = Color(0xFF00C853);
  static const Color chartMetal = Color(0xFF2196F3);
  static const Color chartOrganic = Color(0xFFFF9800);
  static const Color chartEwaste = Color(0xFFE040FB);
  static const Color chartGlass = Color(0xFF00BCD4);

  // Gradients
  static const List<Color> primaryGradient = [
    Color(0xFF2D6A4F),
    Color(0xFF52B788),
  ];

  static const List<Color> darkGradient = [
    Color(0xFF05100B),
    Color(0xFF0D1F17),
  ];

  static const List<Color> cardGradient = [
    Color(0xFF162618),
    Color(0xFF1C3020),
  ];

  static const List<Color> revenueGradient = [
    Color(0xFFFFB300),
    Color(0xFFFF8F00),
  ];
}
