Given /I have added "(.*)" with rating "(.*)"/ do |title, rating|
    steps %Q{
        Given I am on the Create New Movie Page
        When I fill in "Title" with "#{title}"
        And I select "#{rating}" from "Rating"
        And I press "Save Changes" 
    }
end

#Need revision it doesn't sort the list by title 
Then /I should see "(.*)" before "(.*)" on (.*) stored by title/ do |string1, string2, path|
    steps %Q{Given I am on #{path}}
    regexp = /#{string1}.*#{string2}/m #m means match across new lines
    expect(page.body).to match(regexp)
end
