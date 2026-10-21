package application.usecases

import application.dtos.queries.BrowseHikeRequest

interface BrowseHike {
    // Note: Since this is a "browse" or "search" feature, 
    // it usually returns a List of hikes. You will need to 
    // change 'Any' to whatever your Hike domain object is called.
    fun browseHike(request: BrowseHikeRequest): List<Any> 
}