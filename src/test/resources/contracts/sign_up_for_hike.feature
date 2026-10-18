@signUpForHike
Feature: Sign up for a hike

  Background:
    Given the time zone is "America/Toronto" and the time is "2026-10-18T09:00:00-04:00"
    And Alex is an authenticated hiker with active membership and skill level "INTERMEDIATE"
    And hike "Ridge Walk" is open with difficulty "MODERATE", capacity 3 and 1 confirmed registration
    And its registration deadline is "2026-10-19T18:00:00-04:00"

  Scenario: Confirm a registration while places remain
    Given Alex has no confirmed or waiting registration for "Ridge Walk"
    When signUpForHike is called by Alex for "Ridge Walk"
    Then a new registration links Alex to "Ridge Walk" with status "CONFIRMED"
    And its registration time is "2026-10-18T09:00:00-04:00"
    And the hike has 2 confirmed registrations and 1 available place
    And the hike remains "OPEN"
    And a confirmation email is sent to Alex
    And the new registration ID is returned

  Scenario: The last available place makes the hike full
    Given the hike has 2 confirmed registrations and 1 available place
    And Alex has no confirmed or waiting registration for "Ridge Walk"
    When signUpForHike is called by Alex for "Ridge Walk"
    Then Alex's new registration is "CONFIRMED"
    And the hike has 3 confirmed registrations and no available places
    And the hike becomes "FULL"
    And Alex is recorded as the actor who caused the change to "FULL"
    And a confirmation email is sent to Alex

  Scenario: Join a full hike at the end of its waiting list
    Given the hike is full with 3 confirmed registrations
    And Sam and Taylor are waiting in that order
    And Alex has no confirmed or waiting registration for "Ridge Walk"
    When signUpForHike is called by Alex for "Ridge Walk"
    Then Alex has a new "WAITLISTED" registration recorded at "2026-10-18T09:00:00-04:00"
    And the waiting order is Sam, Taylor, Alex
    And the hike remains "FULL" with 3 confirmed registrations
    And Alex receives an email giving waiting position 3
    And the new registration ID is returned

  Scenario Outline: Accept a hike within the permitted difficulty range
    Given Alex's skill level is "<skill>"
    And the hike's difficulty is "<difficulty>"
    And Alex has no confirmed or waiting registration for the hike
    When signUpForHike is called by Alex for "Ridge Walk"
    Then Alex has a new "CONFIRMED" registration

    Examples:
      | skill        | difficulty     |
      | BEGINNER     | EASY           |
      | BEGINNER     | MODERATE       |
      | INTERMEDIATE | EASY           |
      | INTERMEDIATE | DIFFICULT      |
      | ADVANCED     | VERY_DIFFICULT |
      | EXPERT       | VERY_DIFFICULT |

  Scenario Outline: Refuse a hike more than one level above the hiker's skill
    Given Alex's skill level is "<skill>"
    And the hike's difficulty is "<difficulty>"
    When signUpForHike is called by Alex for "Ridge Walk"
    Then the request is refused because the hike is too difficult
    And no registration or hike data is changed
    And no registration email is sent

    Examples:
      | skill        | difficulty     |
      | BEGINNER     | DIFFICULT      |
      | BEGINNER     | VERY_DIFFICULT |
      | INTERMEDIATE | VERY_DIFFICULT |

  Scenario Outline: Require active membership
    Given Alex's membership status is "<status>"
    When signUpForHike is called by Alex for "Ridge Walk"
    Then the request is refused because the membership is not active
    And no registration or hike data is changed

    Examples:
      | status    |
      | EXPIRED   |
      | SUSPENDED |

  Scenario Outline: Refuse registration at or after the deadline
    Given the time is "<time>"
    And the stored hike status is still "OPEN"
    When signUpForHike is called by Alex for "Ridge Walk"
    Then the request is refused because the registration deadline has been reached
    And no registration or hike data is changed

    Examples:
      | time                      |
      | 2026-10-19T18:00:00-04:00 |
      | 2026-10-19T18:00:01-04:00 |

  Scenario Outline: Refuse a hike that no longer accepts registrations
    Given the hike's status is "<status>" with <confirmed> confirmed registrations
    And its start time is "<start>" and registration deadline is "<deadline>"
    When signUpForHike is called by Alex for "Ridge Walk"
    Then the request is refused because the hike does not accept registrations
    And no registration or hike data is changed

    Examples:
      | status    | confirmed | start                     | deadline                  |
      | CLOSED    | 1         | 2026-10-25T10:00:00-04:00 | 2026-10-18T08:00:00-04:00 |
      | CANCELLED | 0         | 2026-10-25T10:00:00-04:00 | 2026-10-19T18:00:00-04:00 |
      | FINISHED  | 1         | 2026-10-17T10:00:00-04:00 | 2026-10-16T18:00:00-04:00 |

  Scenario Outline: Refuse a duplicate registration
    Given Alex already has a "<status>" registration for "Ridge Walk"
    When signUpForHike is called by Alex for "Ridge Walk"
    Then the request is refused because Alex is already registered
    And no registration or hike data is changed

    Examples:
      | status     |
      | CONFIRMED  |
      | WAITLISTED |

  Scenario: A cancelled registration does not keep its old waiting position
    Given Alex has an old "CANCELLED" registration for "Ridge Walk"
    And the hike is full with 3 confirmed registrations
    And Sam and Taylor are waiting in that order
    When signUpForHike is called by Alex for "Ridge Walk"
    Then a different registration is created for Alex with status "WAITLISTED"
    And its registration time is "2026-10-18T09:00:00-04:00"
    And the waiting order is Sam, Taylor, Alex
    And Alex's old registration remains "CANCELLED" with its original registration time
    And Alex receives an email giving waiting position 3

  Scenario: Require authentication
    Given there is no authenticated session
    When signUpForHike is called for "Ridge Walk"
    Then the request is refused because authentication is required
    And no registration or hike data is changed

  Scenario: Refuse a request made using another hiker's ID
    Given hiker Sam exists with active membership
    When signUpForHike is called by Alex using Sam's hiker ID for "Ridge Walk"
    Then the request is refused because the hiker ID does not match the authenticated caller
    And no registration or hike data is changed

  Scenario Outline: Refuse a missing hiker or hike
    Given the requested "<record>" ID does not exist
    When signUpForHike is called with that ID
    Then the request is refused because the "<record>" does not exist
    And no registration or hike data is changed

    Examples:
      | record |
      | hiker  |
      | hike   |
