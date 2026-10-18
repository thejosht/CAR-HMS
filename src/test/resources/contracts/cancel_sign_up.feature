@cancelSignUp
Feature: Cancel a hike registration

  Background:
    Given the time zone is "America/Toronto" and the time is "2026-10-18T09:00:00-04:00"
    And Alex is an authenticated hiker
    And hike "Ridge Walk" is full with capacity 3 and 3 confirmed registrations
    And its registration deadline is "2026-10-19T18:00:00-04:00"

  Scenario: Give a cancelled place to the first waiting hiker
    Given Alex owns one of the confirmed registrations for "Ridge Walk"
    And Sam and Taylor are waiting in that order
    When cancelSignUp is called by Alex for Alex's registration
    Then Alex's registration becomes "CANCELLED" and keeps its original registration time
    And Sam's registration becomes "CONFIRMED"
    And Taylor is now first on the waiting list
    And the hike remains "FULL" with 3 confirmed registrations
    And Sam receives an email confirming the place

  Scenario: Reopen a full hike when no one is waiting
    Given Alex owns one of the confirmed registrations for "Ridge Walk"
    And no hikers are waiting
    When cancelSignUp is called by Alex for Alex's registration
    Then Alex's registration becomes "CANCELLED" and keeps its original registration time
    And the hike has 2 confirmed registrations and 1 available place
    And the hike becomes "OPEN"
    And Alex is recorded as the actor who caused the change to "OPEN"

  Scenario: Cancel a waiting registration without freeing a confirmed place
    Given Alex has a "WAITLISTED" registration for "Ridge Walk"
    And the waiting order is Sam, Alex, Taylor
    When cancelSignUp is called by Alex for Alex's registration
    Then Alex's registration becomes "CANCELLED" and keeps its original registration time
    And the waiting order is Sam, Taylor
    And no waiting registration becomes "CONFIRMED"
    And the hike remains "FULL" with 3 confirmed registrations

  Scenario: Cancel a confirmed registration in an open hike
    Given the hike is "OPEN" with 2 confirmed registrations and 1 available place
    And Alex owns one of those confirmed registrations
    And no hikers are waiting
    When cancelSignUp is called by Alex for Alex's registration
    Then Alex's registration becomes "CANCELLED"
    And the hike remains "OPEN" with 1 confirmed registration and 2 available places

  Scenario Outline: Cancellation does not require active membership
    Given Alex's membership status is "<status>"
    And Alex owns one of the confirmed registrations for "Ridge Walk"
    And no hikers are waiting
    When cancelSignUp is called by Alex for Alex's registration
    Then Alex's registration becomes "CANCELLED"
    And the hike becomes "OPEN" with 1 available place

    Examples:
      | status    |
      | EXPIRED   |
      | SUSPENDED |

  Scenario Outline: Refuse cancellation at or after the deadline
    Given Alex owns one of the confirmed registrations for "Ridge Walk"
    And the time is "<time>"
    And the stored hike status is still "FULL"
    When cancelSignUp is called by Alex for Alex's registration
    Then the request is refused because the registration deadline has been reached
    And no registration, waiting order or hike data is changed
    And no place confirmation email is sent

    Examples:
      | time                      |
      | 2026-10-19T18:00:00-04:00 |
      | 2026-10-19T18:00:01-04:00 |

  Scenario Outline: Refuse cancellation for a hike that is no longer open or full
    Given Alex owns a "<registration>" registration for "Ridge Walk"
    And the hike's status is "<status>" with <confirmed> confirmed registrations
    And its start time is "<start>" and registration deadline is "<deadline>"
    When cancelSignUp is called by Alex for Alex's registration
    Then the request is refused because the hike no longer accepts cancellations
    And no registration, waiting order or hike data is changed

    Examples:
      | status    | registration | confirmed | start                     | deadline                  |
      | CLOSED    | CONFIRMED    | 3         | 2026-10-25T10:00:00-04:00 | 2026-10-18T08:00:00-04:00 |
      | CANCELLED | CANCELLED    | 0         | 2026-10-25T10:00:00-04:00 | 2026-10-19T18:00:00-04:00 |
      | FINISHED  | CONFIRMED    | 3         | 2026-10-17T10:00:00-04:00 | 2026-10-16T18:00:00-04:00 |

  Scenario: Refuse cancellation of another hiker's registration
    Given Sam owns the selected registration for "Ridge Walk"
    When cancelSignUp is called by Alex for Sam's registration
    Then the request is refused because the registration belongs to another hiker
    And no registration, waiting order or hike data is changed

  Scenario: Refuse a registration that is already cancelled
    Given Alex owns a "CANCELLED" registration for "Ridge Walk"
    When cancelSignUp is called by Alex for that registration
    Then the request is refused because the registration is already cancelled
    And no registration, waiting order or hike data is changed

  Scenario: Require authentication
    Given Alex owns one of the confirmed registrations for "Ridge Walk"
    And there is no authenticated session
    When cancelSignUp is called for Alex's registration
    Then the request is refused because authentication is required
    And no registration, waiting order or hike data is changed

  Scenario: Refuse an unknown registration
    Given the requested registration ID does not exist
    When cancelSignUp is called by Alex for that ID
    Then the request is refused because the registration does not exist
    And no registration, waiting order or hike data is changed
