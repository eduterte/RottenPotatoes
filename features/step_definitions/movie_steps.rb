# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create(movie)
  end
  #flunk "Unimplemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page
Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  titles = page.all("table#movies tbody tr td[1]").map {|t| t.text}
    assert titles.index(e1) < titles.index(e2)
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  rating_list.split(",").each do |field|
        field = field.strip
        if uncheck == "un"
            step %Q{I uncheck "ratings_#{field}"}
            step %Q{the "ratings_#{field}" checkbox should not be checked}
        else
            step %Q{I check "ratings_#{field}"}
            step %Q{the "ratings_#{field}" checkbox should be checked}
        end
    end
end

Then /^I should see (none|all) of the movies$/ do |should|
    rows = page.all("table#movies tbody tr td[1]").map {|t| t.text}
    if should == "none"
        assert rows.size == 0
    else
        assert rows.size == Movie.all.count
    end
end
