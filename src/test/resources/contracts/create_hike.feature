Feature: Create a Hike
  As an Organizer
  I want to create a new hike
  So that hikers can view and sign up for it

  Scenario: Successfully create a new hike
    Given I am a valid organizer
    And I provide valid hike details
    When I submit the request to create a hike
    Then the hike should be successfully created
    And I should receive a unique hike ID

  Scenario: Fail to create a hike with missing details
    Given I am a valid organizer
    And I provide incomplete hike details
    When I submit the request to create a hike
    Then the hike should not be created
    And I should receive a validation error