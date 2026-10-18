package com.swachta.app.ui.screens.camera

import androidx.compose.foundation.background
import androidx.compose.foundation.border
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
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import com.swachta.app.navigation.Screen
import com.swachta.app.ui.theme.*

@Composable
fun CameraScreen(navController: NavController) {
    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(Color.Black)
    ) {
        // Simulated camera viewfinder
        Box(
            modifier = Modifier
                .fillMaxSize()
                .background(Color(0xFF111111)),
            contentAlignment = Alignment.Center
        ) {
            Text("📷", fontSize = 80.sp)
            Text(
                "Camera Preview",
                color = Color.White.copy(alpha = 0.4f),
                modifier = Modifier.align(Alignment.BottomCenter).padding(bottom = 200.dp)
            )
        }

        // Back button
        IconButton(
            onClick = { navController.popBackStack() },
            modifier = Modifier
                .align(Alignment.TopStart)
                .padding(top = 48.dp, start = 16.dp)
        ) {
            Icon(Icons.Rounded.ArrowBackIosNew, contentDescription = "Back", tint = Color.White)
        }

        // Flash toggle
        IconButton(
            onClick = {},
            modifier = Modifier
                .align(Alignment.TopEnd)
                .padding(top = 48.dp, end = 16.dp)
        ) {
            Icon(Icons.Rounded.FlashOn, contentDescription = "Flash", tint = Color.White)
        }

        // Title label
        Box(
            modifier = Modifier
                .align(Alignment.TopCenter)
                .padding(top = 56.dp)
        ) {
            Text(
                "Click Image of Your Garbage",
                style = MaterialTheme.typography.headlineSmall.copy(color = Color.White),
                textAlign = TextAlign.Center
            )
        }

        // Corner framing guides
        Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
            val size = 220.dp
            val cornerSize = 32.dp
            val stroke = 3.dp
            Box(modifier = Modifier.size(size)) {
                // Top-left
                Box(modifier = Modifier
                    .size(cornerSize)
                    .align(Alignment.TopStart)
                    .border(androidx.compose.foundation.BorderStroke(stroke, Color.White.copy(alpha = 0.7f)),
                        object : androidx.compose.ui.graphics.Shape {
                            override fun createOutline(size: androidx.compose.ui.geometry.Size, layoutDirection: androidx.compose.ui.unit.LayoutDirection, density: androidx.compose.ui.unit.Density) =
                                androidx.compose.ui.graphics.Outline.Generic(
                                    androidx.compose.ui.graphics.Path().apply {
                                        moveTo(0f, size.height); lineTo(0f, 0f); lineTo(size.width, 0f)
                                    }
                                )
                        }
                    ))
            }
        }

        // Bottom instruction card + controls
        Column(
            modifier = Modifier
                .align(Alignment.BottomCenter)
                .fillMaxWidth()
                .clip(RoundedCornerShape(topStart = 24.dp, topEnd = 24.dp))
                .background(Color.Black.copy(alpha = 0.85f))
                .padding(24.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            // Info banner
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .clip(RoundedCornerShape(12.dp))
                    .background(AccentInfo.copy(alpha = 0.15f))
                    .border(1.dp, AccentInfo.copy(alpha = 0.3f), RoundedCornerShape(12.dp))
                    .padding(12.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                Icon(Icons.Rounded.Info, null, tint = AccentInfo, modifier = Modifier.size(18.dp))
                Spacer(modifier = Modifier.width(8.dp))
                Text(
                    "Make sure the garbage is clearly visible in the frame for accurate detection.",
                    style = MaterialTheme.typography.labelSmall.copy(color = Color.White)
                )
            }

            Spacer(modifier = Modifier.height(20.dp))

            Row(
                horizontalArrangement = Arrangement.SpaceEvenly,
                modifier = Modifier.fillMaxWidth(),
                verticalAlignment = Alignment.CenterVertically
            ) {
                // Gallery
                IconButton(
                    onClick = {},
                    modifier = Modifier
                        .size(52.dp)
                        .clip(RoundedCornerShape(12.dp))
                        .background(Color.White.copy(alpha = 0.15f))
                ) {
                    Icon(Icons.Rounded.PhotoLibrary, null, tint = Color.White)
                }

                // Capture button
                Box(
                    modifier = Modifier
                        .size(72.dp)
                        .clip(CircleShape)
                        .border(3.dp, Color.White, CircleShape)
                        .background(Color.Transparent),
                    contentAlignment = Alignment.Center
                ) {
                    Box(
                        modifier = Modifier
                            .size(58.dp)
                            .clip(CircleShape)
                            .background(Color.White)
                    )
                }
                // We navigate to ScrapItems to simulate detection result
                var captured by remember { mutableStateOf(false) }
                if (!captured) {
                    Box(
                        modifier = Modifier
                            .size(72.dp)
                            .clip(CircleShape)
                            .border(3.dp, Color.White, CircleShape),
                        contentAlignment = Alignment.Center
                    ) {
                        Box(
                            modifier = Modifier
                                .size(58.dp)
                                .clip(CircleShape)
                                .background(Color.White)
                                .align(Alignment.Center),
                            contentAlignment = Alignment.Center
                        ) {
                            // tappable capture
                        }
                    }
                }

                // Flip camera
                IconButton(
                    onClick = {},
                    modifier = Modifier
                        .size(52.dp)
                        .clip(RoundedCornerShape(12.dp))
                        .background(Color.White.copy(alpha = 0.15f))
                ) {
                    Icon(Icons.Rounded.FlipCameraAndroid, null, tint = Color.White)
                }
            }

            Spacer(modifier = Modifier.height(8.dp))

            // Shortcut: tap to go to results
            TextButton(
                onClick = { navController.navigate(Screen.ScrapItems.route) }
            ) {
                Text("→ View Detection Results", color = BrandPrimary.copy(alpha = 0.8f))
            }
        }
    }
}
