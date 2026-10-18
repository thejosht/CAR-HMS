package application.usecases

import application.dtos.queries.ChangeMembershipStatusRequest
import application.dtos.queries.RecordOrganizerCertificationRequest
import application.dtos.queries.UpdateHikerRequest

interface UpdateHiker {
    fun updateHiker(request: UpdateHikerRequest)

    fun changeMembershipStatus(request: ChangeMembershipStatusRequest)

    fun recordOrganizerCertification(request: RecordOrganizerCertificationRequest)
}
