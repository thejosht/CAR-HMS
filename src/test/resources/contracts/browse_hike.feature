@browseHike
Feature: Browse open hikes
  Visitors and registered users can browse without changing domain state.
  An authenticated hiker identity comes from the session, not unchecked form input.

  Background:
    Given the current Ottawa time is "2026-10-21T09:00"
    And the system contains:
      | hikeId | trailName | date       | difficulty     | status    | remainingPlaces |
      | hike-1 | Pine      | 2026-10-25 | EASY           | OPEN      | 3               |
      | hike-2 | Lake      | 2026-10-24 | MODERATE       | OPEN      | 5               |
      | hike-3 | Pine      | 2026-10-26 | DIFFICULT      | OPEN      | 2               |
      | hike-4 | Ridge     | 2026-10-27 | VERY_DIFFICULT | OPEN      | 1               |
      | hike-5 | Pine      | 2026-10-25 | EASY           | FULL      | 0               |
      | hike-6 | Pine      | 2026-10-25 | EASY           | CLOSED    | 2               |
      | hike-7 | Pine      | 2026-10-25 | EASY           | CANCELLED | 3               |
      | hike-8 | Pine      | 2026-10-20 | EASY           | FINISHED  | 1               |
    And each open hike has a registration deadline later than the current time

  Scenario: A visitor lists open hikes in date order
    Given the request has no filters and no hiker identity
    When browseHike is called with the request
    Then the returned hike IDs are "hike-2, hike-1, hike-3, hike-4" in that order
    And each result includes the hike details, organizer, trail difficulty and remaining places
    And matchesHikerSkill is absent for a visitor
    And no hike, registration or lifecycle history is changed

  Scenario Outline: Apply a supported search filter
    Given the request sets "<field>" to "<value>"
    When browseHike is called with the request
    Then the returned hike IDs are "<results>" in date order

    Examples:
      | field      | value      | results        |
      | trailName  | Pine       | hike-1, hike-3 |
      | date       | 2026-10-24 | hike-2         |
      | difficulty | DIFFICULT  | hike-3         |

  Scenario: Combine filters
    Given the request specifies trail "Pine", date "2026-10-25" and difficulty "EASY"
    When browseHike is called with the request
    Then only "hike-1" is returned

  Scenario: Return an empty list when nothing matches
    Given the request specifies trail "Unknown trail"
    When browseHike is called with the request
    Then an empty list is returned without an error

  Scenario: Identify hikes matching the signed-in hiker's skill
    Given the authenticated hiker has skill level "INTERMEDIATE"
    And the request uses that authenticated hiker identity
    When browseHike is called with the request
    Then "hike-1", "hike-2" and "hike-3" have matchesHikerSkill set to true
    And "hike-4" has matchesHikerSkill set to false
    And no non-open hike is returned

  Scenario: Do not expose another hiker's personalized results
    Given the request claims a hiker identity different from the authenticated session
    When browseHike is called with the request
    Then the request is refused without revealing that hiker's profile

  Scenario: Exclude a hike whose closing task has not yet run
    Given hike "hike-1" still has stored status "OPEN"
    And its registration deadline has already been reached
    When browseHike is called without filters
    Then "hike-1" is not returned as an open hike

  Scenario: Refuse an unknown difficulty value
    Given the request difficulty is "UNKNOWN"
    When browseHike is called with the request
    Then the request is refused with a validation error
