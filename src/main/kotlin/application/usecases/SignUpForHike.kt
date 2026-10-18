package application.usecases

import application.dtos.queries.SignUpForHikeRequest
import java.util.UUID

interface SignUpForHike {
    fun signUpForHike(request: SignUpForHikeRequest): UUID
}
