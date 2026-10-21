@closeHike
Feature: Close registrations at the deadline
  An authorized scheduled system task closes a hike at its registration deadline.
  A full hike is not the same as a closed hike.

  Background:
    Given hike "hike-1" has registration deadline "2026-10-28T10:00"
    And the request identifies hike "hike-1"

  Scenario Outline: Close an open or full hike when its deadline is reached
    Given the caller is the authorized scheduled system task
    And the current Ottawa time is "<now>"
    And the hike status is "<status>"
    When closeHike is called with the request
    Then the hike status becomes "CLOSED"
    And both new registrations and registration cancellations are refused
    And existing registrations and waiting-list order are retained
    And the lifecycle change records the system task as its source

    Examples:
      | now              | status |
      | 2026-10-28T10:00 | OPEN   |
      | 2026-10-28T10:00 | FULL   |
      | 2026-10-28T10:01 | OPEN   |

  Scenario: Do not close a hike before its deadline
    Given the caller is the authorized scheduled system task
    And the current Ottawa time is "2026-10-28T09:59"
    And the hike status is "OPEN"
    When closeHike is called with the request
    Then the request is refused and the hike remains "OPEN"
    And no closing lifecycle record is added

  Scenario Outline: Do not overwrite an already closed or terminal status
    Given the caller is the authorized scheduled system task
    And the current Ottawa time is "2026-10-28T10:00"
    And the hike status is "<status>"
    When closeHike is called with the request
    Then the hike and registrations are unchanged
    And no duplicate lifecycle record is added

    Examples:
      | status    |
      | CLOSED    |
      | CANCELLED |
      | FINISHED  |

  Scenario: Reject an unauthorized call to the scheduled operation
    Given the caller is not the authorized scheduled system task
    When closeHike is called with the request
    Then the request is refused without changing the hike

  Scenario: Reject an unknown hike
    Given the caller is the authorized scheduled system task
    And the requested hike does not exist
    When closeHike is called with the request
    Then the request is refused without creating or changing any hike
