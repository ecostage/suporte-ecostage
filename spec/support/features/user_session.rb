module Features
  module UserSession
    def sign_in(user, password='tracersoft')
      visit new_user_session_path
      email = user.email
      password = password

      find('#user_email').set(email)
      find('#user_password').set(password)

      click_button 'Log in'
    end
  end
end
