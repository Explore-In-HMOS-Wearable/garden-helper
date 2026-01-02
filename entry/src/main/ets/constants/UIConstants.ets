// ===== COLOR PALETTE =====

export class ThemedColors {
  // Backgrounds
  static readonly BACKGROUND = '#000000';          // Pure black (OLED optimization)
  static readonly CARD = '#1A1A1A';                // Dark card background
  static readonly CARD_ELEVATED = '#2A2A2A';       // Slightly elevated cards
  static readonly PLANT_CARD_EMERALD = '#124338';  // Dark emerald

  // Text
  static readonly TEXT_PRIMARY = '#FFFFFF';        // Primary text
  static readonly TEXT_SECONDARY = '#CCCCCC';      // Secondary text
  static readonly TEXT_TERTIARY = '#999999';       // Tertiary text
  static readonly TEXT_DISABLED = '#666666';       // Disabled text

  // Plant Status Colors (Primary Feature)
  static readonly STATUS_HEALTHY = '#00C851';      // Vibrant green
  static readonly STATUS_DUE_SOON = '#FFB300';     // Amber
  static readonly STATUS_OVERDUE = '#FF3547';      // Red
  static readonly STATUS_JUST_WATERED = '#00E676'; // Bright green

  // Accent Colors (Garden Theme)
  static readonly ACCENT_PRIMARY = '#4CAF50';      // Material green
  static readonly ACCENT_SECONDARY = '#8BC34A';    // Light green
  static readonly ACCENT_EARTH = '#795548';        // Brown
  static readonly ACCENT_WATER = '#2196F3';        // Blue

  // Semantic Colors
  static readonly SUCCESS = '#00C851';             // Success actions
  static readonly WARNING = '#FFB300';             // Warning states
  static readonly ERROR = '#FF3547';               // Error/critical
  static readonly INFO = '#2196F3';                // Informational

  // UI Elements
  static readonly BORDER = '#333333';              // Borders and dividers
  static readonly BORDER_LIGHT = '#444444';        // Lighter borders
  static readonly FOCUS = '#4CAF50';               // Focus indicator
  static readonly OVERLAY = 'rgba(0, 0, 0, 0.6)';  // Modal overlays

  // Interactive States
  static readonly BUTTON_PRIMARY = '#4CAF50';      // Primary action button
  static readonly BUTTON_SECONDARY = '#2A2A2A';    // Secondary button
  static readonly BUTTON_DANGER = '#FF3547';       // Destructive actions
  static readonly BUTTON_DISABLED = '#1A1A1A';     // Disabled button

  // Utility
  static readonly TRANSPARENT = 'transparent';
}

// ===== TYPOGRAPHY =====

export class ThemedFonts {
  // Font Sizes
  static readonly SIZE_HERO = 36;                  // Hero text
  static readonly SIZE_TITLE_LARGE = 24;           // Large titles
  static readonly SIZE_TITLE = 18;                 // Standard titles
  static readonly SIZE_BODY_LARGE = 16;            // Large body text
  static readonly SIZE_BODY = 14;                  // Standard body text
  static readonly SIZE_CAPTION = 12;               // Captions, labels
  static readonly SIZE_SMALL = 10;                 // Very small text
  static readonly SIZE_ICON = 32;                  // Emoji icons

  // Font Weights
  static readonly WEIGHT_LIGHT = FontWeight.Lighter;
  static readonly WEIGHT_REGULAR = FontWeight.Normal;
  static readonly WEIGHT_MEDIUM = FontWeight.Medium;
  static readonly WEIGHT_BOLD = FontWeight.Bold;
}

// ===== LAYOUT & SPACING =====

export class ThemedLayout {
  // Card Dimensions
  static readonly CARD_HEIGHT = 180;               // Standard card height
  static readonly CARD_HEIGHT_COMPACT = 140;       // Compact card
  static readonly CARD_HEIGHT_LARGE = 220;         // Large card
  static readonly CARD_HEIGHT_FULL = '100%';       // Full height card

  // Padding
  static readonly PADDING_NONE = 0;
  static readonly PADDING_XS = 4;
  static readonly PADDING_SM = 8;
  static readonly PADDING_MD = 12;
  static readonly PADDING_LG = 16;
  static readonly PADDING_XL = 20;
  static readonly PADDING_XXL = 24;

  // Margins
  static readonly MARGIN_XS = 4;
  static readonly MARGIN_SM = 8;
  static readonly MARGIN_MD = 12;
  static readonly MARGIN_LG = 16;
  static readonly MARGIN_XL = 20;

  // Spacing between elements
  static readonly SPACING_NONE = 0;
  static readonly SPACING_XS = 4;
  static readonly SPACING_SM = 8;
  static readonly SPACING_MD = 12;
  static readonly SPACING_LG = 16;
  static readonly SPACING_XL = 20;
  static readonly SPACING_XXL = 24;

  // Border Radius
  static readonly RADIUS_NONE = 0;
  static readonly RADIUS_SM = 8;
  static readonly RADIUS_MD = 12;
  static readonly RADIUS_LG = 16;
  static readonly RADIUS_XL = 20;
  static readonly RADIUS_CIRCLE = 50;

  // Icon Sizes
  static readonly ICON_XS = 16;
  static readonly ICON_SM = 20;
  static readonly ICON_MD = 24;
  static readonly ICON_LG = 32;
  static readonly ICON_XL = 48;
  static readonly ICON_XXL = 64;

  // Button Dimensions
  static readonly BUTTON_HEIGHT_SM = 36;
  static readonly BUTTON_HEIGHT_MD = 44;
  static readonly BUTTON_HEIGHT_LG = 56;
  static readonly BUTTON_PADDING_HORIZONTAL = 20;
  static readonly BUTTON_PADDING_VERTICAL = 12;

  // Status Indicator
  static readonly STATUS_DOT_SM = 12;
  static readonly STATUS_DOT_LG = 16;

  // Touch Targets (Wearable Optimized)
  static readonly TOUCH_TARGET_MIN = 44;
  static readonly TOUCH_TARGET_COMFORTABLE = 60;
}

// ===== HELPER FUNCTIONS =====
export class ThemedUIHelpers {
  static getStatusColor(status: 'healthy' | 'due_soon' | 'overdue' | 'just_watered'): string {
    switch (status) {
      case 'healthy':
        return ThemedColors.STATUS_HEALTHY;
      case 'due_soon':
        return ThemedColors.STATUS_DUE_SOON;
      case 'overdue':
        return ThemedColors.STATUS_OVERDUE;
      case 'just_watered':
        return ThemedColors.STATUS_JUST_WATERED;
      default:
        return ThemedColors.TEXT_SECONDARY;
    }
  }

  static getSemanticColor(type: 'success' | 'warning' | 'error' | 'info'): string {
    switch (type) {
      case 'success':
        return ThemedColors.SUCCESS;
      case 'warning':
        return ThemedColors.WARNING;
      case 'error':
        return ThemedColors.ERROR;
      case 'info':
        return ThemedColors.INFO;
      default:
        return ThemedColors.TEXT_PRIMARY;
    }
  }
}
