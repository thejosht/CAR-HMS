package application.dtos.queries

import java.time.LocalDate

class RegisterHikerRequest(
    val invitationCode: String,
    val name: String,
    val email: String,
    val password: String,
    val phone: String,
    val address: String,
    val dateOfBirth: LocalDate,
    val emergencyContactName: String,
    val emergencyContactPhone: String,
    val skillLevel: String,
    val waiverAccepted: Boolean,
    val legalGuardianName: String? = null,
)
