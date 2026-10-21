package application.usecases

import application.dtos.queries.CancelSignUpRequest

interface CancelSignUp {
    fun cancelSignUp(request: CancelSignUpRequest)
}
