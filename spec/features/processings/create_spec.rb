require 'rails_helper'

RSpec.describe 'Processing CREATE' do
  before { visit '/processings/new' }

  describe 'invalid input' do
    context 'no image uploaded' do
      it 'shows error' do
        click_button 'Upload image!'

        expect(page).to have_content "Image can't be blank"
      end
    end

    context 'it is not image' do
      it 'shows error' do
        attach_file('processing[image]', 'spec/spec_helper.rb')

        click_button 'Upload image!'

        expect(page).to have_content 'Image format must be jpg, jpeg, gif, png or svg'
      end
    end

    context 'it is not image' do
      it 'shows error' do
        page.fill_in 'processing[remote_image_url]', with: 'This is not HTTP'

        click_button 'Upload image!'

        expect(page).to have_content 'Image trying to download a file which is not served over HTTP'
      end
    end
  end

  describe 'valid input' do
    context 'local image' do
      it 'creates processing' do
        attach_file('processing[image]', 'spec/fixtures/images/rails.png')

        click_button 'Upload image!'

        expect(page).to have_current_path '/processings'
        expect(page).to have_css("img[src*='rails.png']")
      end

      context 'from url' do
        it 'creates processing' do
          page.fill_in 'processing[remote_image_url]', with: 'http://rubyonrails.org/images/rails-logo.svg'

          click_button 'Upload image!'

          expect(page).to have_current_path '/processings'
          expect(page).to have_css("img[src*='rails-logo.svg']")
        end
      end
    end
  end
end
