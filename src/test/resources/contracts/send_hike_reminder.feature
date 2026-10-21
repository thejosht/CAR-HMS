Feature: Send Hike Reminder
  As an Organizer
  I want to send a reminder to participants of a hike
  So that they do not forget about the upcoming event

  Scenario: Successfully send a reminder for a scheduled hike
    Given a hike exists with a valid ID
    And the hike has registered participants
    And I provide a reminder message
    When I submit the request to send a hike reminder
    Then the reminder message should be sent to all registered participants