package application.dtos.queries

import java.time.LocalDate
import java.util.UUID

data class BrowseHikeRequest(
    val trailName: String? = null,
    val date: LocalDate? = null,
    val difficulty: String? = null,
    val hikerId: UUID? = null,
)
