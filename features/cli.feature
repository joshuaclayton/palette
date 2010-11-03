Feature: Run palette from the command line
  In order to easily generate Vim color schemes
  As a user of palette
  I should be able to point palette to a file to generate a color schem

  Scenario: Process a file with valid palette syntax
    When I run "palette features/fixtures/schemes/valid_scheme"
    Then the output should contain "colors_name"

  Scenario: Process a nonexistant file
    When I run "palette features/fixtures/schemes/missing_scheme"
    Then the output should not contain "colors_name"
    And the exit status should be 0
