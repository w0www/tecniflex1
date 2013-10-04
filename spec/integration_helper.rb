def login(user=nil)
  user = User.new(:email_address => 'user@test.com') unless user
  visit '/login'
  fill_in 'login', :with => user.email_address
  fill_in 'password', :with => 'Secret'
  click_on 'Ingresar'
end

def logout
  click_on 'Terminar Sesión'
end
