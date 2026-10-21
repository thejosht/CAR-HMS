package application.usecases

import application.dtos.queries.BrowseHikeRequest
import application.dtos.queries.HikeSummary

interface BrowseHike {
    fun browseHike(request: BrowseHikeRequest): List<HikeSummary>
}
