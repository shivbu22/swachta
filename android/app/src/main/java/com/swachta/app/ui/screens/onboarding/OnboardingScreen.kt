package com.swachta.app.ui.screens.onboarding

import androidx.compose.animation.AnimatedContent
import androidx.compose.animation.slideInHorizontally
import androidx.compose.animation.slideOutHorizontally
import androidx.compose.animation.togetherWith
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import com.swachta.app.navigation.Screen
import com.swachta.app.ui.components.PrimaryButton
import com.swachta.app.ui.components.SecondaryButton
import com.swachta.app.ui.theme.*

private data class OnboardingPage(
    val emoji: String,
    val headline: String,
    val body: String,
    val bgColor: Color
)

private val pages = listOf(
    OnboardingPage(
        emoji = "🚛💨",
        headline = "Every piece of trash.\nDone in a dash.",
        body = "Instant scheduling, real-time tracking, and eco-friendly disposal — all in a few taps.",
        bgColor = Color(0xFFE8F5E9)
    ),
    OnboardingPage(
        emoji = "🌳♻️",
        headline = "Plant Trees &\nGrow a better tomorrow!",
        body = "Swachta recruits, trains, and directly manages every worker — not a gig marketplace. Your recycling funds real tree planting.",
        bgColor = Color(0xFFF1F8E9)
    ),
    OnboardingPage(
        emoji = "🏙️✅",
        headline = "India's first on-demand\nsanitation platform!",
        body = "Trained, insured sanitation workers arrive in 15 minutes — tracked live, paid fairly, and accountable for every job.",
        bgColor = Color(0xFFE0F2F1)
    )
)

@Composable
fun OnboardingScreen(navController: NavController) {
    var currentPage by remember { mutableIntStateOf(0) }

    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(SurfaceBg)
    ) {
        // Decorative circles
        Box(
            modifier = Modifier
                .size(220.dp)
                .align(Alignment.TopEnd)
                .offset(x = 60.dp, y = (-30).dp)
                .clip(CircleShape)
                .background(GreenLight.copy(alpha = 0.5f))
        )
        Box(
            modifier = Modifier
                .size(140.dp)
                .align(Alignment.BottomStart)
                .offset(x = (-30).dp, y = 30.dp)
                .clip(CircleShape)
                .background(GreenPale)
        )
        Box(
            modifier = Modifier
                .size(90.dp)
                .align(Alignment.CenterEnd)
                .offset(x = 30.dp, y = (-60).dp)
                .clip(CircleShape)
                .background(GreenLight.copy(alpha = 0.3f))
        )

        Column(
            modifier = Modifier.fillMaxSize(),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            // Main illustration area
            AnimatedContent(
                targetState = currentPage,
                transitionSpec = {
                    slideInHorizontally { it } togetherWith slideOutHorizontally { -it }
                },
                label = "OnboardingPage"
            ) { page ->
                Column(
                    modifier = Modifier
                        .fillMaxWidth()
                        .weight(1f)
                        .padding(horizontal = 24.dp),
                    horizontalAlignment = Alignment.CenterHorizontally,
                    verticalArrangement = Arrangement.Center
                ) {
                    // Illustration box
                    Box(
                        modifier = Modifier
                            .fillMaxWidth()
                            .height(280.dp)
                            .clip(RoundedCornerShape(24.dp))
                            .background(pages[page].bgColor),
                        contentAlignment = Alignment.Center
                    ) {
                        // Large emoji as illustration placeholder
                        Text(
                            text = pages[page].emoji,
                            fontSize = 80.sp
                        )
                        // Decorative dots
                        Box(
                            modifier = Modifier
                                .size(60.dp)
                                .align(Alignment.TopStart)
                                .offset(x = 12.dp, y = 12.dp)
                                .clip(CircleShape)
                                .background(BrandPrimary.copy(alpha = 0.08f))
                        )
                        Box(
                            modifier = Modifier
                                .size(40.dp)
                                .align(Alignment.BottomEnd)
                                .offset(x = (-16).dp, y = (-16).dp)
                                .clip(CircleShape)
                                .background(BrandPrimary.copy(alpha = 0.12f))
                        )
                    }

                    Spacer(modifier = Modifier.height(36.dp))

                    Text(
                        text = pages[page].headline,
                        style = MaterialTheme.typography.displayMedium,
                        textAlign = TextAlign.Start,
                        modifier = Modifier.fillMaxWidth()
                    )

                    Spacer(modifier = Modifier.height(16.dp))

                    Text(
                        text = pages[page].body,
                        style = MaterialTheme.typography.bodyLarge.copy(color = TextSecondary),
                        textAlign = TextAlign.Start,
                        modifier = Modifier.fillMaxWidth()
                    )
                }
            }

            // Bottom navigation area
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 24.dp)
                    .padding(bottom = 48.dp),
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                // Progress dots
                Row(
                    horizontalArrangement = Arrangement.spacedBy(8.dp),
                    modifier = Modifier.padding(bottom = 32.dp)
                ) {
                    pages.indices.forEach { i ->
                        Box(
                            modifier = Modifier
                                .height(8.dp)
                                .width(if (i == currentPage) 28.dp else 8.dp)
                                .clip(RoundedCornerShape(4.dp))
                                .background(if (i == currentPage) BrandPrimary else BorderDefault)
                        )
                    }
                }

                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.spacedBy(16.dp)
                ) {
                    OutlinedButton(
                        onClick = {
                            navController.navigate(Screen.SignUp.route) {
                                popUpTo(Screen.Onboarding.route) { inclusive = true }
                            }
                        },
                        modifier = Modifier
                            .weight(1f)
                            .height(54.dp),
                        shape = RoundedCornerShape(28.dp),
                        colors = ButtonDefaults.outlinedButtonColors(contentColor = TextSecondary)
                    ) {
                        Text("Skip", style = MaterialTheme.typography.labelLarge.copy(color = TextSecondary))
                    }

                    Button(
                        onClick = {
                            if (currentPage < pages.lastIndex) {
                                currentPage++
                            } else {
                                navController.navigate(Screen.SignUp.route) {
                                    popUpTo(Screen.Onboarding.route) { inclusive = true }
                                }
                            }
                        },
                        modifier = Modifier
                            .weight(1f)
                            .height(54.dp),
                        shape = RoundedCornerShape(28.dp),
                        colors = ButtonDefaults.buttonColors(containerColor = BrandDark)
                    ) {
                        Text(
                            if (currentPage < pages.lastIndex) "Next" else "Get Started",
                            style = MaterialTheme.typography.labelLarge
                        )
                    }
                }
            }
        }
    }
}
