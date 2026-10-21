package application.usecases

import application.dtos.queries.RegisterHikerRequest
import java.util.UUID

interface RegisterHiker {
    fun registerHiker(request: RegisterHikerRequest): UUID
}
