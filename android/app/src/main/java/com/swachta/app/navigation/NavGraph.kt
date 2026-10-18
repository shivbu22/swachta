package com.swachta.app.navigation

import androidx.compose.runtime.Composable
import androidx.navigation.NavHostController
import androidx.navigation.NavType
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.navArgument
import com.swachta.app.ui.screens.about.AboutScreen
import com.swachta.app.ui.screens.auth.LoginScreen
import com.swachta.app.ui.screens.auth.OTPScreen
import com.swachta.app.ui.screens.auth.SignUpScreen
import com.swachta.app.ui.screens.auth.VerifiedScreen
import com.swachta.app.ui.screens.booking.BookingConfirmedScreen
import com.swachta.app.ui.screens.booking.MyBookingsScreen
import com.swachta.app.ui.screens.booking.PaymentMethodsScreen
import com.swachta.app.ui.screens.camera.CameraScreen
import com.swachta.app.ui.screens.home.HomeScreen
import com.swachta.app.ui.screens.impact.ImpactScreen
import com.swachta.app.ui.screens.location.LocationScreen
import com.swachta.app.ui.screens.onboarding.OnboardingScreen
import com.swachta.app.ui.screens.onboarding.SplashScreen
import com.swachta.app.ui.screens.profile.AccountSecurityScreen
import com.swachta.app.ui.screens.profile.DeleteAccountScreen
import com.swachta.app.ui.screens.profile.PersonalDetailsScreen
import com.swachta.app.ui.screens.profile.ProfileScreen
import com.swachta.app.ui.screens.profile.RewardsScreen
import com.swachta.app.ui.screens.profile.SavedAddressesScreen
import com.swachta.app.ui.screens.profile.SupportScreen
import com.swachta.app.ui.screens.reels.ReelsScreen
import com.swachta.app.ui.screens.services.DailyGarbageScreen
import com.swachta.app.ui.screens.services.LargeDumpScreen
import com.swachta.app.ui.screens.services.RecyclableWasteScreen
import com.swachta.app.ui.screens.services.ScrapItemsScreen

@Composable
fun SwachtaNavGraph(navController: NavHostController) {
    NavHost(
        navController = navController,
        startDestination = Screen.Splash.route
    ) {
        // Splash & Onboarding
        composable(Screen.Splash.route) {
            SplashScreen(navController = navController)
        }
        composable(Screen.Onboarding.route) {
            OnboardingScreen(navController = navController)
        }

        // Auth
        composable(Screen.SignUp.route) {
            SignUpScreen(navController = navController)
        }
        composable(Screen.Login.route) {
            LoginScreen(navController = navController)
        }
        composable(
            route = Screen.OTP.route,
            arguments = listOf(navArgument("phone") { type = NavType.StringType })
        ) { backStack ->
            val phone = backStack.arguments?.getString("phone") ?: ""
            OTPScreen(navController = navController, phone = phone)
        }
        composable(Screen.Verified.route) {
            VerifiedScreen(navController = navController)
        }

        // Location
        composable(Screen.Location.route) {
            LocationScreen(navController = navController)
        }

        // Main screens
        composable(Screen.Home.route) {
            HomeScreen(navController = navController)
        }
        composable(Screen.Impact.route) {
            ImpactScreen(navController = navController)
        }
        composable(Screen.Reels.route) {
            ReelsScreen(navController = navController)
        }
        composable(Screen.Bookings.route) {
            MyBookingsScreen(navController = navController)
        }
        composable(Screen.Profile.route) {
            ProfileScreen(navController = navController)
        }

        // Services
        composable(Screen.DailyGarbage.route) {
            DailyGarbageScreen(navController = navController)
        }
        composable(Screen.LargeDump.route) {
            LargeDumpScreen(navController = navController)
        }
        composable(Screen.RecyclableWaste.route) {
            RecyclableWasteScreen(navController = navController)
        }
        composable(Screen.ScrapItems.route) {
            ScrapItemsScreen(navController = navController)
        }
        composable(Screen.Camera.route) {
            CameraScreen(navController = navController)
        }

        // Payment & Confirmation
        composable(Screen.PaymentMethods.route) {
            PaymentMethodsScreen(navController = navController)
        }
        composable(Screen.BookingConfirmed.route) {
            BookingConfirmedScreen(navController = navController)
        }

        // Profile sub-screens
        composable(Screen.PersonalDetails.route) {
            PersonalDetailsScreen(navController = navController)
        }
        composable(Screen.SavedAddresses.route) {
            SavedAddressesScreen(navController = navController)
        }
        composable(Screen.Rewards.route) {
            RewardsScreen(navController = navController)
        }
        composable(Screen.Support.route) {
            SupportScreen(navController = navController)
        }
        composable(Screen.About.route) {
            AboutScreen(navController = navController)
        }
        composable(Screen.AccountSecurity.route) {
            AccountSecurityScreen(navController = navController)
        }
        composable(Screen.DeleteAccount.route) {
            DeleteAccountScreen(navController = navController)
        }
    }
}
