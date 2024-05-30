package sams.android.qrscanner.ui.theme

import android.app.Activity
import android.os.Build
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.dynamicDarkColorScheme
import androidx.compose.material3.dynamicLightColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.SideEffect
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.toArgb
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.LocalView
import androidx.core.view.WindowCompat

// Define your colors here
private val PrimaryColor = Color(0xFFF19C79)
private val BackgroundLightColor = Color(0xFFF6F4D2)
private val AccentColor = Color(0xFFD4E09B)
private val OnPrimaryColor = Color.White
private val OnBackgroundColor = Color.Black
private val OnAccentColor = Color.Black

private val LightColorScheme = lightColorScheme(
    primary = PrimaryColor,
    onPrimary = OnPrimaryColor,
    primaryContainer = PrimaryColor,
    onPrimaryContainer = OnPrimaryColor,
    secondary = AccentColor,
    onSecondary = OnAccentColor,
    secondaryContainer = AccentColor,
    onSecondaryContainer = OnAccentColor,
    background = BackgroundLightColor,
    onBackground = OnBackgroundColor,
    surface = BackgroundLightColor,
    onSurface = OnBackgroundColor,
    error = Color.Red,
    onError = Color.White
)

@Composable
fun QRScannerTheme(
    content: @Composable () -> Unit
) {
    MaterialTheme(
        colorScheme = LightColorScheme,
        typography = Typography,  // Ensure this references the Typography object from Typography.kt
        content = content
    )
}
