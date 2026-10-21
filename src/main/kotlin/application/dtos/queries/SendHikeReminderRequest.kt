package application.dtos.queries

import java.util.UUID

data class SendHikeReminderRequest(
    val hikeId: UUID,
)
