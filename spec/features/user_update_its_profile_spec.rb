require 'spec_helper'

feature 'use udpdates its profile' do
  scenario 'a message should be showed' do
    name = 'john'
    success_message = 'Perfil atualizado com sucesso'
    client = create(:client)
    sign_in client
    visit myprofile_path

    find("#user_name").set(name)
    click_button 'Salvar'

    expect(page).to have_content(success_message)
    expect(client.reload.name).to eq(name)
  end
end
