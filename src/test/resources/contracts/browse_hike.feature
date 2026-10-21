Feature: Browse Hikes
  As a Hiker
  I want to browse available hikes
  So that I can find an event to join

  Scenario: Successfully browse all available hikes
    Given there are hikes available in the system
    When I submit a request to browse hikes without filters
    Then I should receive a list of all available hikes

  Scenario: Successfully browse hikes by location
    Given there are hikes available in various locations
    When I submit a request to browse hikes filtered by a specific location
    Then I should receive a list of hikes matching that location