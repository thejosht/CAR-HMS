# CAR-HMS

CAR-HMS is a hiking management system for the Cairn club. It manages hiker profiles, hikes, registrations and waiting lists.

The code is written in Kotlin.

## Repository structure

The domain structure is in [`src/main/kotlin/domain`](src/main/kotlin/domain). Each subdomain has its own README. The four use cases below have interfaces, request DTOs and initial Cucumber contracts. The remaining use cases will be added in later commits.

## Application commands

The interfaces are in [`application/usecases`](src/main/kotlin/application/usecases). They declare the commands but do not implement them yet.

| Use case | Commands |
| --- | --- |
| Register Hiker | `registerHiker` |
| Update Hiker | `updateHiker`, `changeMembershipStatus`, `recordOrganizerCertification` |
| Sign Up for Hike | `signUpForHike` |
| Cancel Sign Up | `cancelSignUp` |

Request DTOs are in [`application/dtos/queries`](src/main/kotlin/application/dtos/queries). IDs use `UUID`, and dates without a time use `LocalDate`. A successful registration returns the new hiker ID. Signing up for a hike returns the registration ID, whether the registration is confirmed or on the waiting list.

Hiker and administrator IDs used to identify the caller must come from the authenticated session, not an unchecked client value. Membership changes and organizer certification require an administrator. For a minor, `waiverAccepted` refers to the legal guardian's acceptance, and `legalGuardianName` must be provided.

Levels and membership status are request strings that the command implementation must validate. Skill levels are `BEGINNER`, `INTERMEDIATE`, `ADVANCED` and `EXPERT`. Membership status is `ACTIVE`, `EXPIRED` or `SUSPENDED`. Organizer levels use trail difficulty: `EASY`, `MODERATE`, `DIFFICULT` and `VERY_DIFFICULT`.

## Initial contracts

The six feature files in [`src/test/resources/contracts`](src/test/resources/contracts) describe the expected results of the six application commands. They cover successful requests, validation, authorization, registration deadlines and waiting lists. Dates and times are fixed so the scenarios do not depend on the day they are checked.

These are contract specifications, not automated tests of a working application yet. They still need step definitions, command implementations and a Cucumber test runner before they can be executed against the system.

## Working in the repository

The `main` branch holds the shared version of the project. Changes are made on separate branches and checked before merging.

To get a local copy:

```sh
git clone https://github.com/thejosht/CAR-HMS.git
cd CAR-HMS
```

There is no build configuration or runnable application yet.
