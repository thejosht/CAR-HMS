package application.dtos.queries

import java.util.UUID

data class SignUpForHikeRequest(
    val hikerId: UUID,
    val hikeId: UUID,
)
