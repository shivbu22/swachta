package com.swachta.app.ui.screens.home

import androidx.compose.animation.*
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
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.window.Dialog
import androidx.navigation.NavController
import com.swachta.app.navigation.Screen
import com.swachta.app.ui.components.*
import com.swachta.app.ui.theme.*

// ── Data models ──────────────────────────────────────────────────────────────

private data class OfferBanner(val id: Int, val title: String, val subtitle: String, val gradient: List<Color>)
private data class ServiceCard(val id: String, val name: String, val subtitle: String, val emoji: String, val route: String)
private data class TimeSlot(val label: String)

private val offers = listOf(
    OfferBanner(1, "30% OFF", "on your first booking", listOf(Color(0xFF158263), Color(0xFF0E6B50))),
    OfferBanner(2, "Plant 5 Trees", "with ₹500+ booking", listOf(Color(0xFF2D8A5E), Color(0xFF1B382C))),
    OfferBanner(3, "Refer & Get", "25 CC + ₹50 wallet", listOf(Color(0xFF4A7C59), Color(0xFF2D5A3A))),
)

private val services = listOf(
    ServiceCard("daily", "Daily\nGarbage", "Regular daily waste", "🗑️", Screen.DailyGarbage.route),
    ServiceCard("scrap", "Scrap\nMaterials", "Earn ₹₹₹", "♻️", Screen.ScrapItems.route),
    ServiceCard("recycle", "Recyclable\nWaste", "Plastic, Metal, Glass", "🔄", Screen.RecyclableWaste.route),
    ServiceCard("large", "Large\nDump", "Large street waste", "🚛", Screen.LargeDump.route),
)

private val slots = listOf(
    TimeSlot("6:00 am – 8:00 am"),
    TimeSlot("10 am – 12 pm"),
    TimeSlot("2:00 pm – 4:00 pm"),
    TimeSlot("6:00 pm – 8:00 pm"),
)

// ── Main screen ───────────────────────────────────────────────────────────────

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun HomeScreen(navController: NavController) {
    var offerIndex by remember { mutableIntStateOf(0) }
    var showReferral by remember { mutableStateOf(false) }
    var selectedSlot by remember { mutableStateOf<String?>(null) }
    var showDrawer by remember { mutableStateOf(false) }

    // Referral modal
    if (showReferral) {
        ReferralModal(onDismiss = { showReferral = false })
    }

    Scaffold(
        bottomBar = {
            SwachtaBottomNav(
                currentRoute = Screen.Home.route,
                onNavigate = { route ->
                    navController.navigate(route) {
                        popUpTo(Screen.Home.route) { saveState = true }
                        launchSingleTop = true
                        restoreState = true
                    }
                }
            )
        },
        containerColor = SurfaceBg
    ) { padding ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding)
                .verticalScroll(rememberScrollState())
        ) {
            // ─ Header ─
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 20.dp, vertical = 14.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                // Menu icon (hamburger)
                IconButton(onClick = { showDrawer = true }) {
                    Icon(Icons.Rounded.Menu, contentDescription = "Menu", tint = TextPrimary)
                }

                Spacer(modifier = Modifier.width(4.dp))

                // Location chip
                Row(
                    modifier = Modifier
                        .weight(1f)
                        .clip(RoundedCornerShape(10.dp))
                        .clickable { navController.navigate(Screen.Location.route) }
                        .padding(4.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Icon(Icons.Rounded.LocationOn, contentDescription = null, tint = BrandPrimary, modifier = Modifier.size(18.dp))
                    Spacer(modifier = Modifier.width(4.dp))
                    Column {
                        Text("Current Location", style = MaterialTheme.typography.labelSmall)
                        Row(verticalAlignment = Alignment.CenterVertically) {
                            Text("Sec - 76, Noida", style = MaterialTheme.typography.bodySmall.copy(color = TextPrimary))
                            Icon(Icons.Rounded.KeyboardArrowDown, null, modifier = Modifier.size(16.dp), tint = TextPrimary)
                        }
                    }
                }

                // Notification bell
                Box {
                    IconButton(onClick = { }) {
                        Icon(Icons.Rounded.NotificationsNone, contentDescription = "Notifications", tint = TextPrimary)
                    }
                    Box(
                        modifier = Modifier
                            .size(8.dp)
                            .clip(CircleShape)
                            .background(AccentDanger)
                            .align(Alignment.TopEnd)
                            .offset(x = (-6).dp, y = 6.dp)
                    )
                }
            }

            // ─ Search bar ─
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 20.dp)
                    .clip(RoundedCornerShape(14.dp))
                    .background(SurfaceCard)
                    .border(1.dp, BorderDefault, RoundedCornerShape(14.dp))
                    .padding(horizontal = 16.dp, vertical = 12.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                Icon(Icons.Rounded.Search, contentDescription = null, tint = TextSecondary, modifier = Modifier.size(20.dp))
                Spacer(modifier = Modifier.width(8.dp))
                Text(
                    "Search for services...",
                    modifier = Modifier.weight(1f),
                    style = MaterialTheme.typography.bodyMedium.copy(color = TextSecondary)
                )
                IconButton(
                    onClick = { navController.navigate(Screen.Camera.route) },
                    modifier = Modifier.size(32.dp)
                ) {
                    Icon(Icons.Rounded.CameraAlt, contentDescription = "Camera", tint = BrandPrimary)
                }
            }

            Spacer(modifier = Modifier.height(20.dp))

            // ─ Special Offers carousel ─
            SectionTitle(
                title = "Special Offers",
                actionText = "See more",
                onActionClick = {},
                modifier = Modifier.padding(horizontal = 20.dp)
            )
            Spacer(modifier = Modifier.height(12.dp))

            // Offer cards
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 20.dp)
            ) {
                AnimatedContent(
                    targetState = offerIndex,
                    transitionSpec = { fadeIn() togetherWith fadeOut() },
                    label = "offer"
                ) { idx ->
                    val offer = offers[idx]
                    Box(
                        modifier = Modifier
                            .fillMaxWidth()
                            .height(160.dp)
                            .clip(RoundedCornerShape(20.dp))
                            .background(Brush.linearGradient(offer.gradient))
                            .padding(20.dp)
                    ) {
                        Column {
                            Text(offer.title, style = MaterialTheme.typography.displayMedium.copy(color = Color.White))
                            Text(offer.subtitle, style = MaterialTheme.typography.bodyLarge.copy(color = Color.White.copy(alpha = 0.85f)))
                            Spacer(modifier = Modifier.height(8.dp))
                            Box(
                                modifier = Modifier
                                    .clip(RoundedCornerShape(20.dp))
                                    .background(Color.White.copy(alpha = 0.2f))
                                    .padding(horizontal = 16.dp, vertical = 6.dp)
                            ) {
                                Text("Book Now →", style = MaterialTheme.typography.bodySmall.copy(color = Color.White))
                            }
                        }
                        Text("🌿", fontSize = 48.sp, modifier = Modifier.align(Alignment.CenterEnd))
                    }
                }
            }

            // Dots
            Row(
                horizontalArrangement = Arrangement.Center,
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(top = 10.dp)
            ) {
                offers.indices.forEach { i ->
                    Box(
                        modifier = Modifier
                            .padding(horizontal = 3.dp)
                            .height(6.dp)
                            .width(if (i == offerIndex) 20.dp else 6.dp)
                            .clip(RoundedCornerShape(3.dp))
                            .background(if (i == offerIndex) BrandPrimary else BorderDefault)
                            .clickable { offerIndex = i }
                    )
                }
            }

            Spacer(modifier = Modifier.height(24.dp))

            // ─ Our Services ─
            SectionTitle(
                title = "Our Services",
                modifier = Modifier.padding(horizontal = 20.dp)
            )
            Spacer(modifier = Modifier.height(12.dp))

            // 2x2 grid with the plant banner replacing the last slot
            Column(modifier = Modifier.padding(horizontal = 20.dp)) {
                Row(horizontalArrangement = Arrangement.spacedBy(12.dp)) {
                    // Daily Garbage
                    ServiceGridCard(
                        service = services[0],
                        modifier = Modifier.weight(1f),
                        onClick = { navController.navigate(services[0].route) }
                    )
                    // Scrap Materials
                    ServiceGridCard(
                        service = services[1],
                        modifier = Modifier.weight(1f),
                        onClick = { navController.navigate(services[1].route) }
                    )
                }
                Spacer(modifier = Modifier.height(12.dp))
                Row(horizontalArrangement = Arrangement.spacedBy(12.dp)) {
                    // Large Dump
                    ServiceGridCard(
                        service = services[3],
                        modifier = Modifier.weight(1f),
                        onClick = { navController.navigate(services[3].route) }
                    )
                    // Plant Banner (special card)
                    Box(
                        modifier = Modifier
                            .weight(1f)
                            .height(140.dp)
                            .clip(RoundedCornerShape(16.dp))
                            .background(Brush.linearGradient(listOf(Color(0xFF2E7D32), Color(0xFF4A7C3F))))
                            .padding(14.dp),
                        contentAlignment = Alignment.CenterStart
                    ) {
                        Column {
                            Text(
                                "Planting made\nEffortless!",
                                style = MaterialTheme.typography.headlineSmall.copy(
                                    color = AccentGold,
                                    fontWeight = FontWeight.Bold
                                )
                            )
                            Spacer(modifier = Modifier.height(8.dp))
                            Text(
                                "Plant a tree from the comfort of your home",
                                style = MaterialTheme.typography.labelSmall.copy(color = Color.White)
                            )
                            Spacer(modifier = Modifier.height(8.dp))
                            Box(
                                modifier = Modifier
                                    .clip(RoundedCornerShape(20.dp))
                                    .background(BrandPrimary)
                                    .padding(horizontal = 12.dp, vertical = 4.dp)
                            ) {
                                Text("Plant Now →", style = MaterialTheme.typography.labelSmall.copy(color = Color.White))
                            }
                        }
                    }
                }
            }

            Spacer(modifier = Modifier.height(24.dp))

            // ─ Pickup Vehicle Slots ─
            SectionTitle(
                title = "Pickup Vehicle Slots",
                modifier = Modifier.padding(horizontal = 20.dp)
            )
            Spacer(modifier = Modifier.height(12.dp))

            LazyRow(
                contentPadding = PaddingValues(horizontal = 20.dp),
                horizontalArrangement = Arrangement.spacedBy(10.dp)
            ) {
                items(slots) { slot ->
                    val selected = selectedSlot == slot.label
                    Box(
                        modifier = Modifier
                            .clip(RoundedCornerShape(10.dp))
                            .background(if (selected) BrandPrimary else SurfaceCard)
                            .border(1.dp, if (selected) BrandPrimary else BorderDefault, RoundedCornerShape(10.dp))
                            .clickable { selectedSlot = slot.label }
                            .padding(horizontal = 16.dp, vertical = 10.dp)
                    ) {
                        Text(
                            slot.label,
                            style = MaterialTheme.typography.bodySmall.copy(
                                color = if (selected) Color.White else TextPrimary
                            )
                        )
                    }
                }
            }

            Spacer(modifier = Modifier.height(24.dp))

            // ─ Refer & Earn Banner ─
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 20.dp)
                    .clip(RoundedCornerShape(16.dp))
                    .background(GreenLight)
                    .border(1.dp, BorderDefault, RoundedCornerShape(16.dp))
                    .clickable { showReferral = true }
                    .padding(16.dp)
            ) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Column(modifier = Modifier.weight(1f)) {
                        Text(
                            "REFER & EARN",
                            style = MaterialTheme.typography.headlineMedium.copy(color = BrandDark)
                        )
                        Spacer(modifier = Modifier.height(4.dp))
                        Text(
                            "Get 25 CC + ₹50 for every friend who joins!",
                            style = MaterialTheme.typography.bodySmall.copy(color = TextSecondary)
                        )
                        Spacer(modifier = Modifier.height(12.dp))
                        Box(
                            modifier = Modifier
                                .clip(RoundedCornerShape(20.dp))
                                .background(BrandDark)
                                .padding(horizontal = 16.dp, vertical = 6.dp)
                        ) {
                            Text("SEND CODE →", style = MaterialTheme.typography.labelSmall.copy(color = Color.White))
                        }
                    }
                    Text("🤝", fontSize = 48.sp)
                }
            }

            Spacer(modifier = Modifier.height(24.dp))

            // ─ Brand footer ─
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 20.dp, vertical = 8.dp),
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                Text(
                    "every piece RECYCLED, every future PROTECTED.",
                    style = MaterialTheme.typography.bodySmall.copy(color = TextSecondary),
                    textAlign = TextAlign.Center
                )
                Text(
                    "SWACHTA",
                    style = MaterialTheme.typography.displayMedium.copy(
                        color = BrandDark,
                        fontWeight = FontWeight.ExtraBold,
                        letterSpacing = 2.sp
                    )
                )
                Text(
                    "Trusted by 200k+ Eco-Warriors",
                    style = MaterialTheme.typography.labelMedium,
                    textAlign = TextAlign.Center
                )
            }

            Spacer(modifier = Modifier.height(16.dp))
        }
    }
}

@Composable
private fun ServiceGridCard(service: ServiceCard, modifier: Modifier, onClick: () -> Unit) {
    Box(
        modifier = modifier
            .height(140.dp)
            .clip(RoundedCornerShape(16.dp))
            .background(GreenPale)
            .border(1.dp, BorderDefault, RoundedCornerShape(16.dp))
            .clickable { onClick() }
            .padding(14.dp)
    ) {
        Column {
            Text(service.emoji, fontSize = 28.sp)
            Spacer(modifier = Modifier.height(8.dp))
            Text(service.name, style = MaterialTheme.typography.bodySmall.copy(color = TextPrimary))
            Text(service.subtitle, style = MaterialTheme.typography.labelSmall)
        }
    }
}

@Composable
private fun ReferralModal(onDismiss: () -> Unit) {
    Dialog(onDismissRequest = onDismiss) {
        Card(
            shape = RoundedCornerShape(24.dp),
            colors = CardDefaults.cardColors(containerColor = SurfaceCard)
        ) {
            Column(
                modifier = Modifier.padding(24.dp),
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                Text("🎉", fontSize = 40.sp)
                Spacer(modifier = Modifier.height(8.dp))
                Text("Your Referral Code", style = MaterialTheme.typography.headlineMedium)
                Spacer(modifier = Modifier.height(16.dp))

                // Code box
                Box(
                    modifier = Modifier
                        .fillMaxWidth()
                        .clip(RoundedCornerShape(12.dp))
                        .background(GreenPale)
                        .border(1.dp, BorderDefault, RoundedCornerShape(12.dp))
                        .padding(16.dp),
                    contentAlignment = Alignment.Center
                ) {
                    Text(
                        "SHANTI2025",
                        style = MaterialTheme.typography.displayMedium.copy(color = BrandDark, letterSpacing = 2.sp),
                        textAlign = TextAlign.Center
                    )
                }

                Spacer(modifier = Modifier.height(8.dp))

                Text(
                    "Share this code & earn 25 CC + ₹50 for each referral",
                    style = MaterialTheme.typography.bodySmall.copy(color = TextSecondary),
                    textAlign = TextAlign.Center
                )

                Spacer(modifier = Modifier.height(20.dp))

                PrimaryButton(text = "📤 Share Invite Link", onClick = onDismiss)
                Spacer(modifier = Modifier.height(10.dp))
                TextButton(onClick = onDismiss) {
                    Text("Copy Code", style = MaterialTheme.typography.bodySmall.copy(color = BrandPrimary))
                }
            }
        }
    }
}
