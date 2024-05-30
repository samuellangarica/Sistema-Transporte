package sams.android.qrscanner

import android.content.Context
import android.content.pm.PackageManager
import android.os.Bundle
import android.widget.Toast
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Button
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.core.content.ContextCompat
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.database.DataSnapshot
import com.google.firebase.database.DatabaseError
import com.google.firebase.database.DatabaseReference
import com.google.firebase.database.FirebaseDatabase
import com.google.firebase.database.ValueEventListener
import com.journeyapps.barcodescanner.ScanContract
import com.journeyapps.barcodescanner.ScanOptions
import sams.android.qrscanner.ui.theme.QRScannerTheme
import sams.android.qrscanner.navigation.AppNavigation

class MainActivity : ComponentActivity() {

    public lateinit var auth: FirebaseAuth
    private lateinit var ticketsRef: DatabaseReference


    var textResult = mutableStateOf("")
    var alertText = mutableStateOf("")

    val barCodeLauncher = registerForActivityResult(ScanContract()) {
        result ->
        if(result.contents == null){
            Toast.makeText(this@MainActivity, "Cancelled", Toast.LENGTH_SHORT).show()
        }
        else {
            textResult.value = result.contents
            checkTicket(textResult.value)
        }
    }
    private fun checkTicket(uid: String) {
        ticketsRef.child(uid).addListenerForSingleValueEvent(object : ValueEventListener {
            override fun onDataChange(dataSnapshot: DataSnapshot) {
                if (!dataSnapshot.exists()) {
                    alertText.value = "El QR es inválido"
                } else {
                    val utilizado = dataSnapshot.child("utilizado").getValue(Boolean::class.java) ?: false
                    if (utilizado){
                        alertText.value = "El boleto ya fue utilizado"
                    } else {
                        alertText.value = "Buen viaje!"
                        ticketsRef.child(uid).child("utilizado").setValue(true)
                    }
                }
            }

            override fun onCancelled(databaseError: DatabaseError) {
                Toast.makeText(this@MainActivity, "Database error: ${databaseError.message}", Toast.LENGTH_SHORT).show()
            }
        })
    }


    fun showCamera() {
        val options = ScanOptions()
        options.setDesiredBarcodeFormats(ScanOptions.QR_CODE)
        options.setPrompt("Scan a QR code")
        options.setCameraId(0)
        options.setBeepEnabled(false)
        options.setOrientationLocked(true)

        barCodeLauncher.launch(options)
    }

    val requestPermissionLauncher = registerForActivityResult(
        ActivityResultContracts.RequestPermission()
    ){
        isGranted ->
        if (isGranted) {
            showCamera()
        }

    }



    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        ticketsRef = FirebaseDatabase.getInstance().getReference("tickets")
        setContent {
            QRScannerTheme {
                Surface {
                    AppNavigation(this, textResult)
                    ShowQRAlertDialog(alertText)
                }

            }

        }
    }

    fun checkCameraPermission(context: Context){
        if(ContextCompat.checkSelfPermission(
            context,
            android.Manifest.permission.CAMERA
        ) == PackageManager.PERMISSION_GRANTED){
            showCamera()
        }
        else if (shouldShowRequestPermissionRationale(android.Manifest.permission.CAMERA)){
            Toast.makeText(this@MainActivity, "Camera required", Toast.LENGTH_SHORT).show()
        }
        else{
            requestPermissionLauncher.launch(android.Manifest.permission.CAMERA)
        }
    }
}
@Composable
fun ShowQRAlertDialog(alertText: MutableState<String>) {
    var showDialog by remember { mutableStateOf(false) }

    LaunchedEffect(alertText.value) {
        if (alertText.value.isNotEmpty()) {
            showDialog = true
        }
    }

    if (showDialog) {
        AlertDialog(
            onDismissRequest = { showDialog = false },
            title = { Text(text = "Scanned QR Code") },
            text = { Text(text = alertText.value) },
            confirmButton = {
                Button(onClick = { showDialog = false }) {
                    Text("OK")
                }
            }
        )
    }
}
