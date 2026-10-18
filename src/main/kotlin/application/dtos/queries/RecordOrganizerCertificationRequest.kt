package application.dtos.queries

import java.time.LocalDate
import java.util.UUID

data class RecordOrganizerCertificationRequest(
    val administratorId: UUID,
    val hikerId: UUID,
    val certificateNumber: String,
    val issuedOn: LocalDate,
    val expiresOn: LocalDate,
    val organizerLevel: String,
)
