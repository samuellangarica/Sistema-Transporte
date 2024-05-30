package sams.android.qrscanner

import sams.android.qrscanner.functions.translateFirebaseError
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Button
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.SnackbarHost
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.TextField
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import androidx.navigation.compose.rememberNavController
import coil.compose.rememberImagePainter
import com.google.firebase.FirebaseError
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.ktx.auth
import com.google.firebase.ktx.Firebase
import kotlinx.coroutines.launch
import sams.android.qrscanner.ui.theme.QRScannerTheme

@Composable
fun LoginScreen(navController: NavController) {

    var email by remember { mutableStateOf("") }
    var password by remember { mutableStateOf("") }

    // Snack bar alert on authentication failure
    val snackbarHostState = remember {SnackbarHostState()}
    val coroutineScope = rememberCoroutineScope()


    QRScannerTheme{
        Surface(
            color = MaterialTheme.colorScheme.background
        ){
            Column(
                modifier = Modifier.fillMaxSize(),
                horizontalAlignment = Alignment.CenterHorizontally,
                verticalArrangement = Arrangement.spacedBy(16.dp, Alignment.CenterVertically)
            ) {

                Box(
                    modifier = Modifier
                        .width(300.dp) // Matches the image's width
                        .shadow(4.dp, shape = RoundedCornerShape(16.dp))
                        .background(MaterialTheme.colorScheme.surface)
                        .padding(16.dp),
                    contentAlignment = Alignment.Center // Aligns content in the center of the Box
                ) {
                    Column(
                        horizontalAlignment = Alignment.CenterHorizontally,
                        verticalArrangement = Arrangement.spacedBy(16.dp, Alignment.CenterVertically)
                    ) {
                        Text(
                            text = "ViajeSimple", // Replace with your app's name
                            style = MaterialTheme.typography.headlineLarge,
                            color = MaterialTheme.colorScheme.primary,
                            fontWeight = FontWeight.Bold
                        )
                        Image(
                            painter = rememberImagePainter("file:///android_asset/qr-code.png"), // Replace with your image resource
                            contentDescription = "App Logo",
                            modifier = Modifier.size(300.dp)
                        )
                    }
                }


                TextField(
                    value = email,
                    onValueChange = { email = it },
                    shape = RoundedCornerShape(16.dp),
                    label = { Text("Correo") }
                )
                TextField(
                    value = password,
                    onValueChange = { password = it },
                    shape = RoundedCornerShape(16.dp),
                    label = { Text("Contraseña") }
                )
                Button(
                    onClick = {
                        when {
                            email.isEmpty() -> {
                                coroutineScope.launch {
                                    snackbarHostState.showSnackbar("El campo de correo electrónico está vacío.")
                                }
                            }
                            password.isEmpty() -> {
                                coroutineScope.launch {
                                    snackbarHostState.showSnackbar("El campo de contraseña está vacío.")
                                }
                            }
                            else -> {
                                Firebase.auth.signInWithEmailAndPassword(email, password)
                                    .addOnCompleteListener { task ->
                                        if (task.isSuccessful) {
                                            navController.navigate("scanner")
                                        } else {
                                            coroutineScope.launch {
                                                snackbarHostState.showSnackbar(translateFirebaseError(task.exception?.message))
                                            }
                                        }
                                    }
                            }
                        }
                    },
                    Modifier.width(300.dp)
                ) {
                    Text(text = "Iniciar Sesión")
                }
                SnackbarHost(
                    hostState = snackbarHostState,
                    modifier = Modifier.align(Alignment.CenterHorizontally)
                )

            }
        }
    }
}
@Preview
@Composable
fun PreviewLogin () {
    LoginScreen(navController = rememberNavController())
}

