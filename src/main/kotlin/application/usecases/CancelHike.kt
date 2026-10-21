package application.usecases

import application.dtos.queries.CancelHikeRequest

interface CancelHike {
    fun cancelHike(request: CancelHikeRequest)
}