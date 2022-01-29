require 'rails_helper'

RSpec.feature "ProductDetails", type: :feature, js: true do
  #SETUP
  before :each do
   @category = Category.create! name: 'Apparel'

   1.times do |n|
     @category.products.create!(
       name: Faker::Hipster.sentence(3),
       description: Faker::Hipster.paragraph(4),
       image: open_asset('apparel1.jpg'),
       quantity: 10,
       price: 64.99
     )
   end
 end



 scenario "They see all products" do
   # ACT
   visit root_path
    # CHECK IF CART EMPTY
   expect(page).to have_content('My Cart (0)')

   click_button 'Add'

    # DEBUG / VERIFY
   save_screenshot

    #CHECK IF ITEM ADDED
   expect(page).to have_content('My Cart (1)')
 end
end