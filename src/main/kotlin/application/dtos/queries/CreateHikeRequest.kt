package application.dtos.queries

import java.time.LocalDateTime
import java.util.UUID

data class CreateHikeRequest(
    val organizerId: UUID,
    val title: String,
    val description: String,
    val trailId: String,
    val startsAt: LocalDateTime,
    val expectedDurationMinutes: Int,
    val registrationDeadline: LocalDateTime,
    val capacity: Int,
)
