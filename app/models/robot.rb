class Robot
  def self.retrieve
    User.robot.first || create_robot
  end

  private
  def self.create_robot
    unless ENV['ROBOT_EMAIL']
      raise 'ROBOT_EMAIL env not set'
    end
    User.create({
      name: 'Robot',
      avatar: File.open("#{Rails.root}/app/assets/images/robot.png"),
      email: ENV['ROBOT_EMAIL'], 
      password: 'unbrokeable_1$23&3&%$123@085213&@', 
      user_type: :robot
    })
  end
end
