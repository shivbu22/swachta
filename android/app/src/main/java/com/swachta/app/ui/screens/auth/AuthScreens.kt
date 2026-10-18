package com.swachta.app.ui.screens.auth

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.rounded.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import com.swachta.app.navigation.Screen
import com.swachta.app.ui.components.*
import com.swachta.app.ui.theme.*

@Composable
fun SignUpScreen(navController: NavController) {
    var fullName by remember { mutableStateOf("") }
    var email by remember { mutableStateOf("") }
    var phone by remember { mutableStateOf("") }

    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(SurfaceBg)
    ) {
        // Decorative leaf blobs
        Box(
            modifier = Modifier
                .size(180.dp)
                .align(Alignment.TopEnd)
                .offset(x = 50.dp, y = (-20).dp)
                .clip(CircleShape)
                .background(GreenLight.copy(alpha = 0.5f))
        )
        Box(
            modifier = Modifier
                .size(120.dp)
                .align(Alignment.TopStart)
                .offset(x = (-30).dp, y = 60.dp)
                .clip(CircleShape)
                .background(GreenPale)
        )
        Box(
            modifier = Modifier
                .size(100.dp)
                .align(Alignment.BottomStart)
                .offset(x = (-20).dp, y = 20.dp)
                .clip(CircleShape)
                .background(GreenLight.copy(alpha = 0.3f))
        )

        Column(
            modifier = Modifier
                .fillMaxSize()
                .verticalScroll(rememberScrollState())
                .padding(horizontal = 24.dp)
                .padding(top = 60.dp, bottom = 40.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Text(
                text = "Create Account",
                style = MaterialTheme.typography.displayLarge,
                textAlign = TextAlign.Center
            )
            Spacer(modifier = Modifier.height(8.dp))
            Text(
                text = "Join us in building a cleaner\nand greener tomorrow",
                style = MaterialTheme.typography.bodyLarge.copy(color = TextSecondary),
                textAlign = TextAlign.Center
            )

            Spacer(modifier = Modifier.height(40.dp))

            SwachtaTextField(
                value = fullName,
                onValueChange = { fullName = it },
                label = "Full Name",
                placeholder = "Gracy",
                leadingIcon = {
                    Icon(Icons.Rounded.Person, contentDescription = null, tint = TextSecondary)
                }
            )

            Spacer(modifier = Modifier.height(16.dp))

            SwachtaTextField(
                value = email,
                onValueChange = { email = it },
                label = "Email",
                placeholder = "you@example.com",
                leadingIcon = {
                    Icon(Icons.Rounded.Email, contentDescription = null, tint = TextSecondary)
                },
                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Email)
            )

            Spacer(modifier = Modifier.height(16.dp))

            SwachtaTextField(
                value = phone,
                onValueChange = { phone = it },
                label = "Phone Number",
                placeholder = "+91 00000 00000",
                leadingIcon = {
                    Icon(Icons.Rounded.Phone, contentDescription = null, tint = TextSecondary)
                },
                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Phone)
            )

            Spacer(modifier = Modifier.height(28.dp))

            PrimaryButton(
                text = "Send OTP",
                onClick = {
                    val p = phone.ifBlank { "0000000000" }
                    navController.navigate(Screen.OTP.createRoute(p))
                }
            )

            Spacer(modifier = Modifier.height(16.dp))

            Row(
                horizontalArrangement = Arrangement.Center,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(
                    "Already have an account? ",
                    style = MaterialTheme.typography.bodyMedium.copy(color = TextSecondary)
                )
                TextButton(onClick = { navController.navigate(Screen.Login.route) }) {
                    Text("Log in", style = MaterialTheme.typography.bodySmall.copy(color = BrandPrimary))
                }
            }

            Spacer(modifier = Modifier.height(24.dp))

            Row(
                verticalAlignment = Alignment.CenterVertically,
                modifier = Modifier.fillMaxWidth()
            ) {
                HorizontalDivider(modifier = Modifier.weight(1f), color = BorderDefault)
                Text(
                    " Or sign up with email ",
                    style = MaterialTheme.typography.labelSmall,
                    color = TextSecondary
                )
                HorizontalDivider(modifier = Modifier.weight(1f), color = BorderDefault)
            }

            Spacer(modifier = Modifier.height(16.dp))

            // Google button
            OutlinedButton(
                onClick = { /* TODO: Google auth */ },
                modifier = Modifier
                    .fillMaxWidth()
                    .height(54.dp),
                shape = RoundedCornerShape(28.dp),
                colors = ButtonDefaults.outlinedButtonColors(
                    containerColor = SurfaceCard,
                    contentColor = TextPrimary
                )
            ) {
                Text("G ", fontSize = 18.sp, color = Color(0xFF4285F4), fontWeight = androidx.compose.ui.text.font.FontWeight.Bold)
                Text("Continue with Google", style = MaterialTheme.typography.labelLarge.copy(color = TextPrimary))
            }

            Spacer(modifier = Modifier.height(12.dp))

            // Apple button
            Button(
                onClick = { /* TODO: Apple auth */ },
                modifier = Modifier
                    .fillMaxWidth()
                    .height(54.dp),
                shape = RoundedCornerShape(28.dp),
                colors = ButtonDefaults.buttonColors(
                    containerColor = Color(0xFF000000),
                    contentColor = Color.White
                )
            ) {
                Text("🍎 Continue with Apple", style = MaterialTheme.typography.labelLarge)
            }

            Spacer(modifier = Modifier.height(20.dp))

            Text(
                "By signing up you agree to our Terms & Privacy Policy",
                style = MaterialTheme.typography.labelSmall,
                textAlign = TextAlign.Center,
                color = TextSecondary
            )
        }
    }
}

@Composable
fun LoginScreen(navController: NavController) {
    var phone by remember { mutableStateOf("") }

    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(SurfaceBg)
    ) {
        Box(
            modifier = Modifier
                .size(200.dp)
                .align(Alignment.TopEnd)
                .offset(x = 60.dp, y = (-40).dp)
                .clip(CircleShape)
                .background(GreenLight.copy(alpha = 0.5f))
        )
        Box(
            modifier = Modifier
                .size(100.dp)
                .align(Alignment.BottomStart)
                .offset(x = (-20).dp, y = 20.dp)
                .clip(CircleShape)
                .background(GreenPale)
        )

        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(horizontal = 24.dp)
                .padding(top = 80.dp, bottom = 40.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Text(
                text = "Welcome Back",
                style = MaterialTheme.typography.displayLarge,
                textAlign = TextAlign.Center
            )
            Spacer(modifier = Modifier.height(8.dp))
            Text(
                text = "Login to continue your journey",
                style = MaterialTheme.typography.bodyLarge.copy(color = TextSecondary),
                textAlign = TextAlign.Center
            )

            Spacer(modifier = Modifier.height(52.dp))

            SwachtaTextField(
                value = phone,
                onValueChange = { phone = it },
                label = "Phone Number",
                placeholder = "+91 00000 00000",
                leadingIcon = {
                    Icon(Icons.Rounded.Phone, contentDescription = null, tint = TextSecondary)
                },
                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Phone)
            )

            Spacer(modifier = Modifier.height(28.dp))

            PrimaryButton(
                text = "Continue",
                onClick = {
                    val p = phone.ifBlank { "0000000000" }
                    navController.navigate(Screen.OTP.createRoute(p))
                }
            )

            Spacer(modifier = Modifier.height(20.dp))

            Row(
                horizontalArrangement = Arrangement.Center,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(
                    "Don't have an account? ",
                    style = MaterialTheme.typography.bodyMedium.copy(color = TextSecondary)
                )
                TextButton(onClick = { navController.navigate(Screen.SignUp.route) }) {
                    Text("Sign Up", style = MaterialTheme.typography.bodySmall.copy(color = BrandPrimary))
                }
            }

            Spacer(modifier = Modifier.height(20.dp))

            Text(
                "By continuing you agree to our Terms & Privacy Policy",
                style = MaterialTheme.typography.labelSmall,
                textAlign = TextAlign.Center,
                color = TextSecondary
            )
        }
    }
}
