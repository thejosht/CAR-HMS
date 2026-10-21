Feature: Cancel a Hike
  As an Organizer
  I want to cancel an existing hike
  So that participants are notified and the event is removed from the schedule

  Scenario: Successfully cancel an existing hike
    Given a hike exists with a valid ID
    And I provide a valid cancellation reason
    When I submit the request to cancel the hike
    Then the hike status should be updated to "CANCELLED"
    And all registered participants should be notified