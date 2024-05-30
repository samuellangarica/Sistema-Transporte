package sams.android.qrscanner.screen

import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Logout
import androidx.compose.material.icons.filled.Person
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import androidx.navigation.compose.rememberNavController
import coil.compose.AsyncImage
import com.google.firebase.auth.ktx.auth
import com.google.firebase.ktx.Firebase
import sams.android.qrscanner.MainActivity
import sams.android.qrscanner.ui.theme.QRScannerTheme

@Composable
fun ScannerScreen(navController: NavController, mainActivity: MainActivity, textResult: MutableState<String>) {
    var scannedValue by remember { mutableStateOf("") }
    var showDialog by remember { mutableStateOf(false) }

    fun handleScannedValue(scannedValue: String) {
        textResult.value = scannedValue
        showDialog = true
    }

    fun startQRCodeScanner() {
        mainActivity.checkCameraPermission(mainActivity)
    }

    fun logout(navController: NavController) {
        Firebase.auth.signOut()
        navController.navigate("login")
    }

    QRScannerTheme {
        Surface(
            color = MaterialTheme.colorScheme.background
        ) {
            Box(modifier = Modifier.fillMaxSize()) {
                Column(
                    modifier = Modifier.fillMaxSize(),
                    horizontalAlignment = Alignment.CenterHorizontally,
                    verticalArrangement = Arrangement.SpaceBetween
                ) {
                    Spacer(modifier = Modifier.height(16.dp))

                    Card(
                        modifier = Modifier
                            .padding(16.dp)
                            .shadow(4.dp, RoundedCornerShape(8.dp)),
                        shape = RoundedCornerShape(8.dp),
                        colors = CardDefaults.cardColors(
                            containerColor = MaterialTheme.colorScheme.primary
                        ),
                        elevation = CardDefaults.cardElevation(defaultElevation = 4.dp)
                    ) {
                        Column(
                            modifier = Modifier
                                .padding(16.dp)
                                .wrapContentWidth(),
                            horizontalAlignment = Alignment.CenterHorizontally
                        ) {
                            Text(
                                text = "Escanea el boleto \n del pasajero",
                                style = TextStyle(
                                    fontSize = 24.sp,
                                    fontFamily = MaterialTheme.typography.headlineLarge.fontFamily,
                                    color = MaterialTheme.colorScheme.onPrimary,
                                    fontWeight = FontWeight.Bold
                                ),
                                textAlign = TextAlign.Center,
                                modifier = Modifier.align(Alignment.CenterHorizontally)
                            )

                            Icon(
                                imageVector = Icons.Filled.Person,
                                contentDescription = "User Icon",
                                tint = MaterialTheme.colorScheme.onPrimary,
                                modifier = Modifier.size(24.dp)
                            )
                        }
                    }

                    Spacer(modifier = Modifier.height(16.dp))

                    Box(
                        modifier = Modifier
                            .fillMaxWidth()
                            .aspectRatio(1f) // Keeps the aspect ratio of the image
                            .background(Color.LightGray, RoundedCornerShape(8.dp))
                            .border(BorderStroke(2.dp, Color.Gray), RoundedCornerShape(8.dp)),
                        contentAlignment = Alignment.Center
                    ) {
                        AsyncImage(
                            model = "file:///android_asset/qr-code.png",
                            contentDescription = "Sample Image",
                            contentScale = ContentScale.Crop,
                            modifier = Modifier.fillMaxSize()
                        )
                    }

                    Spacer(modifier = Modifier.height(16.dp))

                    Button(
                        onClick = { startQRCodeScanner() },
                        modifier = Modifier
                            .width(250.dp)
                            .height(60.dp)
                            .padding(bottom = 16.dp)
                    ) {
                        Text(
                            text = "Escanear Boleto",
                            style = TextStyle(
                                fontSize = 20.sp,
                                fontWeight = FontWeight.Bold
                            )
                        )
                    }
                }

                IconButton(
                    onClick = { logout(navController) },
                    modifier = Modifier.align(Alignment.TopEnd).padding(16.dp)
                ) {
                    Icon(
                        imageVector = Icons.Filled.Logout,
                        contentDescription = "Logout Icon",
                        tint = Color.Black
                    )
                }

                if (showDialog) {
                    AlertDialog(
                        onDismissRequest = { showDialog = false },
                        title = { Text(text = "Have a good trip", style = TextStyle(fontWeight = FontWeight.Bold)) },
                        text = { Text(text = scannedValue, style = TextStyle(fontWeight = FontWeight.Bold)) },
                        confirmButton = {
                            Button(
                                onClick = { showDialog = false }
                            ) {
                                Text("OK", style = TextStyle(fontWeight = FontWeight.Bold))
                            }
                        }
                    )
                }
            }
        }
    }
}

@Preview(showBackground = true)
@Composable
fun PreviewScannerScreen() {
    ScannerScreen(navController = rememberNavController(), mainActivity = MainActivity(), textResult = remember { mutableStateOf("") })
}
