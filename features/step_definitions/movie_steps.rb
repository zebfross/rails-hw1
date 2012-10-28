# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create(movie)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  m1 = page.content.match(e1)
  m2 = page.content.match(e2)
  m1.begin(0) > m2.begin(0)
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(/,\s*/).each do |rating|
	checkbox = "ratings_" + rating
	if uncheck
	  uncheck(checkbox)
    else
	  check(checkbox)
	end
  end
end

When /^I press (.*)$/ do |button|
  click_button(button)
end

Then /^I should (not )?see movies with the following ratings: (.*)$/ do |hide, ratings_list|
  ratings = ratings_list.split(/,\s*/)
  if hide
	ratings = Movie.all_ratings.reject do |item|
	  ratings.include?(item)
    end
  end
  movies = Movie.all(:conditions=>{:rating=>ratings})
  movies.each do |movie|
    assert page.has_content?(movie.title)
  end
  assert page.all("#movies tr").length == movies.length + 1
end

Then /^I should see all of the movies$/ do
  assert page.all("#movies tr").length == Movie.count(:all) + 1
end

