package application.usecases

import application.dtos.queries.CloseHikeRequest

interface CloseHike {
    fun closeHike(request: CloseHikeRequest)
}