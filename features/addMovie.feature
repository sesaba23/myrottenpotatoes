Feature: user can manually add movie
Scenario: add a movie

Given I am on the RottenPotatoes home page
When I follow "Add new movie"
Then I should be on the Create New Movie Page
When I fill in "Title" with "Men in Black"
And I select "PG-13" from "Rating"
And I press "Save Changes"
Then I should be on the RottenPotatoes home page
And I should see "Men in Black"