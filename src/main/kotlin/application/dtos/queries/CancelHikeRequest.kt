package application.dtos.queries

import java.util.UUID

data class CancelHikeRequest(
    val actorId: UUID,
    val hikeId: UUID,
    val reason: String,
)
