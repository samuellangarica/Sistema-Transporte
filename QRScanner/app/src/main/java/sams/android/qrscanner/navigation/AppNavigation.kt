package sams.android.qrscanner.navigation

import androidx.compose.runtime.*
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.ktx.auth
import com.google.firebase.ktx.Firebase
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import sams.android.qrscanner.LoginScreen
import sams.android.qrscanner.MainActivity
import sams.android.qrscanner.screen.HomeScreen
import sams.android.qrscanner.screen.ScannerScreen

@Composable
fun AppNavigation(mainActivity: MainActivity, textResult: MutableState<String>) {
    val navController = rememberNavController()

    NavHost(navController = navController, startDestination = if (Firebase.auth.currentUser != null) "scanner" else "login") {
        composable("home") { HomeScreen(navController) }
        composable("login") { LoginScreen(navController) }
        composable("scanner") { ScannerScreen(navController, mainActivity, textResult) }
    }
}
