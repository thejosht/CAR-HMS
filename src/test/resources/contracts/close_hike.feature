Feature: Close a Hike
  As an Organizer
  I want to close a hike
  So that no more participants can sign up for it

  Scenario: Successfully close an active hike
    Given a hike exists with a valid ID
    And the hike is currently open for registration
    When I submit the request to close the hike
    Then the hike status should be updated to "CLOSED"
    And no further sign-ups should be allowed for this hike