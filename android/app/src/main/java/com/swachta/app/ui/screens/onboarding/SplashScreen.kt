package com.swachta.app.ui.screens.onboarding

import androidx.compose.animation.core.*
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Text
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.scale
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import com.swachta.app.navigation.Screen
import com.swachta.app.ui.theme.*
import kotlinx.coroutines.delay
import androidx.compose.foundation.Canvas
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.Path
import androidx.compose.ui.graphics.drawscope.DrawScope
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.graphics.StrokeCap
import androidx.compose.ui.graphics.StrokeJoin

@Composable
fun SplashScreen(navController: NavController) {
    val scale = remember { Animatable(0.6f) }
    val loaderWidth = remember { Animatable(0f) }

    LaunchedEffect(Unit) {
        scale.animateTo(
            1f,
            animationSpec = spring(dampingRatio = Spring.DampingRatioMediumBouncy)
        )
        delay(400)
        loaderWidth.animateTo(
            1f,
            animationSpec = tween(durationMillis = 1500, easing = EaseInOutCubic)
        )
        delay(200)
        navController.navigate(Screen.Onboarding.route) {
            popUpTo(Screen.Splash.route) { inclusive = true }
        }
    }

    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(SurfaceBg),
        contentAlignment = Alignment.Center
    ) {
        // Decorative leaf circles
        Box(
            modifier = Modifier
                .size(280.dp)
                .align(Alignment.TopEnd)
                .offset(x = 80.dp, y = (-40).dp)
                .clip(RoundedCornerShape(50))
                .background(GreenLight.copy(alpha = 0.4f))
        )
        Box(
            modifier = Modifier
                .size(160.dp)
                .align(Alignment.BottomStart)
                .offset(x = (-40).dp, y = 40.dp)
                .clip(RoundedCornerShape(50))
                .background(GreenPale.copy(alpha = 0.6f))
        )

        Column(
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center
        ) {
            // Logo truck illustration
            Box(
                modifier = Modifier
                    .scale(scale.value)
                    .size(200.dp),
                contentAlignment = Alignment.Center
            ) {
                val context = androidx.compose.ui.platform.LocalContext.current
                val logoId = remember {
                    context.resources.getIdentifier("logo", "drawable", context.packageName)
                }
                if (logoId != 0) {
                    androidx.compose.foundation.Image(
                        painter = androidx.compose.ui.res.painterResource(id = logoId),
                        contentDescription = "Swachta Logo",
                        modifier = Modifier.fillMaxSize()
                    )
                } else {
                    Canvas(modifier = Modifier.fillMaxSize()) {
                        drawSwachtaTruck(this)
                    }
                }
            }

            Spacer(modifier = Modifier.height(24.dp))

            Text(
                text = "SWACHTA",
                fontSize = 36.sp,
                fontWeight = FontWeight.ExtraBold,
                color = BrandDark,
                letterSpacing = 4.sp
            )

            Spacer(modifier = Modifier.height(8.dp))

            Text(
                text = "Saaf Sheher. Sahi Daam.",
                fontSize = 14.sp,
                color = TextSecondary,
                textAlign = TextAlign.Center
            )

            Spacer(modifier = Modifier.height(40.dp))

            // Loading bar
            Box(
                modifier = Modifier
                    .width(160.dp)
                    .height(4.dp)
                    .clip(RoundedCornerShape(2.dp))
                    .background(BorderDefault)
            ) {
                Box(
                    modifier = Modifier
                        .fillMaxHeight()
                        .fillMaxWidth(loaderWidth.value)
                        .clip(RoundedCornerShape(2.dp))
                        .background(
                            Brush.horizontalGradient(
                                listOf(BrandPrimary, BrandDark)
                            )
                        )
                )
            }
        }
    }
}

private fun drawSwachtaTruck(scope: DrawScope) {
    val w = scope.size.width
    val h = scope.size.height
    val cx = w / 2f
    val cy = h / 2f

    // Outer circle
    scope.drawCircle(
        color = Color(0xFFDCE7DC),
        radius = w * 0.45f,
        center = androidx.compose.ui.geometry.Offset(cx, cy),
        style = Stroke(width = 2.dp.value)
    )

    // Truck body
    val bodyLeft = cx - w * 0.25f
    val bodyTop = cy - h * 0.05f
    val bodyRight = cx + w * 0.30f
    val bodyBottom = cy + h * 0.22f
    scope.drawRoundRect(
        color = Color(0xFF2E7D32),
        topLeft = androidx.compose.ui.geometry.Offset(bodyLeft, bodyTop),
        size = androidx.compose.ui.geometry.Size(bodyRight - bodyLeft, bodyBottom - bodyTop),
        cornerRadius = androidx.compose.ui.geometry.CornerRadius(8.dp.value)
    )

    // Cab
    scope.drawRoundRect(
        color = Color(0xFF1B5E20),
        topLeft = androidx.compose.ui.geometry.Offset(cx + w * 0.12f, cy - h * 0.12f),
        size = androidx.compose.ui.geometry.Size(w * 0.22f, h * 0.34f),
        cornerRadius = androidx.compose.ui.geometry.CornerRadius(6.dp.value)
    )

    // Window
    scope.drawRoundRect(
        color = Color(0xFFA5D6A7),
        topLeft = androidx.compose.ui.geometry.Offset(cx + w * 0.15f, cy - h * 0.09f),
        size = androidx.compose.ui.geometry.Size(w * 0.13f, h * 0.12f),
        cornerRadius = androidx.compose.ui.geometry.CornerRadius(4.dp.value)
    )

    // Wheels
    scope.drawCircle(
        color = Color(0xFF333333),
        radius = w * 0.075f,
        center = androidx.compose.ui.geometry.Offset(cx - w * 0.08f, cy + h * 0.27f)
    )
    scope.drawCircle(
        color = Color(0xFF666666),
        radius = w * 0.03f,
        center = androidx.compose.ui.geometry.Offset(cx - w * 0.08f, cy + h * 0.27f)
    )
    scope.drawCircle(
        color = Color(0xFF333333),
        radius = w * 0.075f,
        center = androidx.compose.ui.geometry.Offset(cx + w * 0.23f, cy + h * 0.27f)
    )
    scope.drawCircle(
        color = Color(0xFF666666),
        radius = w * 0.03f,
        center = androidx.compose.ui.geometry.Offset(cx + w * 0.23f, cy + h * 0.27f)
    )

    // Garbage items (leaves floating)
    scope.drawRoundRect(
        color = Color(0xFF66BB6A),
        topLeft = androidx.compose.ui.geometry.Offset(cx - w * 0.2f, cy - h * 0.2f),
        size = androidx.compose.ui.geometry.Size(w * 0.07f, h * 0.08f),
        cornerRadius = androidx.compose.ui.geometry.CornerRadius(4.dp.value)
    )
    scope.drawRoundRect(
        color = Color(0xFF43A047),
        topLeft = androidx.compose.ui.geometry.Offset(cx - w * 0.05f, cy - h * 0.24f),
        size = androidx.compose.ui.geometry.Size(w * 0.07f, h * 0.09f),
        cornerRadius = androidx.compose.ui.geometry.CornerRadius(4.dp.value)
    )
    scope.drawRoundRect(
        color = Color(0xFF81C784),
        topLeft = androidx.compose.ui.geometry.Offset(cx + w * 0.05f, cy - h * 0.18f),
        size = androidx.compose.ui.geometry.Size(w * 0.06f, h * 0.07f),
        cornerRadius = androidx.compose.ui.geometry.CornerRadius(4.dp.value)
    )

    // Motion lines
    for (i in 0..2) {
        scope.drawLine(
            color = Color(0xFF4A7C3F).copy(alpha = 0.4f),
            start = androidx.compose.ui.geometry.Offset(cx - w * 0.42f, cy - h * 0.0f + i * h * 0.06f),
            end = androidx.compose.ui.geometry.Offset(cx - w * 0.28f, cy - h * 0.0f + i * h * 0.06f),
            strokeWidth = (3 - i).dp.value,
            cap = StrokeCap.Round
        )
    }
}
