def login_admin(admin)
  click_on 'Entrar (administrador)'
  fill_in 'E-mail', with: admin.email
  fill_in 'Senha', with: admin.password
  click_on 'Entrar'
end

def login_user(user)
  click_on 'Entrar (usuário)'
  fill_in 'E-mail', with: user.email
  fill_in 'Senha', with: user.password
  click_on 'Entrar'
end
