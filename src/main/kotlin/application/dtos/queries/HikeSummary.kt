package application.dtos.queries

import java.time.LocalDateTime
import java.util.UUID

data class HikeSummary(
    val hikeId: UUID,
    val title: String,
    val description: String,
    val trailId: String,
    val trailName: String,
    val difficulty: String,
    val startsAt: LocalDateTime,
    val expectedDurationMinutes: Int,
    val registrationDeadline: LocalDateTime,
    val capacity: Int,
    val organizerId: UUID,
    val organizerName: String,
    val remainingPlaces: Int,
    val matchesHikerSkill: Boolean? = null,
)
