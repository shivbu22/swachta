package com.swachta.app.ui.screens.booking

import androidx.compose.animation.core.*
import androidx.compose.foundation.*
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
import androidx.compose.ui.draw.scale
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import com.swachta.app.navigation.Screen
import com.swachta.app.ui.components.*
import com.swachta.app.ui.theme.*

// ── Booking Confirmed ─────────────────────────────────────────────────────────

@Composable
fun BookingConfirmedScreen(navController: NavController) {
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
            modifier = Modifier
                .padding(horizontal = 24.dp)
                .verticalScroll(rememberScrollState())
        ) {
            Spacer(modifier = Modifier.height(48.dp))

            // Animated concentric circles with checkmark
            Box(
                modifier = Modifier
                    .size(140.dp)
                    .scale(scale.value),
                contentAlignment = Alignment.Center
            ) {
                Box(modifier = Modifier.size(140.dp).clip(CircleShape).background(GreenLight))
                Box(modifier = Modifier.size(108.dp).clip(CircleShape).background(GreenMid.copy(alpha = 0.4f)))
                Box(
                    modifier = Modifier.size(80.dp).clip(CircleShape).background(BrandPrimary),
                    contentAlignment = Alignment.Center
                ) {
                    Icon(Icons.Rounded.Check, null, tint = Color.White, modifier = Modifier.size(40.dp))
                }
            }

            Spacer(modifier = Modifier.height(28.dp))

            Text(
                "Booking Confirmed!",
                style = MaterialTheme.typography.displayMedium.copy(color = BrandDark),
                textAlign = TextAlign.Center
            )
            Spacer(modifier = Modifier.height(8.dp))
            Text(
                "Your waste collection service has been\nsuccessfully booked",
                style = MaterialTheme.typography.bodyLarge.copy(color = TextSecondary),
                textAlign = TextAlign.Center
            )

            Spacer(modifier = Modifier.height(32.dp))

            // Booking details card
            SwachtaCard(modifier = Modifier.fillMaxWidth()) {
                Text("Booking Details", style = MaterialTheme.typography.headlineSmall)
                Spacer(modifier = Modifier.height(16.dp))

                BookingDetailRow(icon = Icons.Rounded.CalendarMonth, label = "Service", value = "Daily Garbage - One-time Service")
                Spacer(modifier = Modifier.height(12.dp))
                BookingDetailRow(icon = Icons.Rounded.Schedule, label = "Date & Time", value = "May 31, 2026 • 6:00 AM – 8:00 AM")
                Spacer(modifier = Modifier.height(12.dp))
                BookingDetailRow(icon = Icons.Rounded.LocationOn, label = "Location", value = "Sec - 76, Noida")
                Spacer(modifier = Modifier.height(12.dp))
                BookingDetailRow(icon = Icons.Rounded.CurrencyRupee, label = "Amount Paid", value = "₹149")
            }

            Spacer(modifier = Modifier.height(32.dp))

            SecondaryButton(
                text = "⬇ Download Receipt",
                onClick = {}
            )
            Spacer(modifier = Modifier.height(12.dp))
            TextButton(onClick = {
                navController.navigate(Screen.Home.route) {
                    popUpTo(0) { inclusive = true }
                }
            }) {
                Icon(Icons.Rounded.Home, null, tint = BrandPrimary)
                Spacer(modifier = Modifier.width(4.dp))
                Text("Go to Home", style = MaterialTheme.typography.bodySmall.copy(color = BrandPrimary))
            }

            Spacer(modifier = Modifier.height(32.dp))
        }
    }
}

@Composable
private fun BookingDetailRow(icon: androidx.compose.ui.graphics.vector.ImageVector, label: String, value: String) {
    Row(verticalAlignment = Alignment.Top) {
        Box(
            modifier = Modifier
                .size(36.dp)
                .clip(RoundedCornerShape(8.dp))
                .background(GreenPale),
            contentAlignment = Alignment.Center
        ) {
            Icon(icon, null, tint = BrandPrimary, modifier = Modifier.size(18.dp))
        }
        Spacer(modifier = Modifier.width(12.dp))
        Column {
            Text(label, style = MaterialTheme.typography.labelSmall)
            Text(value, style = MaterialTheme.typography.bodySmall.copy(color = TextPrimary))
        }
    }
}

// ── My Bookings ───────────────────────────────────────────────────────────────

private data class BookingItem(
    val id: Int,
    val service: String,
    val price: String,
    val date: String,
    val status: BookingStatus
)

private enum class BookingStatus { Completed, Cancelled, Pending, Ongoing }

private val sampleBookings = listOf(
    BookingItem(1, "Daily Garbage - Instant", "₹99", "12 Jun 2025", BookingStatus.Completed),
    BookingItem(2, "Large Dump", "₹999", "12 Jun 2025", BookingStatus.Cancelled),
    BookingItem(3, "Scrap Material", "+ ₹1,240", "12 Jun 2025", BookingStatus.Pending),
    BookingItem(4, "Recyclable Waste", "₹149", "11 Jun 2025", BookingStatus.Ongoing),
)

@Composable
fun MyBookingsScreen(navController: NavController) {
    var selectedFilter by remember { mutableStateOf("All") }
    val filters = listOf("All", "Ongoing", "Completed", "Cancelled")

    val filtered = when (selectedFilter) {
        "Ongoing" -> sampleBookings.filter { it.status == BookingStatus.Ongoing }
        "Completed" -> sampleBookings.filter { it.status == BookingStatus.Completed }
        "Cancelled" -> sampleBookings.filter { it.status == BookingStatus.Cancelled }
        else -> sampleBookings
    }

    Scaffold(
        bottomBar = {
            SwachtaBottomNav(
                currentRoute = Screen.Bookings.route,
                onNavigate = { navController.navigate(it) { launchSingleTop = true } }
            )
        },
        containerColor = SurfaceBg
    ) { padding ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding)
        ) {
            // Top bar
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 20.dp, vertical = 16.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                IconButton(onClick = { navController.popBackStack() }) {
                    Icon(Icons.Rounded.ArrowBackIosNew, null, tint = BrandPrimary)
                }
                Column {
                    Text("My Bookings", style = MaterialTheme.typography.headlineLarge.copy(color = BrandPrimary))
                    Text("Track your orders", style = MaterialTheme.typography.labelSmall)
                }
                Spacer(modifier = Modifier.weight(1f))
                Icon(Icons.Rounded.FilterList, null, tint = TextPrimary)
            }

            // Filter chips
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 20.dp),
                horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                filters.forEach { filter ->
                    val selected = selectedFilter == filter
                    Box(
                        modifier = Modifier
                            .clip(RoundedCornerShape(20.dp))
                            .background(if (selected) BrandPrimary else SurfaceCard)
                            .border(1.dp, if (selected) BrandPrimary else BorderDefault, RoundedCornerShape(20.dp))
                            .clickable { selectedFilter = filter }
                            .padding(horizontal = 16.dp, vertical = 8.dp)
                    ) {
                        Text(
                            filter,
                            style = MaterialTheme.typography.bodySmall.copy(
                                color = if (selected) Color.White else TextPrimary
                            )
                        )
                    }
                }
            }

            Spacer(modifier = Modifier.height(16.dp))

            // Bookings list
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 20.dp)
                    .verticalScroll(rememberScrollState()),
                verticalArrangement = Arrangement.spacedBy(12.dp)
            ) {
                filtered.forEach { booking ->
                    BookingCard(booking = booking)
                }
            }
        }
    }
}

@Composable
private fun BookingCard(booking: BookingItem) {
    SwachtaCard(modifier = Modifier.fillMaxWidth()) {
        Row(
            modifier = Modifier.fillMaxWidth(),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Column(modifier = Modifier.weight(1f)) {
                Text(booking.service, style = MaterialTheme.typography.bodySmall)
                Text(booking.price, style = MaterialTheme.typography.headlineSmall.copy(color = BrandPrimary))
            }
            Column(horizontalAlignment = Alignment.End) {
                val (statusText, statusColor) = when (booking.status) {
                    BookingStatus.Completed -> "Completed" to StatusCompleted
                    BookingStatus.Cancelled -> "Cancelled" to StatusCancelled
                    BookingStatus.Pending -> "Pending" to StatusPending
                    BookingStatus.Ongoing -> "Ongoing" to StatusOngoing
                }
                Box(
                    modifier = Modifier
                        .clip(RoundedCornerShape(20.dp))
                        .background(statusColor.copy(alpha = 0.12f))
                        .border(1.dp, statusColor.copy(alpha = 0.3f), RoundedCornerShape(20.dp))
                        .padding(horizontal = 12.dp, vertical = 4.dp)
                ) {
                    Text(statusText, style = MaterialTheme.typography.labelSmall.copy(color = statusColor))
                }
                Spacer(modifier = Modifier.height(4.dp))
                Text(booking.date, style = MaterialTheme.typography.labelSmall)
            }
        }
    }
}

// ── Payment Methods ───────────────────────────────────────────────────────────

@Composable
fun PaymentMethodsScreen(navController: NavController) {
    var selected by remember { mutableStateOf("upi") }

    Scaffold(
        bottomBar = {
            Box(modifier = Modifier.fillMaxWidth().background(SurfaceCard).padding(20.dp)) {
                PrimaryButton(
                    text = "Pay ₹149",
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
                .padding(horizontal = 20.dp)
        ) {
            SwachtaTopBar("Payment Methods", onBack = { navController.popBackStack() })

            Spacer(modifier = Modifier.height(20.dp))

            listOf(
                Triple("upi", "UPI Payment", "📱 Google Pay / PhonePe / Paytm"),
                Triple("card", "Credit / Debit Card", "💳 Visa, Mastercard, RuPay"),
                Triple("cod", "Cash on Pickup", "💵 Pay when our team arrives"),
            ).forEach { (id, label, sub) ->
                SwachtaCard(
                    modifier = Modifier
                        .fillMaxWidth()
                        .clickable { selected = id }
                ) {
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        RadioButton(
                            selected = selected == id,
                            onClick = { selected = id },
                            colors = RadioButtonDefaults.colors(selectedColor = BrandPrimary)
                        )
                        Spacer(modifier = Modifier.width(8.dp))
                        Column {
                            Text(label, style = MaterialTheme.typography.bodySmall)
                            Text(sub, style = MaterialTheme.typography.labelSmall)
                        }
                    }
                }
                Spacer(modifier = Modifier.height(12.dp))
            }
        }
    }
}
