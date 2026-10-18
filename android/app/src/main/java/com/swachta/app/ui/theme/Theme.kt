package com.swachta.app.ui.theme

import android.app.Activity
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.SideEffect
import androidx.compose.ui.graphics.toArgb
import androidx.compose.ui.platform.LocalView
import androidx.core.view.WindowCompat

private val SwachtaColorScheme = lightColorScheme(
    primary = BrandPrimary,
    onPrimary = TextOnBrand,
    primaryContainer = GreenLight,
    onPrimaryContainer = BrandDark,
    secondary = BrandDark,
    onSecondary = TextOnBrand,
    secondaryContainer = GreenPale,
    onSecondaryContainer = TextPrimary,
    background = SurfaceBg,
    onBackground = TextPrimary,
    surface = SurfaceCard,
    onSurface = TextPrimary,
    surfaceVariant = GreenPale,
    onSurfaceVariant = TextSecondary,
    outline = BorderDefault,
    error = AccentDanger,
    onError = TextOnBrand,
)

@Composable
fun SwachtaTheme(
    content: @Composable () -> Unit
) {
    val view = LocalView.current
    if (!view.isInEditMode) {
        SideEffect {
            val window = (view.context as Activity).window
            window.statusBarColor = SurfaceBg.toArgb()
            WindowCompat.getInsetsController(window, view).isAppearanceLightStatusBars = true
        }
    }

    MaterialTheme(
        colorScheme = SwachtaColorScheme,
        typography = SwachtaTypography,
        content = content
    )
}
