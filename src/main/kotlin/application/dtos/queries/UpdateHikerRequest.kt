package application.dtos.queries

import java.time.LocalDate
import java.util.UUID

data class UpdateHikerRequest(
    val hikerId: UUID,
    val name: String,
    val email: String,
    val phone: String,
    val address: String,
    val dateOfBirth: LocalDate,
    val emergencyContactName: String,
    val emergencyContactPhone: String,
    val skillLevel: String,
)
