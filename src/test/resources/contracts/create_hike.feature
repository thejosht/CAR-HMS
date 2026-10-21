@createHike
Feature: Create a hike
  The organizer identity comes from the authenticated session.
  Trail difficulty and the meeting point come from NCC information.

  Background:
    Given the current Ottawa time is "2026-10-15T09:00"
    And an approved organizer "organizer-1" is authenticated
    And their certificate is issued on "2026-01-01" and expires on "2026-12-31"
    And they can lead "DIFFICULT" hikes
    And NCC trail "trail-1" permits hiking, is open on "2026-10-31" and has difficulty "MODERATE"
    And a create request contains:
      | organizerId | title       | description      | trailId | startsAt         | expectedDurationMinutes | registrationDeadline | capacity |
      | organizer-1 | Autumn hike | A morning outing | trail-1 | 2026-10-31T10:00 | 120                     | 2026-10-28T10:00     | 12       |

  Scenario: Create a valid hike
    When createHike is called with the request
    Then a unique hike UUID is returned
    And the hike is stored with status "OPEN" and all requested details
    And its difficulty and meeting point come from trail "trail-1"
    And "organizer-1" is recorded as responsible for opening the hike
    And the hike has 12 available places

  Scenario Outline: Refuse incomplete or invalid details
    Given the request field "<field>" contains "<value>"
    When createHike is called with the request
    Then the request is refused with a validation error
    And no hike or lifecycle record is created

    Examples:
      | field                   | value |
      | title                   |       |
      | description             |       |
      | trailId                 |       |
      | capacity                | 0     |
      | capacity                | -1    |
      | expectedDurationMinutes | 0     |
      | expectedDurationMinutes | -15   |

  Scenario Outline: Refuse an unauthorized caller
    Given the caller is "<caller>"
    When createHike is called with the request
    Then the request is refused
    And no hike is created

    Examples:
      | caller                                      |
      | a visitor without a session                 |
      | a hiker who is not an approved organizer     |
      | an organizer claiming another organizer's ID |

  Scenario Outline: Refuse an unsuitable trail
    Given trail "trail-1" is "<condition>"
    When createHike is called with the request
    Then the request is refused
    And no hike is created

    Examples:
      | condition                                  |
      | absent from the NCC trail information       |
      | a trail where hiking is not permitted       |
      | outside its opening season on the hike date |

  Scenario Outline: Check certification on the hike date
    Given the certificate is issued on "<issuedOn>" and expires on "<expiresOn>"
    When createHike is called with the request
    Then the result is "<result>"
    And a refused request creates no hike

    Examples:
      | issuedOn   | expiresOn  | result   |
      | 2026-01-01 | 2026-10-30 | refused  |
      | 2026-11-01 | 2026-12-31 | refused  |
      | 2026-01-01 | 2026-10-31 | accepted |

  Scenario: Refuse a trail above the organizer's certified level
    Given the organizer can lead only "EASY" hikes
    When createHike is called with the request
    Then the request is refused
    And no hike is created

  Scenario Outline: Check the registration deadline
    Given the registration deadline is "<deadline>"
    When createHike is called with the request
    Then the result is "<result>"
    And a refused request creates no hike

    Examples:
      | deadline         | result   |
      | 2026-10-17T10:00 | accepted |
      | 2026-10-17T09:59 | refused  |
      | 2026-10-31T10:00 | refused  |
      | 2026-11-01T10:00 | refused  |

  Scenario: Refuse a hike that has already started
    Given the current Ottawa time is "2026-10-31T10:00"
    When createHike is called with the request
    Then the request is refused
    And no hike is created

  Scenario: Use stored NCC information during an outage
    Given the NCC service is unavailable
    And stored NCC information for "trail-1" includes its hiking permission, difficulty and opening season
    When createHike is called with the request
    Then the hike is created using that stored trail information

  Scenario: Refuse creation when no usable trail information is available
    Given the NCC service is unavailable
    And no stored NCC information exists for "trail-1"
    When createHike is called with the request
    Then the request is refused without creating a hike
    And unrelated system functions remain available
