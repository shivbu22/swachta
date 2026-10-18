package com.swachta.app.ui.screens.auth

import androidx.compose.animation.core.*
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.BasicTextField
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.rounded.ArrowBackIosNew
import androidx.compose.material.icons.rounded.CheckCircle
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.scale
import androidx.compose.ui.focus.FocusRequester
import androidx.compose.ui.focus.focusRequester
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import com.swachta.app.navigation.Screen
import com.swachta.app.ui.components.PrimaryButton
import com.swachta.app.ui.components.SecondaryButton
import com.swachta.app.ui.theme.*
import kotlinx.coroutines.delay

@Composable
fun OTPScreen(navController: NavController, phone: String) {
    var otp by remember { mutableStateOf("") }
    var resendTimer by remember { mutableIntStateOf(30) }
    val focusRequester = remember { FocusRequester() }

    LaunchedEffect(Unit) {
        focusRequester.requestFocus()
        while (resendTimer > 0) {
            delay(1000)
            resendTimer--
        }
    }

    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(SurfaceBg)
    ) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(horizontal = 24.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Spacer(modifier = Modifier.height(16.dp))

            // Back button
            Row(modifier = Modifier.fillMaxWidth()) {
                IconButton(onClick = { navController.popBackStack() }) {
                    Icon(Icons.Rounded.ArrowBackIosNew, contentDescription = "Back", tint = TextPrimary)
                }
            }

            Spacer(modifier = Modifier.height(24.dp))

            // Truck illustration
            Box(
                modifier = Modifier
                    .size(160.dp)
                    .clip(CircleShape)
                    .background(GreenLight),
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
                        modifier = Modifier.size(110.dp)
                    )
                } else {
                    Text("🚛", fontSize = 64.sp)
                }
            }

            Spacer(modifier = Modifier.height(32.dp))

            Text(
                text = "Enter OTP",
                style = MaterialTheme.typography.displayMedium,
                textAlign = TextAlign.Center
            )

            Spacer(modifier = Modifier.height(8.dp))

            Text(
                text = "We've sent a code to",
                style = MaterialTheme.typography.bodyLarge.copy(color = TextSecondary),
                textAlign = TextAlign.Center
            )
            Text(
                text = "+91 ${phone.take(5)} ${phone.drop(5).take(5)}",
                style = MaterialTheme.typography.bodyLarge.copy(color = TextPrimary),
                textAlign = TextAlign.Center
            )

            Spacer(modifier = Modifier.height(40.dp))

            // Hidden TextField drives OTP input
            BasicTextField(
                value = otp,
                onValueChange = { if (it.length <= 4) otp = it },
                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                modifier = Modifier
                    .size(0.dp)
                    .focusRequester(focusRequester)
            )

            // OTP digit boxes
            Row(
                horizontalArrangement = Arrangement.spacedBy(16.dp),
                modifier = Modifier.fillMaxWidth(),
                verticalAlignment = Alignment.CenterVertically
            ) {
                repeat(4) { i ->
                    val char = otp.getOrNull(i)
                    val isFocused = otp.length == i

                    Box(
                        modifier = Modifier
                            .weight(1f)
                            .height(60.dp)
                            .clip(RoundedCornerShape(12.dp))
                            .background(SurfaceCard)
                            .border(
                                width = if (isFocused) 2.dp else 1.dp,
                                color = if (isFocused) BrandPrimary else BorderDefault,
                                shape = RoundedCornerShape(12.dp)
                            ),
                        contentAlignment = Alignment.Center
                    ) {
                        Text(
                            text = char?.toString() ?: "",
                            style = MaterialTheme.typography.displayMedium
                        )
                        if (isFocused && char == null) {
                            val blink = remember { Animatable(1f) }
                            LaunchedEffect(Unit) {
                                while (true) {
                                    blink.animateTo(0f, tween(500))
                                    blink.animateTo(1f, tween(500))
                                }
                            }
                            Box(
                                modifier = Modifier
                                    .width(2.dp)
                                    .height(28.dp)
                                    .background(BrandPrimary.copy(alpha = blink.value))
                            )
                        }
                    }
                }
            }

            Spacer(modifier = Modifier.height(36.dp))

            PrimaryButton(
                text = "Verify OTP",
                onClick = {
                    navController.navigate(Screen.Verified.route) {
                        popUpTo(Screen.OTP.route) { inclusive = true }
                    }
                }
            )

            Spacer(modifier = Modifier.height(20.dp))

            if (resendTimer > 0) {
                Text(
                    text = "Resend OTP in ${resendTimer}s",
                    style = MaterialTheme.typography.bodyMedium.copy(color = TextSecondary)
                )
            } else {
                TextButton(onClick = { resendTimer = 30 }) {
                    Text(
                        text = "Resend OTP",
                        style = MaterialTheme.typography.bodyMedium.copy(color = BrandPrimary),
                        textDecoration = androidx.compose.ui.text.style.TextDecoration.Underline
                    )
                }
            }
        }
    }
}

@Composable
fun VerifiedScreen(navController: NavController) {
    val scale = remember { Animatable(0f) }

    LaunchedEffect(Unit) {
        scale.animateTo(1f, spring(dampingRatio = Spring.DampingRatioMediumBouncy))
    }

    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(SurfaceBg),
        contentAlignment = Alignment.Center
    ) {
        Column(
            horizontalAlignment = Alignment.CenterHorizontally,
            modifier = Modifier.padding(horizontal = 24.dp)
        ) {
            // Concentric circles + check
            Box(contentAlignment = Alignment.Center) {
                Box(
                    modifier = Modifier
                        .size(160.dp)
                        .scale(scale.value)
                        .clip(CircleShape)
                        .background(GreenLight)
                )
                Box(
                    modifier = Modifier
                        .size(120.dp)
                        .scale(scale.value)
                        .clip(CircleShape)
                        .background(GreenMid.copy(alpha = 0.5f))
                )
                Box(
                    modifier = Modifier
                        .size(84.dp)
                        .scale(scale.value)
                        .clip(CircleShape)
                        .background(BrandPrimary),
                    contentAlignment = Alignment.Center
                ) {
                    Icon(
                        Icons.Rounded.CheckCircle,
                        contentDescription = "Verified",
                        tint = Color.White,
                        modifier = Modifier.size(48.dp)
                    )
                }
            }

            Spacer(modifier = Modifier.height(32.dp))

            Text(
                text = "Verified!",
                style = MaterialTheme.typography.displayLarge.copy(color = BrandDark),
                textAlign = TextAlign.Center
            )

            Spacer(modifier = Modifier.height(12.dp))

            Text(
                text = "Your account has been verified\nsuccessfully",
                style = MaterialTheme.typography.bodyLarge.copy(color = TextSecondary),
                textAlign = TextAlign.Center
            )

            Spacer(modifier = Modifier.height(48.dp))

            PrimaryButton(
                text = "Proceed to Dashboard",
                onClick = {
                    navController.navigate(Screen.Location.route) {
                        popUpTo(Screen.Verified.route) { inclusive = true }
                    }
                }
            )

            Spacer(modifier = Modifier.height(16.dp))

            SecondaryButton(
                text = "Complete Profile",
                onClick = {
                    navController.navigate(Screen.PersonalDetails.route)
                }
            )
        }
    }
}
