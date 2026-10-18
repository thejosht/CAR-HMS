@recordOrganizerCertification
Feature: Record an organizer's certification

  Background:
    Given hiker Alex exists with no organizer certification
    And the certification details are:
      | field             | value      |
      | certificateNumber | CERT01     |
      | issuedOn          | 2026-10-01 |
      | expiresOn         | 2027-10-01 |
      | organizerLevel    | MODERATE   |

  Scenario: Approve a hiker as an organizer
    Given the caller is an authenticated administrator
    When recordOrganizerCertification is called for Alex with these details
    Then Alex has certification "CERT01" issued on "2026-10-01" and expiring on "2027-10-01"
    And Alex's organizer level is "MODERATE"
    And Alex is an approved hiking organizer
    And Alex's personal details and membership status are unchanged

  Scenario Outline: Refuse a caller who is not an administrator
    Given the caller is authenticated as a "<role>"
    When recordOrganizerCertification is called for Alex with these details
    Then the request is refused because an administrator is required
    And no certification or organizer approval is recorded
    And no hiker data is changed

    Examples:
      | role      |
      | HIKER     |
      | ORGANIZER |

  Scenario: Require authentication
    Given there is no authenticated session
    When recordOrganizerCertification is called for Alex with these details
    Then the request is refused because authentication is required
    And no hiker data is changed

  Scenario Outline: Refuse incomplete or invalid certification details
    Given the caller is an authenticated administrator
    And the certification field "<field>" is "<value>"
    When recordOrganizerCertification is called for Alex with these details
    Then the request is refused because the certification details are invalid
    And no certification or organizer approval is recorded
    And no hiker data is changed

    Examples:
      | field             | value      |
      | certificateNumber |            |
      | expiresOn         | 2026-09-30 |
      | organizerLevel    | UNKNOWN    |

  Scenario: Refuse an unknown hiker
    Given the caller is an authenticated administrator
    And the requested hiker ID does not exist
    When recordOrganizerCertification is called for that ID with these details
    Then the request is refused because the hiker does not exist
    And no certification or organizer approval is recorded
