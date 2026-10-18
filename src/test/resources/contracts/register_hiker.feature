@registerHiker
Feature: Register a hiker

  Background:
    Given today is "2026-10-18"
    And there is no authenticated session
    And Alex has valid registration details with email "alex@example.com" and birth date "2000-05-10"
    And invitation code "JOIN01" is valid and unused

  Scenario: Register an adult with an unused invitation code
    Given no hiker uses "alex@example.com"
    And Alex accepts the liability waiver
    When registerHiker is called with Alex's details and code "JOIN01"
    Then a new hiker is stored with Alex's personal details and emergency contact
    And the hiker's membership status is "ACTIVE"
    And the waiver acceptance is recorded
    And invitation code "JOIN01" is marked as used
    And the new hiker ID is returned

  Scenario: Register a minor with the guardian's consent
    Given Alex's birth date is "2008-10-19"
    And no hiker uses "alex@example.com"
    And Alex's legal guardian accepts the waiver and provides the name "Amal Martin"
    When registerHiker is called with Alex's details and code "JOIN01"
    Then a new hiker is stored with membership status "ACTIVE"
    And the guardian's name and waiver acceptance are recorded
    And invitation code "JOIN01" is marked as used
    And the new hiker ID is returned

  Scenario: No guardian is required on the hiker's eighteenth birthday
    Given Alex's birth date is "2008-10-18"
    And no hiker uses "alex@example.com"
    And Alex accepts the waiver without providing a guardian's name
    When registerHiker is called with Alex's details and code "JOIN01"
    Then a new hiker is stored with membership status "ACTIVE"
    And invitation code "JOIN01" is marked as used

  Scenario Outline: Refuse an unavailable invitation code
    Given invitation code "USED01" has already been used
    And no invitation code "UNKNOWN01" exists
    And Alex accepts the liability waiver
    When registerHiker is called with Alex's details and code "<code>"
    Then the request is refused because the invitation code is unavailable
    And no hiker is created
    And no invitation code changes status

    Examples:
      | code      |
      | USED01    |
      | UNKNOWN01 |

  Scenario: Refuse an email address already in use
    Given another hiker uses "alex@example.com"
    And Alex accepts the liability waiver
    When registerHiker is called with Alex's details and code "JOIN01"
    Then the request is refused because the email address is already in use
    And no hiker is created or changed
    And invitation code "JOIN01" remains unused

  Scenario Outline: Refuse incomplete or invalid registration details
    Given Alex accepts the liability waiver
    And the registration field "<field>" is "<value>"
    When registerHiker is called with Alex's details and code "JOIN01"
    Then the request is refused because the registration details are invalid
    And no hiker is created
    And invitation code "JOIN01" remains unused

    Examples:
      | field                 | value      |
      | name                  |            |
      | email                 | not-email  |
      | password              |            |
      | emergencyContactName  |            |
      | emergencyContactPhone |            |
      | dateOfBirth           | 2026-10-19 |
      | skillLevel            | UNKNOWN    |

  Scenario: Refuse registration without waiver acceptance
    Given Alex has not accepted the liability waiver
    When registerHiker is called with Alex's details and code "JOIN01"
    Then the request is refused because the waiver has not been accepted
    And no hiker is created
    And invitation code "JOIN01" remains unused

  Scenario Outline: Refuse a minor's registration without complete guardian consent
    Given Alex's birth date is "2008-10-19"
    And the guardian's waiver acceptance is "<accepted>"
    And the guardian's name is "<name>"
    When registerHiker is called with Alex's details and code "JOIN01"
    Then the request is refused because guardian consent is incomplete
    And no hiker is created
    And invitation code "JOIN01" remains unused

    Examples:
      | accepted | name        |
      | false    | Amal Martin |
      | true     |             |
