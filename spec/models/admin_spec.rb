require 'rails_helper'

RSpec.describe Admin, type: :model do
  describe '#valid?' do
    context 'Valor:' do
      it 'Falso quando domínio de e-mail está incorreto' do
        invalid_admin = Admin.new(email: 'admin@email.com')
        valid_admin = Admin.new(email: 'admin@sistemadefrete.com.br')

        [invalid_admin, valid_admin].each(&:valid?)

        expect(invalid_admin.errors[:email]).to include 'não é válido'
        expect(valid_admin.errors.include?(:email)).to eq false
      end
    end
  end
end
