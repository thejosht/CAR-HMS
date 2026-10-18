@changeMembershipStatus
Feature: Change a hiker's membership status

  Background:
    Given hiker Alex exists with a stored profile

  Scenario Outline: An administrator changes a membership status
    Given the caller is an authenticated administrator
    And Alex's membership status is "<previous>"
    When changeMembershipStatus is called for Alex with status "<next>"
    Then Alex's membership status is "<next>"
    And Alex's personal details and organizer certification are unchanged

    Examples:
      | previous  | next      |
      | ACTIVE    | EXPIRED   |
      | ACTIVE    | SUSPENDED |
      | EXPIRED   | ACTIVE    |
      | SUSPENDED | ACTIVE    |

  Scenario Outline: Refuse a caller who is not an administrator
    Given the caller is authenticated as a "<role>"
    When changeMembershipStatus is called for Alex with status "SUSPENDED"
    Then the request is refused because an administrator is required
    And no hiker data is changed

    Examples:
      | role      |
      | HIKER     |
      | ORGANIZER |

  Scenario: Require authentication
    Given there is no authenticated session
    When changeMembershipStatus is called for Alex with status "SUSPENDED"
    Then the request is refused because authentication is required
    And no hiker data is changed

  Scenario: Refuse an unknown membership status
    Given the caller is an authenticated administrator
    When changeMembershipStatus is called for Alex with status "UNKNOWN"
    Then the request is refused because the membership status is invalid
    And no hiker data is changed

  Scenario: Refuse an unknown hiker
    Given the caller is an authenticated administrator
    And the requested hiker ID does not exist
    When changeMembershipStatus is called for that ID with status "ACTIVE"
    Then the request is refused because the hiker does not exist
    And no hiker data is changed
