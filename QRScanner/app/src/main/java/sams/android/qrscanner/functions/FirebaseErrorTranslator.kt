package sams.android.qrscanner.functions

import android.content.Context
import sams.android.qrscanner.R

fun translateFirebaseError(errorMessage: String?): String {
    val errorMap = mapOf(
        "The email address is badly formatted." to "La dirección de correo electrónico tiene un formato incorrecto.",
        "There is no user record corresponding to this identifier. The user may have been deleted." to "No hay ningún registro de usuario que corresponda a este identificador. El usuario puede haber sido eliminado.",
        "The password is invalid or the user does not have a password." to "La contraseña no es válida o el usuario no tiene una contraseña.",
        "A network error (such as timeout, interrupted connection or unreachable host) has occurred." to "Ha ocurrido un error de red (como un tiempo de espera, una conexión interrumpida o un host inaccesible).",
        "The supplied auth credential is incorrect, malformed or has expired." to "La credencial de autenticación proporcionada es incorrecta, está malformada o ha caducado."
    )

    return errorMap[errorMessage] ?: "Error desconocido: $errorMessage"
}