package com.swachta.app.ui.screens.services

import androidx.compose.animation.animateColorAsState
import androidx.compose.foundation.*
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
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
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import com.swachta.app.navigation.Screen
import com.swachta.app.ui.components.*
import com.swachta.app.ui.theme.*

// ── Shared slot/vehicle picker ────────────────────────────────────────────────

private val timeSlots = listOf(
    "6:00 am – 8:00 am",
    "10 am – 12 pm",
    "2:00 pm – 4:00 pm",
    "6:00 pm – 8:00 pm",
)

@Composable
private fun ServiceBookingShell(
    title: String,
    emoji: String,
    description: String,
    bgGradient: List<Color>,
    navController: NavController,
    extraContent: @Composable ColumnScope.() -> Unit = {}
) {
    var selectedSlot by remember { mutableStateOf<String?>(null) }

    Scaffold(
        bottomBar = {
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .background(SurfaceCard)
                    .padding(horizontal = 20.dp, vertical = 12.dp)
            ) {
                PrimaryButton(
                    text = "Book Service",
                    onClick = {
                        navController.navigate(Screen.BookingConfirmed.route)
                    }
                )
            }
        },
        containerColor = SurfaceBg
    ) { padding ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding)
                .verticalScroll(rememberScrollState())
        ) {
            // Green header bar
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .background(Brush.verticalGradient(bgGradient))
                    .padding(top = 48.dp, bottom = 24.dp, start = 20.dp, end = 20.dp)
            ) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    IconButton(onClick = { navController.popBackStack() }) {
                        Icon(Icons.Rounded.ArrowBackIosNew, contentDescription = "Back", tint = Color.White)
                    }
                    Spacer(modifier = Modifier.width(8.dp))
                    Text(
                        text = title,
                        style = MaterialTheme.typography.headlineLarge.copy(color = Color.White)
                    )
                    Spacer(modifier = Modifier.weight(1f))
                    Text(emoji, fontSize = 40.sp)
                }
                Spacer(modifier = Modifier.height(12.dp))
            }

            Column(
                modifier = Modifier.padding(horizontal = 20.dp, vertical = 20.dp),
                verticalArrangement = Arrangement.spacedBy(20.dp)
            ) {
                // Service description card
                SwachtaCard(modifier = Modifier.fillMaxWidth()) {
                    Text(
                        text = description,
                        style = MaterialTheme.typography.bodyLarge.copy(color = TextSecondary)
                    )
                }

                // Camera capture CTA
                Box(
                    modifier = Modifier
                        .fillMaxWidth()
                        .clip(RoundedCornerShape(16.dp))
                        .background(GreenLight)
                        .border(1.dp, BorderDefault, RoundedCornerShape(16.dp))
                        .clickable { navController.navigate(Screen.Camera.route) }
                        .padding(20.dp),
                    contentAlignment = Alignment.Center
                ) {
                    Column(horizontalAlignment = Alignment.CenterHorizontally) {
                        Icon(
                            Icons.Rounded.CameraAlt,
                            contentDescription = null,
                            tint = BrandPrimary,
                            modifier = Modifier.size(40.dp)
                        )
                        Spacer(modifier = Modifier.height(8.dp))
                        Text("Click Image of Your Garbage", style = MaterialTheme.typography.headlineSmall)
                        Text(
                            "Make sure the garbage is clearly visible in the frame for accurate detection.",
                            style = MaterialTheme.typography.labelMedium,
                            textAlign = TextAlign.Center
                        )
                    }
                }

                // Vehicle info
                SwachtaCard(modifier = Modifier.fillMaxWidth()) {
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Box(
                            modifier = Modifier
                                .size(56.dp)
                                .clip(RoundedCornerShape(12.dp))
                                .background(GreenPale),
                            contentAlignment = Alignment.Center
                        ) {
                            Text("🚗", fontSize = 28.sp)
                        }
                        Spacer(modifier = Modifier.width(12.dp))
                        Column {
                            Text("Suggested Vehicle", style = MaterialTheme.typography.labelMedium)
                            Text("Hatchback (light load)", style = MaterialTheme.typography.bodySmall)
                        }
                    }
                }

                // Slot picker
                Column {
                    Text("Choose Pickup Slot", style = MaterialTheme.typography.headlineSmall)
                    Spacer(modifier = Modifier.height(10.dp))
                    LazyRow(horizontalArrangement = Arrangement.spacedBy(10.dp)) {
                        items(timeSlots) { slot ->
                            val selected = selectedSlot == slot
                            Box(
                                modifier = Modifier
                                    .clip(RoundedCornerShape(10.dp))
                                    .background(if (selected) BrandPrimary else SurfaceCard)
                                    .border(1.dp, if (selected) BrandPrimary else BorderDefault, RoundedCornerShape(10.dp))
                                    .clickable { selectedSlot = slot }
                                    .padding(horizontal = 14.dp, vertical = 10.dp)
                            ) {
                                Text(
                                    slot,
                                    style = MaterialTheme.typography.bodySmall.copy(
                                        color = if (selected) Color.White else TextPrimary
                                    )
                                )
                            }
                        }
                    }
                }

                extraContent()
            }
        }
    }
}

// ── Individual service screens ────────────────────────────────────────────────

@Composable
fun DailyGarbageScreen(navController: NavController) {
    ServiceBookingShell(
        title = "Daily Garbage",
        emoji = "🗑️",
        description = "Schedule regular daily waste pickup from your doorstep. Our trained workers will collect your daily household garbage and dispose of it responsibly.",
        bgGradient = listOf(BrandDark, BrandPrimary),
        navController = navController
    ) {
        // Price card
        SwachtaCard(modifier = Modifier.fillMaxWidth()) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Column {
                    Text("One-time Pickup", style = MaterialTheme.typography.labelMedium)
                    Text("₹99", style = MaterialTheme.typography.headlineLarge.copy(color = BrandPrimary))
                }
                Column {
                    Text("Monthly Plan", style = MaterialTheme.typography.labelMedium)
                    Text("₹799/mo", style = MaterialTheme.typography.headlineLarge.copy(color = BrandPrimary))
                }
            }
        }
    }
}

@Composable
fun LargeDumpScreen(navController: NavController) {
    ServiceBookingShell(
        title = "Large Dump",
        emoji = "🚛",
        description = "Need to dispose of large quantities of waste? Our heavy-duty fleet handles construction debris, bulk event waste, and large-scale cleanups.",
        bgGradient = listOf(Color(0xFF1B2838), Color(0xFF2C3E50)),
        navController = navController
    ) {
        SwachtaCard(modifier = Modifier.fillMaxWidth()) {
            Text("Estimated Price", style = MaterialTheme.typography.labelMedium)
            Text("From ₹499", style = MaterialTheme.typography.headlineLarge.copy(color = BrandPrimary))
            Text(
                "Final price depends on volume and distance. Our team will assess on arrival.",
                style = MaterialTheme.typography.labelSmall
            )
        }
    }
}

@Composable
fun RecyclableWasteScreen(navController: NavController) {
    ServiceBookingShell(
        title = "Recyclable Waste",
        emoji = "🔄",
        description = "Separate and sell your recyclable waste — plastic bottles, glass, paper, and metal. Get a fair, transparent price before booking.",
        bgGradient = listOf(Color(0xFF0D47A1), Color(0xFF1565C0)),
        navController = navController
    )
}

// ── Scrap Items (complex — with detected materials) ───────────────────────────

private data class DetectedMaterial(
    val id: Int,
    val name: String,
    val confidence: Int,
    val emoji: String,
    val unitValue: Int
)

@Composable
fun ScrapItemsScreen(navController: NavController) {
    var materials by remember {
        mutableStateOf(
            listOf(
                DetectedMaterial(1, "Plastic Bottles", 95, "♻️", 80),
                DetectedMaterial(2, "Cardboard", 92, "📦", 120),
                DetectedMaterial(3, "Aluminum Cans", 88, "🥫", 90),
                DetectedMaterial(4, "Newspapers", 85, "📰", 60),
                DetectedMaterial(5, "Electronics", 78, "💻", 200),
            )
        )
    }
    val total = materials.sumOf { it.unitValue }
    var selectedSlot by remember { mutableStateOf<String?>(null) }

    Scaffold(
        bottomBar = {
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .background(BrandDark)
                    .padding(horizontal = 20.dp, vertical = 14.dp)
            ) {
                PrimaryButton(
                    text = "Book Service",
                    onClick = { navController.navigate(Screen.BookingConfirmed.route) }
                )
            }
        },
        containerColor = SurfaceBg
    ) { padding ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding)
                .verticalScroll(rememberScrollState())
        ) {
            // Green header
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .background(Brush.verticalGradient(listOf(BrandDark, BrandPrimary)))
                    .padding(top = 48.dp, bottom = 24.dp, start = 20.dp, end = 20.dp)
            ) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    IconButton(onClick = { navController.popBackStack() }) {
                        Icon(Icons.Rounded.ArrowBackIosNew, null, tint = Color.White)
                    }
                    Spacer(modifier = Modifier.width(8.dp))
                    Text("Scrap Items", style = MaterialTheme.typography.headlineLarge.copy(color = Color.White))
                }
            }

            Column(modifier = Modifier.padding(horizontal = 20.dp, vertical = 16.dp)) {
                // Pickup location card
                SwachtaCard(modifier = Modifier.fillMaxWidth()) {
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Box(
                            modifier = Modifier
                                .size(36.dp)
                                .clip(CircleShape)
                                .background(GreenPale),
                            contentAlignment = Alignment.Center
                        ) {
                            Icon(Icons.Rounded.LocationOn, null, tint = BrandPrimary, modifier = Modifier.size(20.dp))
                        }
                        Spacer(modifier = Modifier.width(10.dp))
                        Column(modifier = Modifier.weight(1f)) {
                            Text("Pickup Location", style = MaterialTheme.typography.labelSmall)
                            Text(
                                "G-2129, Amrapali Silicon City, Sector 76, Noida - 201309",
                                style = MaterialTheme.typography.bodySmall
                            )
                        }
                        IconButton(onClick = {}) {
                            Icon(Icons.Rounded.Edit, null, tint = BrandPrimary, modifier = Modifier.size(18.dp))
                        }
                    }
                }

                Spacer(modifier = Modifier.height(16.dp))

                // Detected materials card
                SwachtaCard(modifier = Modifier.fillMaxWidth()) {
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Box(
                            modifier = Modifier
                                .size(36.dp)
                                .clip(CircleShape)
                                .background(GreenPale),
                            contentAlignment = Alignment.Center
                        ) {
                            Icon(Icons.Rounded.Delete, null, tint = BrandPrimary, modifier = Modifier.size(18.dp))
                        }
                        Spacer(modifier = Modifier.width(10.dp))
                        Column {
                            Text("Detected Materials", style = MaterialTheme.typography.headlineSmall)
                            Text(
                                "Review the detected items and remove anything that's incorrect.",
                                style = MaterialTheme.typography.labelSmall
                            )
                        }
                    }

                    Spacer(modifier = Modifier.height(12.dp))

                    materials.forEach { material ->
                        DetectedMaterialRow(
                            material = material,
                            onRemove = { materials = materials.filter { it.id != material.id } }
                        )
                        Spacer(modifier = Modifier.height(8.dp))
                    }

                    HorizontalDivider(color = BorderDefault)
                    Spacer(modifier = Modifier.height(10.dp))

                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Text("Total Estimated Value", style = MaterialTheme.typography.bodySmall)
                        Text(
                            "₹$total",
                            style = MaterialTheme.typography.headlineLarge.copy(color = BrandPrimary)
                        )
                    }
                }

                Spacer(modifier = Modifier.height(12.dp))

                // Info banner
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .clip(RoundedCornerShape(12.dp))
                        .background(Color(0xFFEFF6FF))
                        .border(1.dp, AccentInfo.copy(alpha = 0.3f), RoundedCornerShape(12.dp))
                        .padding(12.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Icon(Icons.Rounded.Info, null, tint = AccentInfo, modifier = Modifier.size(20.dp))
                    Spacer(modifier = Modifier.width(8.dp))
                    Column {
                        Text("Not seeing something?", style = MaterialTheme.typography.bodySmall.copy(color = AccentInfo))
                        TextButton(onClick = {}, contentPadding = PaddingValues(0.dp)) {
                            Text("Add more", style = MaterialTheme.typography.bodySmall.copy(color = AccentInfo))
                        }
                    }
                }

                Spacer(modifier = Modifier.height(20.dp))

                // Slot picker
                Text("Choose Pickup Slot", style = MaterialTheme.typography.headlineSmall)
                Spacer(modifier = Modifier.height(10.dp))
                LazyRow(horizontalArrangement = Arrangement.spacedBy(10.dp)) {
                    items(timeSlots) { slot ->
                        val selected = selectedSlot == slot
                        Box(
                            modifier = Modifier
                                .clip(RoundedCornerShape(10.dp))
                                .background(if (selected) BrandPrimary else SurfaceCard)
                                .border(1.dp, if (selected) BrandPrimary else BorderDefault, RoundedCornerShape(10.dp))
                                .clickable { selectedSlot = slot }
                                .padding(horizontal = 14.dp, vertical = 10.dp)
                        ) {
                            Text(slot, style = MaterialTheme.typography.bodySmall.copy(
                                color = if (selected) Color.White else TextPrimary
                            ))
                        }
                    }
                }
            }
        }
    }
}

@Composable
private fun DetectedMaterialRow(material: DetectedMaterial, onRemove: () -> Unit) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(10.dp))
            .background(GreenPale)
            .padding(horizontal = 12.dp, vertical = 10.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Box(
            modifier = Modifier
                .size(36.dp)
                .clip(CircleShape)
                .background(SurfaceCard),
            contentAlignment = Alignment.Center
        ) {
            Text(material.emoji, fontSize = 18.sp)
        }
        Spacer(modifier = Modifier.width(10.dp))
        Column(modifier = Modifier.weight(1f)) {
            Text(material.name, style = MaterialTheme.typography.bodySmall)
            Text("${material.confidence}% confident", style = MaterialTheme.typography.labelSmall.copy(color = BrandPrimary))
        }
        IconButton(
            onClick = onRemove,
            modifier = Modifier.size(36.dp)
        ) {
            Icon(
                Icons.Rounded.Delete,
                contentDescription = "Remove",
                tint = AccentDanger,
                modifier = Modifier.size(18.dp)
            )
        }
    }
}
