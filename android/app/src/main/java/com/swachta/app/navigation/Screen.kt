package com.swachta.app.navigation

sealed class Screen(val route: String) {
    // Splash & Onboarding
    object Splash : Screen("splash")
    object Onboarding : Screen("onboarding")

    // Auth
    object SignUp : Screen("signup")
    object Login : Screen("login")
    object OTP : Screen("otp/{phone}") {
        fun createRoute(phone: String) = "otp/$phone"
    }
    object Verified : Screen("verified")

    // Location
    object Location : Screen("location")

    // Main tabs
    object Home : Screen("home")
    object Impact : Screen("impact")
    object Reels : Screen("reels")
    object Bookings : Screen("bookings")
    object Profile : Screen("profile")

    // Service flows
    object DailyGarbage : Screen("service/daily-garbage")
    object LargeDump : Screen("service/large-dump")
    object RecyclableWaste : Screen("service/recyclable-waste")
    object ScrapItems : Screen("service/scrap-items")
    object Camera : Screen("camera")

    // Booking
    object PaymentMethods : Screen("payment")
    object BookingConfirmed : Screen("booking-confirmed")

    // Profile sub-screens
    object PersonalDetails : Screen("profile/personal-details")
    object SavedAddresses : Screen("profile/saved-addresses")
    object Rewards : Screen("profile/rewards")
    object Support : Screen("profile/support")
    object About : Screen("profile/about")
    object AccountSecurity : Screen("profile/account-security")
    object DeleteAccount : Screen("profile/delete-account")
}
