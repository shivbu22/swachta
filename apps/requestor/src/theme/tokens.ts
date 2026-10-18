/**
 * Swachta Design Tokens
 * Reverse-engineered strictly from swachta ui/design.md
 */

export const TOKENS = {
  brand: {
    primary: '#4A7C3F',       // Mid green: Primary CTAs, active nav, progress bars
    dark: '#1D4E1A',          // Dark green: Header curves, dark panels, bold headings
    deepForest: '#0F2E0D',    // Deep forest: Darkest splash panels
    lightGreen: '#E8F5E9',    // Light mint fill for chips and icon backgrounds
  },
  surface: {
    bg: '#F3FAF3',           // Very pale mint app background
    card: '#FFFFFF',         // Crisp white card surfaces
    cardAlt: '#F8FAF8',      // Slightly tinted card surface
    darkCard: '#1D4E1A',     // Dark green card
    modalOverlay: 'rgba(15, 46, 13, 0.6)',
  },
  text: {
    primary: '#1F2A20',      // Near black-green headlines & body text
    secondary: '#6B7A6D',    // Muted grey-green helper/caption text
    onBrand: '#FFFFFF',      // White text for filled green buttons & dark panels
    muted: '#94A3B8',        // Border/neutral muted
  },
  accent: {
    success: '#4A7C3F',      // Verified checkmark circle, high confidence badges
    danger: '#E5484D',       // Soft red: Delete scrap item, delete account
    info: '#3B82F6',         // Blue: Info banners & tips ONLY
    gold: '#C9A227',         // Muted gold: Tree planting promo card only
  },
  border: {
    default: '#DCE7DC',      // Thin card hairlines, input borders
    focused: '#4A7C3F',      // Active input and selected chip borders
    subtle: '#E2E8F0',
  },
  radius: {
    sm: 8,
    md: 12,
    card: 18,
    button: 28,              // Full pill radius for CTAs
    pill: 999,
  },
  spacing: {
    xs: 4,
    sm: 8,
    md: 12,
    lg: 16,
    xl: 20,
    xxl: 24,
    xxxl: 32,
  }
};
