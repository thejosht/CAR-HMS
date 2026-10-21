@sendHikeReminder
Feature: Send reminders one day before a hike
  The authorized scheduled system task prepares reminders from the hike details.
  Hikers on the waiting list do not receive a participation reminder.

  Background:
    Given hike "hike-1" starts at "2026-10-31T10:00"
    And the current Ottawa time is "2026-10-30T10:00"
    And the hike is not cancelled or finished
    And the caller is the authorized scheduled system task
    And the hike has confirmed, waitlisted and cancelled registrations
    And the request identifies hike "hike-1"

  Scenario: Remind confirmed participants
    Given the forecast contains neither rain nor snow
    When sendHikeReminder is called with the request
    Then an email is sent to each confirmed participant
    And no reminder is sent to waitlisted or cancelled registrations
    And each email gives the hike date, start time, trail and meeting point
    And each email contains no weather warning

  Scenario Outline: Include the applicable weather warning
    Given the forecast for the hike date at the trail meeting point predicts "<weather>"
    When sendHikeReminder is called with the request
    Then each confirmed participant receives the reminder with a "<weather>" warning
    And no reminder is sent to waitlisted or cancelled registrations

    Examples:
      | weather |
      | rain    |
      | snow    |

  Scenario: Send the reminder even if the weather service is unavailable
    Given no weather forecast can be obtained
    When sendHikeReminder is called with the request
    Then each confirmed participant receives the reminder with the hike details
    And the reminder contains no invented weather warning

  Scenario: Send nothing when there are no confirmed participants
    Given the hike has only waitlisted or cancelled registrations
    When sendHikeReminder is called with the request
    Then no reminder email is sent
    And no registration or hike status is changed

  Scenario Outline: Do not send a reminder on the wrong date
    Given the current Ottawa time is "<now>"
    When sendHikeReminder is called with the request
    Then the request is refused without sending a reminder

    Examples:
      | now              |
      | 2026-10-29T10:00 |
      | 2026-10-31T09:00 |

  Scenario Outline: Do not remind participants of a cancelled or finished hike
    Given the hike status is "<status>"
    When sendHikeReminder is called with the request
    Then no reminder email is sent
    And no stored hike or registration is changed

    Examples:
      | status    |
      | CANCELLED |
      | FINISHED  |

  Scenario: Reject an unauthorized caller
    Given the caller is not the authorized scheduled system task
    When sendHikeReminder is called with the request
    Then the request is refused without sending email

  Scenario: Reject an unknown hike
    Given the requested hike does not exist
    When sendHikeReminder is called with the request
    Then the request is refused without sending email
