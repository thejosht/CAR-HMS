package application.usecases

import application.dtos.queries.CreateHikeRequest
import java.util.UUID

interface CreateHike {
    fun createHike(request: CreateHikeRequest): UUID
}