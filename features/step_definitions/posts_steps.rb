When /^I post a photo with a token$/ do
  json = JSON.parse <<JSON
        {"activity":{"actor":{"url":"http://cubbi.es/daniel","displayName":"daniel","objectType":"person"},"published":"2011-05-19T18:12:23Z","verb":"save","object":{"objectType":"photo","url":"http://i658.photobucket.com/albums/uu308/R3b3lAp3/Swagger_dog.jpg","image":{"url":"http://i658.photobucket.com/albums/uu308/R3b3lAp3/Swagger_dog.jpg","width":637,"height":469}},"provider":{"url":"http://cubbi.es/","displayName":"Cubbi.es"}}}
JSON
  page.driver.post(activity_streams_photos_path, json.merge!(:auth_token => @me.authentication_token))
end

Then /^I should see an uploaded image within the photo drop zone$/ do
  find("#photodropzone img")["src"].should include("uploads/images")
end

Then /^I should not see an uploaded image within the photo drop zone$/ do
  all("#photodropzone img").should be_empty
end

Then /^I should not see any posts in my stream$/ do
  all(".stream_element").should be_empty
end

Given /^"([^"]*)" has a public post with text "([^"]*)"$/ do |email, text|
  user = User.find_by_email(email)
  user.post(:status_message, :text => text, :public => true, :to => user.aspects)
end

Given /^"([^"]*)" has a non public post with text "([^"]*)"$/ do |email, text|
  user = User.find_by_email(email)
  user.post(:status_message, :text => text, :public => false, :to => user.aspects)
end

When /^The user deletes their first post$/ do
  @me.posts.first.destroy
end

When /^I click on the first block button/ do
  find(".block_user").click
end


Then /^I should see "([^"]*)" as the first post in my stream$/ do |text|
  first_post_text.should include(text)
end

When /^I post "([^"]*)"$/ do |text|
  click_and_post(text)
end

When /^I click the publisher and post "([^"]*)"$/ do |text|
  click_and_post(text)
end
