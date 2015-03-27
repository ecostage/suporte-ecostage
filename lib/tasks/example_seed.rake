namespace :db do
  namespace :example do
    desc "Seed examples"
    task :seed => :environment do
      10.times.each do
        Channel.create! name: Faker::Commerce.product_name, purpose: Faker::Commerce.department
      end

      2.times.each do
        User.create! name: Faker::Name.name, email: Faker::Internet.email,
          password: 'supertracer10', user_type: :admin
      end

      10.times.each do
        User.create! name: Faker::Name.name, email: Faker::Internet.email,
          password: 'supertracer10', user_type: :attendant
      end

      10.times.each do
        group = Group.create! name: Faker::Company.name, purpose: Faker::Company.catch_phrase
        Channel.offset(rand(Channel.count-10))[0..rand(10)].each do |channel|
          group.channels << channel
        end
      end

      20.times.each do
        user = User.create! name: Faker::Name.name, email: Faker::Internet.email,
          password: 'supertracer10', user_type: :client
        group = Group.offset(rand(Group.count)).first
        group.members << user
        group.channels[0..rand(group.channels.count)].each do |channel|
          channel.members << user
        end

        (0..rand(10)).each do
          ticket = Ticket.create! subject: Faker::Lorem.sentence,
            content: Faker::Lorem.paragraph, created_by: user
          group.channels.offset(rand(group.channels.count)).first.tickets << ticket
        end
      end
    end
  end
end
