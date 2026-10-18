package com.swachta.app.ui.screens.profile

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
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import com.swachta.app.navigation.Screen
import com.swachta.app.ui.components.*
import com.swachta.app.ui.theme.*

// ── Profile Main ──────────────────────────────────────────────────────────────

@Composable
fun ProfileScreen(navController: NavController) {
    val menuItems = listOf(
        Triple(Icons.Rounded.Person, "Personal Details", Screen.PersonalDetails.route),
        Triple(Icons.Rounded.LocationOn, "Saved Addresses", Screen.SavedAddresses.route),
        Triple(Icons.Rounded.EmojiEvents, "Rewards & Impact", Screen.Rewards.route),
        Triple(Icons.Rounded.Payment, "Payment Methods", Screen.PaymentMethods.route),
        Triple(Icons.Rounded.HeadsetMic, "Support", Screen.Support.route),
        Triple(Icons.Rounded.Info, "About Swachta", Screen.About.route),
        Triple(Icons.Rounded.Security, "Account & Security", Screen.AccountSecurity.route),
    )

    Scaffold(
        bottomBar = {
            SwachtaBottomNav(
                currentRoute = Screen.Profile.route,
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
            // Green header with avatar
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .background(Brush.verticalGradient(listOf(BrandDark, BrandPrimary)))
                    .padding(top = 48.dp, bottom = 40.dp)
            ) {
                Column(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalAlignment = Alignment.CenterHorizontally
                ) {
                    Box(
                        modifier = Modifier
                            .size(84.dp)
                            .clip(CircleShape)
                            .background(Color.White),
                        contentAlignment = Alignment.Center
                    ) {
                        Text("SY", fontSize = 28.sp, color = BrandDark)
                    }
                    Spacer(modifier = Modifier.height(12.dp))
                    Text("Shivam Yadav", style = MaterialTheme.typography.headlineMedium.copy(color = Color.White))
                    Text("+91 98765 43210", style = MaterialTheme.typography.labelMedium.copy(color = Color.White.copy(alpha = 0.8f)))
                    Spacer(modifier = Modifier.height(12.dp))
                    Row(
                        horizontalArrangement = Arrangement.spacedBy(12.dp)
                    ) {
                        ProfileStatChip("1240", "Impact Pts")
                        ProfileStatChip("14", "Bookings")
                        ProfileStatChip("Level 2", "Sapling")
                    }
                }
            }

            Spacer(modifier = Modifier.height(16.dp))

            // Menu items
            Column(
                modifier = Modifier.padding(horizontal = 20.dp),
                verticalArrangement = Arrangement.spacedBy(4.dp)
            ) {
                menuItems.forEach { (icon, label, route) ->
                    ProfileMenuItem(icon = icon, label = label, onClick = { navController.navigate(route) })
                }

                Spacer(modifier = Modifier.height(12.dp))

                // Danger zone
                ProfileMenuItem(
                    icon = Icons.Rounded.DeleteForever,
                    label = "Delete Account",
                    onClick = { navController.navigate(Screen.DeleteAccount.route) },
                    tint = AccentDanger
                )
            }

            Spacer(modifier = Modifier.height(32.dp))

            Text(
                "Swachta v1.0.0",
                style = MaterialTheme.typography.labelSmall,
                modifier = Modifier.fillMaxWidth(),
                textAlign = TextAlign.Center
            )
            Spacer(modifier = Modifier.height(16.dp))
        }
    }
}

@Composable
private fun ProfileStatChip(value: String, label: String) {
    Column(
        horizontalAlignment = Alignment.CenterHorizontally,
        modifier = Modifier
            .clip(RoundedCornerShape(12.dp))
            .background(Color.White.copy(alpha = 0.15f))
            .padding(horizontal = 16.dp, vertical = 8.dp)
    ) {
        Text(value, style = MaterialTheme.typography.headlineSmall.copy(color = Color.White))
        Text(label, style = MaterialTheme.typography.labelSmall.copy(color = Color.White.copy(alpha = 0.8f)))
    }
}

@Composable
private fun ProfileMenuItem(
    icon: ImageVector,
    label: String,
    onClick: () -> Unit,
    tint: Color = BrandPrimary
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(12.dp))
            .background(SurfaceCard)
            .clickable { onClick() }
            .padding(horizontal = 16.dp, vertical = 14.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Box(
            modifier = Modifier
                .size(36.dp)
                .clip(RoundedCornerShape(8.dp))
                .background(if (tint == AccentDanger) AccentDanger.copy(alpha = 0.1f) else GreenPale),
            contentAlignment = Alignment.Center
        ) {
            Icon(icon, null, tint = tint, modifier = Modifier.size(20.dp))
        }
        Spacer(modifier = Modifier.width(12.dp))
        Text(label, style = MaterialTheme.typography.bodyMedium.copy(color = if (tint == AccentDanger) tint else TextPrimary), modifier = Modifier.weight(1f))
        Icon(Icons.Rounded.ChevronRight, null, tint = TextSecondary)
    }
}

// ── Sub-screens ───────────────────────────────────────────────────────────────

@Composable
fun PersonalDetailsScreen(navController: NavController) {
    var name by remember { mutableStateOf("Shivam Yadav") }
    var email by remember { mutableStateOf("shiv@swachta.in") }
    var phone by remember { mutableStateOf("+91 98765 43210") }

    Scaffold(
        topBar = { SwachtaTopBar("Personal Details", onBack = { navController.popBackStack() }) },
        bottomBar = {
            Box(modifier = Modifier.fillMaxWidth().background(SurfaceCard).padding(20.dp)) {
                PrimaryButton("Save Changes", onClick = { navController.popBackStack() })
            }
        },
        containerColor = SurfaceBg
    ) { padding ->
        Column(
            modifier = Modifier.padding(padding).padding(horizontal = 20.dp).verticalScroll(rememberScrollState()),
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            Spacer(modifier = Modifier.height(8.dp))
            SwachtaTextField(name, { name = it }, "Full Name", "Your name", leadingIcon = { Icon(Icons.Rounded.Person, null, tint = TextSecondary) })
            SwachtaTextField(email, { email = it }, "Email", "your@email.com", leadingIcon = { Icon(Icons.Rounded.Email, null, tint = TextSecondary) })
            SwachtaTextField(phone, { phone = it }, "Phone", "+91", leadingIcon = { Icon(Icons.Rounded.Phone, null, tint = TextSecondary) })
        }
    }
}

@Composable
fun SavedAddressesScreen(navController: NavController) {
    Scaffold(
        topBar = { SwachtaTopBar("Saved Addresses", onBack = { navController.popBackStack() }) },
        containerColor = SurfaceBg
    ) { padding ->
        Column(
            modifier = Modifier.padding(padding).padding(horizontal = 20.dp).verticalScroll(rememberScrollState()),
            verticalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            Spacer(modifier = Modifier.height(8.dp))
            listOf(
                "Home" to "G-2129, Amrapali Silicon City, Sector 76, Noida - 201309",
                "Work" to "Tower B, Advant Navis Business Park, Sector 142, Noida"
            ).forEach { (label, address) ->
                SwachtaCard(modifier = Modifier.fillMaxWidth()) {
                    Row(verticalAlignment = Alignment.Top) {
                        Box(
                            modifier = Modifier.size(36.dp).clip(CircleShape).background(GreenPale),
                            contentAlignment = Alignment.Center
                        ) {
                            Icon(Icons.Rounded.LocationOn, null, tint = BrandPrimary, modifier = Modifier.size(18.dp))
                        }
                        Spacer(modifier = Modifier.width(10.dp))
                        Column(modifier = Modifier.weight(1f)) {
                            Text(label, style = MaterialTheme.typography.bodySmall)
                            Text(address, style = MaterialTheme.typography.labelMedium)
                        }
                        IconButton(onClick = {}) {
                            Icon(Icons.Rounded.Edit, null, tint = BrandPrimary, modifier = Modifier.size(18.dp))
                        }
                    }
                }
            }
            Spacer(modifier = Modifier.height(8.dp))
            SecondaryButton("+ Add New Address", onClick = {})
        }
    }
}

@Composable
fun RewardsScreen(navController: NavController) {
    Scaffold(
        topBar = { SwachtaTopBar("Rewards", onBack = { navController.popBackStack() }) },
        containerColor = SurfaceBg
    ) { padding ->
        Column(
            modifier = Modifier.padding(padding).padding(horizontal = 20.dp).verticalScroll(rememberScrollState())
        ) {
            Spacer(modifier = Modifier.height(16.dp))
            // Referral card
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .clip(RoundedCornerShape(20.dp))
                    .background(Brush.linearGradient(listOf(BrandDark, BrandPrimary)))
                    .padding(20.dp)
            ) {
                Column {
                    Text("Refer & Earn", style = MaterialTheme.typography.headlineMedium.copy(color = Color.White))
                    Spacer(modifier = Modifier.height(4.dp))
                    Text("Share your code and earn 25 CC + ₹50 wallet bonus", style = MaterialTheme.typography.bodySmall.copy(color = Color.White.copy(0.85f)))
                    Spacer(modifier = Modifier.height(12.dp))
                    Box(
                        modifier = Modifier.fillMaxWidth().clip(RoundedCornerShape(12.dp)).background(Color.White.copy(0.15f)).padding(12.dp),
                        contentAlignment = Alignment.Center
                    ) {
                        Text("SHANTI2025", style = MaterialTheme.typography.headlineLarge.copy(color = Color.White, letterSpacing = androidx.compose.ui.unit.TextUnit(3f, androidx.compose.ui.unit.TextUnitType.Sp)))
                    }
                    Spacer(modifier = Modifier.height(12.dp))
                    PrimaryButton("📤 Share Invite Link", onClick = {})
                }
            }
        }
    }
}

@Composable
fun SupportScreen(navController: NavController) {
    Scaffold(
        topBar = { SwachtaTopBar("Support", onBack = { navController.popBackStack() }) },
        containerColor = SurfaceBg
    ) { padding ->
        Column(
            modifier = Modifier.padding(padding).padding(horizontal = 20.dp).verticalScroll(rememberScrollState()),
            verticalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            Spacer(modifier = Modifier.height(8.dp))
            listOf(
                "📞" to "Call Support" to "Available 8am – 8pm",
                "💬" to "Live Chat" to "Typically replies in 5 mins",
                "✉️" to "Email Us" to "support@swachta.in",
                "❓" to "FAQ" to "Common questions answered"
            ).forEach { (iconLabel, sub) ->
                val (emoji, label) = iconLabel
                SwachtaCard(modifier = Modifier.fillMaxWidth().clickable {}) {
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Text(emoji, fontSize = 24.sp)
                        Spacer(modifier = Modifier.width(12.dp))
                        Column(modifier = Modifier.weight(1f)) {
                            Text(label, style = MaterialTheme.typography.bodySmall)
                            Text(sub, style = MaterialTheme.typography.labelSmall)
                        }
                        Icon(Icons.Rounded.ChevronRight, null, tint = TextSecondary)
                    }
                }
            }
        }
    }
}

@Composable
fun AboutScreen(navController: NavController) {
    Scaffold(
        topBar = { SwachtaTopBar("About Swachta", onBack = { navController.popBackStack() }) },
        containerColor = SurfaceBg
    ) { padding ->
        Column(
            modifier = Modifier.padding(padding).padding(horizontal = 20.dp).verticalScroll(rememberScrollState()),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Spacer(modifier = Modifier.height(24.dp))
            val context = androidx.compose.ui.platform.LocalContext.current
            val logoId = remember {
                context.resources.getIdentifier("logo", "drawable", context.packageName)
            }
            if (logoId != 0) {
                androidx.compose.foundation.Image(
                    painter = androidx.compose.ui.res.painterResource(id = logoId),
                    contentDescription = "Swachta Logo",
                    modifier = Modifier.size(100.dp)
                )
            } else {
                Text("🚛", fontSize = 64.sp)
            }
            Spacer(modifier = Modifier.height(8.dp))
            Text("SWACHTA", style = MaterialTheme.typography.displayMedium.copy(color = BrandDark))
            Text("Saaf Sheher. Sahi Daam.", style = MaterialTheme.typography.labelMedium)
            Spacer(modifier = Modifier.height(24.dp))
            SwachtaCard(modifier = Modifier.fillMaxWidth()) {
                Text(
                    "Swachta is India's first on-demand sanitation platform. We connect households and businesses with trained, uniformed sanitation workers for daily garbage pickup, scrap sales, recyclable waste disposal, and large dump removal.\n\nOur AI-powered waste detection ensures transparent, fair pricing for all scrap items.",
                    style = MaterialTheme.typography.bodyMedium.copy(color = TextSecondary)
                )
            }
            Spacer(modifier = Modifier.height(16.dp))
            Text("Version 1.0.0", style = MaterialTheme.typography.labelSmall)
            Text("© 2026 Swachta Technologies Pvt Ltd", style = MaterialTheme.typography.labelSmall)
        }
    }
}

@Composable
fun AccountSecurityScreen(navController: NavController) {
    Scaffold(
        topBar = { SwachtaTopBar("Account & Security", onBack = { navController.popBackStack() }) },
        containerColor = SurfaceBg
    ) { padding ->
        Column(
            modifier = Modifier.padding(padding).padding(horizontal = 20.dp).verticalScroll(rememberScrollState()),
            verticalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            Spacer(modifier = Modifier.height(8.dp))
            listOf("Change Phone Number", "Change Password", "Two-Factor Authentication", "Privacy Settings", "Connected Accounts").forEach { item ->
                SwachtaCard(modifier = Modifier.fillMaxWidth().clickable {}) {
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Text(item, style = MaterialTheme.typography.bodyMedium, modifier = Modifier.weight(1f))
                        Icon(Icons.Rounded.ChevronRight, null, tint = TextSecondary)
                    }
                }
            }
        }
    }
}

@Composable
fun DeleteAccountScreen(navController: NavController) {
    var confirmed by remember { mutableStateOf(false) }

    Scaffold(
        topBar = { SwachtaTopBar("Delete Account", onBack = { navController.popBackStack() }) },
        containerColor = SurfaceBg
    ) { padding ->
        Column(
            modifier = Modifier.padding(padding).padding(24.dp).verticalScroll(rememberScrollState()),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Spacer(modifier = Modifier.height(16.dp))
            Text("⚠️", fontSize = 56.sp)
            Spacer(modifier = Modifier.height(16.dp))
            Text("Delete Your Account?", style = MaterialTheme.typography.headlineLarge, textAlign = TextAlign.Center)
            Spacer(modifier = Modifier.height(12.dp))
            Text(
                "This action is permanent and cannot be undone. All your bookings, impact points, and rewards will be lost.",
                style = MaterialTheme.typography.bodyLarge.copy(color = TextSecondary),
                textAlign = TextAlign.Center
            )
            Spacer(modifier = Modifier.height(24.dp))
            Row(verticalAlignment = Alignment.CenterVertically) {
                Checkbox(
                    checked = confirmed,
                    onCheckedChange = { confirmed = it },
                    colors = CheckboxDefaults.colors(checkedColor = AccentDanger)
                )
                Spacer(modifier = Modifier.width(8.dp))
                Text("I understand this action is irreversible", style = MaterialTheme.typography.bodySmall)
            }
            Spacer(modifier = Modifier.height(24.dp))
            Button(
                onClick = { if (confirmed) navController.navigate(Screen.Onboarding.route) { popUpTo(0) } },
                enabled = confirmed,
                modifier = Modifier.fillMaxWidth().height(54.dp),
                shape = RoundedCornerShape(28.dp),
                colors = ButtonDefaults.buttonColors(containerColor = AccentDanger)
            ) {
                Text("Delete My Account", style = MaterialTheme.typography.labelLarge)
            }
            Spacer(modifier = Modifier.height(12.dp))
            SecondaryButton("Keep My Account", onClick = { navController.popBackStack() })
        }
    }
}
