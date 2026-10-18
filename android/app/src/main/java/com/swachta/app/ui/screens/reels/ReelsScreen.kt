package com.swachta.app.ui.screens.reels

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.rounded.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import com.swachta.app.navigation.Screen
import com.swachta.app.ui.components.SwachtaBottomNav
import com.swachta.app.ui.theme.*

@Composable
fun ReelsScreen(navController: NavController) {
    val reels = listOf(
        Triple("How to Segregate Waste at Home 🗂️", "@swachta_official", "♻️"),
        Triple("Meet Our Workers: Radha's Story 👷", "@swachta_stories", "👷"),
        Triple("5 Tips for Zero-Waste Kitchen 🍃", "@ecowarrior_india", "🍃"),
        Triple("How Scrap Pricing Works 💰", "@swachta_edu", "💰"),
    )

    Scaffold(
        bottomBar = {
            SwachtaBottomNav(
                currentRoute = Screen.Reels.route,
                onNavigate = { navController.navigate(it) { launchSingleTop = true } }
            )
        }
    ) { padding ->
        Box(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding)
                .background(Color.Black)
        ) {
            // Fullscreen reel simulation
            Box(
                modifier = Modifier
                    .fillMaxSize()
                    .background(Brush.verticalGradient(listOf(Color(0xFF1B5E20), Color.Black)))
            )

            // Content overlay
            Column(
                modifier = Modifier
                    .align(Alignment.BottomStart)
                    .padding(16.dp)
                    .fillMaxWidth(0.75f)
            ) {
                Text(reels[0].first, style = MaterialTheme.typography.headlineSmall.copy(color = Color.White))
                Spacer(modifier = Modifier.height(4.dp))
                Text(reels[0].second, style = MaterialTheme.typography.labelMedium.copy(color = Color.White.copy(alpha = 0.8f)))
            }

            // Right side action buttons
            Column(
                modifier = Modifier
                    .align(Alignment.BottomEnd)
                    .padding(16.dp),
                horizontalAlignment = Alignment.CenterHorizontally,
                verticalArrangement = Arrangement.spacedBy(20.dp)
            ) {
                ReelActionButton(icon = "❤️", label = "1.2k")
                ReelActionButton(icon = "💬", label = "48")
                ReelActionButton(icon = "↗️", label = "Share")
                ReelActionButton(icon = "⬇️", label = "Save")
            }

            // Center play indicator
            Box(
                modifier = Modifier
                    .align(Alignment.Center)
                    .size(64.dp)
                    .clip(CircleShape)
                    .background(Color.Black.copy(alpha = 0.4f)),
                contentAlignment = Alignment.Center
            ) {
                Text("▶", fontSize = 28.sp, color = Color.White)
            }

            // Top bar
            Row(
                modifier = Modifier
                    .align(Alignment.TopCenter)
                    .fillMaxWidth()
                    .padding(horizontal = 20.dp, vertical = 48.dp),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text("Reels", style = MaterialTheme.typography.headlineLarge.copy(color = Color.White))
                Icon(Icons.Rounded.Search, null, tint = Color.White)
            }
        }
    }
}

@Composable
private fun ReelActionButton(icon: String, label: String) {
    Column(horizontalAlignment = Alignment.CenterHorizontally) {
        Text(icon, fontSize = 28.sp)
        Text(label, style = MaterialTheme.typography.labelSmall.copy(color = Color.White))
    }
}
