@cancelHike
Feature: Cancel a hike
  Its organizer or an administrator can cancel a hike before it starts.
  The caller identity comes from the authenticated session.

  Background:
    Given hike "hike-1" starts at "2026-10-31T10:00"
    And the current Ottawa time is "2026-10-30T12:00"
    And "organizer-1" organizes hike "hike-1"
    And the hike has confirmed and waitlisted registrations
    And a cancel request identifies hike "hike-1" with reason "Trail closure"

  Scenario Outline: Allow the organizer or an administrator to cancel
    Given the authenticated caller is "<caller>"
    And the hike status is "<status>"
    When cancelHike is called with the request and the authenticated caller identity
    Then the hike status becomes "CANCELLED"
    And every confirmed and waitlisted registration becomes "CANCELLED"
    And those hikers receive a cancellation email containing "Trail closure"
    And the caller is recorded as responsible for cancelling the hike
    And no waiting-list promotion occurs
    And new registrations are refused

    Examples:
      | caller                                      | status |
      | organizer-1                                 | OPEN   |
      | organizer-1                                 | FULL   |
      | organizer-1                                 | CLOSED |
      | an administrator who did not create the hike | OPEN   |

  Scenario Outline: Refuse an unauthorized cancellation
    Given the caller is "<caller>"
    When cancelHike is called with the request
    Then the request is refused
    And the hike, registrations and lifecycle history are unchanged
    And no cancellation email is sent

    Examples:
      | caller                                |
      | a visitor without a session           |
      | a hiker who does not organize the hike |
      | an unrelated organizer                |
      | a user claiming an administrator's ID  |

  Scenario Outline: Refuse cancellation once the hike has started
    Given "organizer-1" is authenticated
    And the current Ottawa time is "<now>"
    When cancelHike is called with the request
    Then the request is refused
    And the hike and registrations are unchanged

    Examples:
      | now              |
      | 2026-10-31T10:00 |
      | 2026-10-31T10:01 |

  Scenario Outline: Refuse an invalid cancellation request
    Given "organizer-1" is authenticated
    And "<condition>"
    When cancelHike is called with the request
    Then the request is refused without changing stored data or sending email

    Examples:
      | condition                     |
      | the reason is blank           |
      | the hike does not exist       |
      | the hike is already CANCELLED |
      | the hike is already FINISHED  |
