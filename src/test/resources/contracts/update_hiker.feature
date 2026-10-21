@updateHiker
Feature: Update a hiker's personal details

  Background:
    Given hiker Alex exists with membership status "ACTIVE"
    And Alex has a stored personal profile and emergency contact

  Scenario: Update the caller's own profile
    Given Alex is authenticated
    And Alex submits valid personal details with an unused email address
    When updateHiker is called for Alex
    Then Alex's profile matches the submitted details
    And Alex's membership status and organizer certification are unchanged

  Scenario: Refuse a change to another hiker's profile
    Given hiker Sam exists
    And Alex is authenticated
    When updateHiker is called by Alex for Sam
    Then the request is refused because the profile belongs to another hiker
    And no hiker data is changed

  Scenario: Require authentication
    Given there is no authenticated session
    When updateHiker is called for Alex
    Then the request is refused because authentication is required
    And no hiker data is changed

  Scenario: Refuse an email address used by another hiker
    Given Alex is authenticated
    And hiker Sam uses "sam@example.com"
    And Alex submits "sam@example.com" as the new email address
    When updateHiker is called for Alex
    Then the request is refused because the email address is already in use
    And Alex's previous profile is unchanged

  Scenario: Keep the same email address while changing other details
    Given Alex is authenticated
    And Alex submits valid personal details with Alex's current email address
    When updateHiker is called for Alex
    Then Alex's profile matches the submitted details
    And Alex's membership status and organizer certification are unchanged

  Scenario Outline: Refuse incomplete or invalid personal details
    Given today is "2026-10-18"
    And Alex is authenticated
    And Alex submits otherwise valid personal details
    And the profile field "<field>" is "<value>"
    When updateHiker is called for Alex
    Then the request is refused because the personal details are invalid
    And Alex's previous profile is unchanged

    Examples:
      | field                 | value      |
      | name                  |            |
      | email                 | not-email  |
      | emergencyContactPhone |            |
      | dateOfBirth           | 2026-10-19 |
      | skillLevel            | UNKNOWN    |

  Scenario: Refuse an unknown hiker
    Given the caller is authenticated
    And the requested hiker ID does not exist
    When updateHiker is called for that ID
    Then the request is refused because the hiker does not exist
    And no hiker data is changed
