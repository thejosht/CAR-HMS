package application.dtos.queries

import java.util.UUID

data class ChangeMembershipStatusRequest(
    val administratorId: UUID,
    val hikerId: UUID,
    val membershipStatus: String,
)
