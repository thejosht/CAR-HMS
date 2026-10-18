package application.dtos.queries

import java.util.UUID

data class CancelSignUpRequest(
    val hikerId: UUID,
    val registrationId: UUID,
)
