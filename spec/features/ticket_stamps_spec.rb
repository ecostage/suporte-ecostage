require 'spec_helper'

feature 'visit ticket status image' do
  Ticket.statuses.reject { |status| status == 'unread' }.each do |name, _|
    scenario "when it is #{name}" do
      visit "images/stamps/#{name}.svg"
    end
  end
end
