package com.swachta.app.ui.screens.impact

import androidx.compose.animation.core.*
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

private data class StatCard(val label: String, val value: String, val unit: String, val desc: String, val emoji: String)
private data class ActivityItem(val label: String, val time: String, val points: String)
private data class GlobalProject(val name: String, val sub: String, val trees: Int, val emoji: String)
private data class RewardItem(val name: String, val stock: String, val emoji: String)

@Composable
fun ImpactScreen(navController: NavController) {
    val progressAnim = remember { Animatable(0f) }
    LaunchedEffect(Unit) {
        progressAnim.animateTo(0.62f, tween(1200, easing = EaseInOutCubic))
    }

    val stats = listOf(
        StatCard("CO2 Prevented", "42.8", "kg", "Equivalent to driving 170 km less", "🌿"),
        StatCard("Trees Supported", "14", "Trees", "Active growth across 3 global initiatives", "🌳"),
        StatCard("Waste Recycled", "124", "L", "Diverted from municipal landfills", "♻️"),
    )
    val activities = listOf(
        ActivityItem("EV Courier Delivery", "Yesterday, 14:20", "+45 pts"),
        ActivityItem("Off-Peak Energy Usage", "Jan 12, 22:00", "+20 pts"),
        ActivityItem("Scrap Sale Completed", "Jan 10, 10:15", "+35 pts"),
    )
    val projects = listOf(
        GlobalProject("Amazon Reforestation", "Restoring native biodiversity in the basin.", 4, "🌲"),
        GlobalProject("Ocean Cleanup Atlantic", "Removing plastic from the Atlantic Ocean.", 2, "🌊"),
        GlobalProject("Solar Farm India", "Clean energy for rural communities.", 3, "☀️"),
    )
    val rewards = listOf(
        RewardItem("Carbon Credit Voucher", "4 Available", "🌍"),
        RewardItem("Zero-Emission Delivery", "2 Available", "🚚"),
    )
    var expandedBreakdown by remember { mutableStateOf<String?>(null) }

    Scaffold(
        bottomBar = {
            SwachtaBottomNav(
                currentRoute = Screen.Impact.route,
                onNavigate = { navController.navigate(it) { launchSingleTop = true } }
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
            // Top bar
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 20.dp, vertical = 16.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                IconButton(onClick = {}) {
                    Icon(Icons.Rounded.Menu, null, tint = TextPrimary)
                }
                Text("Impact", style = MaterialTheme.typography.headlineLarge)
            }

            Column(modifier = Modifier.padding(horizontal = 20.dp)) {
                // ─ Current Milestone banner ─
                Box(
                    modifier = Modifier
                        .fillMaxWidth()
                        .clip(RoundedCornerShape(20.dp))
                        .background(Brush.linearGradient(listOf(BrandDark, Color(0xFF2E7D32))))
                        .padding(20.dp)
                ) {
                    Row(modifier = Modifier.fillMaxWidth()) {
                        Column(modifier = Modifier.weight(1f)) {
                            Text("Current Milestone", style = MaterialTheme.typography.labelSmall.copy(color = Color.White.copy(alpha = 0.7f)))
                            Spacer(modifier = Modifier.height(4.dp))
                            Text("Level 2 - Sapling", style = MaterialTheme.typography.headlineMedium.copy(color = Color.White))
                            Text("1240 / 2000 Impact Points", style = MaterialTheme.typography.labelMedium.copy(color = Color.White.copy(alpha = 0.85f)))
                            Spacer(modifier = Modifier.height(10.dp))

                            // Progress bar
                            Box(
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .height(8.dp)
                                    .clip(RoundedCornerShape(4.dp))
                                    .background(Color.White.copy(alpha = 0.2f))
                            ) {
                                Box(
                                    modifier = Modifier
                                        .fillMaxWidth(progressAnim.value)
                                        .fillMaxHeight()
                                        .clip(RoundedCornerShape(4.dp))
                                        .background(Color.White)
                                )
                            }

                            Spacer(modifier = Modifier.height(8.dp))

                            Row(
                                modifier = Modifier
                                    .clip(RoundedCornerShape(20.dp))
                                    .background(Color.White.copy(alpha = 0.15f))
                                    .padding(horizontal = 12.dp, vertical = 4.dp),
                                verticalAlignment = Alignment.CenterVertically
                            ) {
                                Icon(Icons.Rounded.EmojiEvents, null, tint = AccentGold, modifier = Modifier.size(14.dp))
                                Spacer(modifier = Modifier.width(4.dp))
                                Text(
                                    "Top 8% of eco-conscious users this month",
                                    style = MaterialTheme.typography.labelSmall.copy(color = Color.White)
                                )
                            }
                        }
                        Spacer(modifier = Modifier.width(12.dp))
                        Text("62%", style = MaterialTheme.typography.headlineLarge.copy(color = Color.White))
                    }
                }

                Spacer(modifier = Modifier.height(12.dp))

                // ─ Next Goal ─
                Box(
                    modifier = Modifier
                        .fillMaxWidth()
                        .clip(RoundedCornerShape(16.dp))
                        .background(Brush.linearGradient(listOf(Color(0xFF1B5E20), BrandPrimary)))
                        .padding(16.dp)
                ) {
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Column(modifier = Modifier.weight(1f)) {
                            Text("Next Goal", style = MaterialTheme.typography.labelSmall.copy(color = Color.White.copy(alpha = 0.8f)), fontWeight = FontWeight.Bold)
                            Text(
                                "Plant 5 more trees to unlock Sustainability Titan status and 2x point multiplier",
                                style = MaterialTheme.typography.bodySmall.copy(color = Color.White)
                            )
                            Spacer(modifier = Modifier.height(8.dp))
                            Box(
                                modifier = Modifier
                                    .clip(RoundedCornerShape(20.dp))
                                    .background(AccentGold)
                                    .padding(horizontal = 14.dp, vertical = 5.dp)
                            ) {
                                Text("Plant Now", style = MaterialTheme.typography.labelSmall.copy(color = Color.White))
                            }
                        }
                        Text("🌱", fontSize = 36.sp)
                    }
                }

                Spacer(modifier = Modifier.height(20.dp))

                // ─ Stat cards ─
                stats.forEach { stat ->
                    SwachtaCard(modifier = Modifier.fillMaxWidth()) {
                        Row(verticalAlignment = Alignment.CenterVertically) {
                            Box(
                                modifier = Modifier
                                    .size(44.dp)
                                    .clip(RoundedCornerShape(12.dp))
                                    .background(GreenPale),
                                contentAlignment = Alignment.Center
                            ) {
                                Text(stat.emoji, fontSize = 22.sp)
                            }
                            Spacer(modifier = Modifier.width(12.dp))
                            Column(modifier = Modifier.weight(1f)) {
                                Text(stat.label, style = MaterialTheme.typography.labelSmall, modifier = Modifier.align(Alignment.End))
                            }
                        }
                        Spacer(modifier = Modifier.height(8.dp))
                        Row(verticalAlignment = Alignment.Baseline) {
                            Text(stat.value, style = MaterialTheme.typography.displayLarge.copy(color = TextPrimary))
                            Spacer(modifier = Modifier.width(4.dp))
                            Text(stat.unit, style = MaterialTheme.typography.headlineMedium.copy(color = TextPrimary))
                        }
                        Text(stat.desc, style = MaterialTheme.typography.labelSmall)
                    }
                    Spacer(modifier = Modifier.height(12.dp))
                }

                // ─ Impact Breakdown ─
                Text("Impact Breakdown", style = MaterialTheme.typography.headlineMedium)
                Spacer(modifier = Modifier.height(10.dp))

                listOf("Tree Distribution", "Carbon Savings Source", "Waste Diverted").forEach { item ->
                    val expanded = expandedBreakdown == item
                    SwachtaCard(
                        modifier = Modifier
                            .fillMaxWidth()
                            .clickable { expandedBreakdown = if (expanded) null else item }
                    ) {
                        Row(verticalAlignment = Alignment.CenterVertically) {
                            Text("🌿", fontSize = 18.sp)
                            Spacer(modifier = Modifier.width(8.dp))
                            Text(item, style = MaterialTheme.typography.bodySmall, modifier = Modifier.weight(1f))
                            Icon(
                                if (expanded) Icons.Rounded.KeyboardArrowUp else Icons.Rounded.KeyboardArrowDown,
                                null, tint = TextSecondary
                            )
                        }
                        if (expanded) {
                            Spacer(modifier = Modifier.height(8.dp))
                            Text(
                                "Detailed breakdown of your contribution to $item will appear here.",
                                style = MaterialTheme.typography.labelSmall
                            )
                        }
                    }
                    Spacer(modifier = Modifier.height(8.dp))
                }

                Spacer(modifier = Modifier.height(8.dp))

                // ─ Global Projects ─
                Text("Global Projects", style = MaterialTheme.typography.headlineMedium)
                Spacer(modifier = Modifier.height(10.dp))
            }

            LazyRow(
                contentPadding = PaddingValues(horizontal = 20.dp),
                horizontalArrangement = Arrangement.spacedBy(12.dp)
            ) {
                items(projects) { project ->
                    Card(
                        modifier = Modifier.width(180.dp),
                        shape = RoundedCornerShape(16.dp),
                        colors = CardDefaults.cardColors(containerColor = SurfaceCard)
                    ) {
                        Column {
                            Box(
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .height(100.dp)
                                    .background(GreenLight),
                                contentAlignment = Alignment.Center
                            ) {
                                Text(project.emoji, fontSize = 40.sp)
                                Box(
                                    modifier = Modifier
                                        .align(Alignment.TopEnd)
                                        .padding(8.dp)
                                        .clip(RoundedCornerShape(20.dp))
                                        .background(BrandDark)
                                        .padding(horizontal = 8.dp, vertical = 3.dp)
                                ) {
                                    Text("${project.trees} Trees", style = MaterialTheme.typography.labelSmall.copy(color = Color.White))
                                }
                            }
                            Column(modifier = Modifier.padding(12.dp)) {
                                Text(project.name, style = MaterialTheme.typography.bodySmall)
                                Text(project.sub, style = MaterialTheme.typography.labelSmall)
                            }
                        }
                    }
                }
            }

            Column(modifier = Modifier.padding(horizontal = 20.dp)) {
                Spacer(modifier = Modifier.height(20.dp))

                // ─ Recent Activity ─
                SectionTitle(title = "Recent Activity", actionText = "View All", onActionClick = {})
                Spacer(modifier = Modifier.height(10.dp))

                activities.forEach { activity ->
                    SwachtaCard(modifier = Modifier.fillMaxWidth()) {
                        Row(verticalAlignment = Alignment.CenterVertically) {
                            Box(
                                modifier = Modifier
                                    .size(40.dp)
                                    .clip(CircleShape)
                                    .background(GreenPale),
                                contentAlignment = Alignment.Center
                            ) {
                                Icon(Icons.Rounded.Recycling, null, tint = BrandPrimary, modifier = Modifier.size(20.dp))
                            }
                            Spacer(modifier = Modifier.width(10.dp))
                            Column(modifier = Modifier.weight(1f)) {
                                Text(activity.label, style = MaterialTheme.typography.bodySmall)
                                Text(activity.time, style = MaterialTheme.typography.labelSmall)
                            }
                            Text(activity.points, style = MaterialTheme.typography.bodySmall.copy(color = BrandPrimary))
                        }
                    }
                    Spacer(modifier = Modifier.height(8.dp))
                }

                Spacer(modifier = Modifier.height(8.dp))

                // ─ Available Rewards ─
                Text("Available Rewards", style = MaterialTheme.typography.headlineMedium)
                Spacer(modifier = Modifier.height(10.dp))

                rewards.forEach { reward ->
                    SwachtaCard(modifier = Modifier.fillMaxWidth()) {
                        Row(verticalAlignment = Alignment.CenterVertically) {
                            Box(
                                modifier = Modifier
                                    .size(44.dp)
                                    .clip(RoundedCornerShape(12.dp))
                                    .background(GreenPale),
                                contentAlignment = Alignment.Center
                            ) {
                                Text(reward.emoji, fontSize = 22.sp)
                            }
                            Spacer(modifier = Modifier.width(10.dp))
                            Column(modifier = Modifier.weight(1f)) {
                                Text(reward.name, style = MaterialTheme.typography.bodySmall)
                                Text(reward.stock, style = MaterialTheme.typography.labelSmall)
                            }
                            TextButton(onClick = {}) {
                                Text("Redeem", style = MaterialTheme.typography.bodySmall.copy(color = BrandPrimary))
                            }
                        }
                    }
                    Spacer(modifier = Modifier.height(8.dp))
                }

                Spacer(modifier = Modifier.height(8.dp))

                // ─ Achievements ─
                Text("Achievements", style = MaterialTheme.typography.headlineMedium)
                Spacer(modifier = Modifier.height(10.dp))

                Row(horizontalArrangement = Arrangement.spacedBy(12.dp)) {
                    listOf("🏅" to "First Tree Planted", "♻️" to "Recycling Champion", "🌍" to "Green Traveller").forEach { (emoji, label) ->
                        Column(
                            horizontalAlignment = Alignment.CenterHorizontally,
                            modifier = Modifier.width(80.dp)
                        ) {
                            Box(
                                modifier = Modifier
                                    .size(64.dp)
                                    .clip(CircleShape)
                                    .background(AccentGold.copy(alpha = 0.15f))
                                    .border(2.dp, AccentGold.copy(alpha = 0.4f), CircleShape),
                                contentAlignment = Alignment.Center
                            ) {
                                Text(emoji, fontSize = 28.sp)
                            }
                            Spacer(modifier = Modifier.height(4.dp))
                            Text(label, style = MaterialTheme.typography.labelSmall, textAlign = TextAlign.Center)
                        }
                    }
                }

                Spacer(modifier = Modifier.height(24.dp))
            }
        }
    }
}
