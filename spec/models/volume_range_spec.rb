require 'rails_helper'

RSpec.describe VolumeRange, type: :model do
  describe '#valid?' do
    context 'presença' do
      it 'falso quando transportadora está em branco' do
        vrange = VolumeRange.new(shipping_company: nil)

        vrange.valid?

        expect(vrange.errors[:shipping_company]).to include 'é obrigatório(a)'
      end
    end

    context 'valor' do
      it 'falso quando volume mínimo está em branco, é < 0 ou está em intervalos já cadastrados' do
        express = ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                          email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                          address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
        VolumeRange.create!(shipping_company: express, min_volume: 0, max_volume: 20)
        express.reload
        empty = VolumeRange.new(min_volume: '')
        first_invalid = VolumeRange.new(min_volume: -1)
        second_invalid = VolumeRange.new(shipping_company: express, min_volume: 0)
        valid = VolumeRange.new(shipping_company: express, min_volume: 21, max_volume: 40)

        [empty, first_invalid, second_invalid, valid].each(&:valid?)

        expect(empty.errors[:min_volume]).to include 'não pode ficar em branco'
        expect(first_invalid.errors[:min_volume]).to include 'deve ser maior ou igual a 0'
        expect(second_invalid.errors[:min_volume]).to include(
          'não pode estar contido em intervalos já registrados'
        )
        expect(valid.errors.include?(:min_volume)).to be false
      end

      it 'falso quando volume máximo está em branco, é < 1 ou está em intervalos já cadastrados' do
        express = ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                          email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                          address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
        VolumeRange.create!(shipping_company: express, min_volume: 0, max_volume: 20)
        express.reload
        empty = VolumeRange.new(max_volume: '')
        first_invalid = VolumeRange.new(max_volume: 0)
        second_invalid = VolumeRange.new(shipping_company: express, max_volume: 20)
        valid = VolumeRange.new(shipping_company: express, min_volume: 21, max_volume: 40)

        [empty, first_invalid, second_invalid, valid].each(&:valid?)

        expect(empty.errors[:max_volume]).to include 'não pode ficar em branco'
        expect(first_invalid.errors[:max_volume]).to include 'deve ser maior ou igual a 1'
        expect(second_invalid.errors[:max_volume]).to include(
          'não pode estar contido em intervalos já registrados'
        )
        expect(valid.errors.include?(:max_volume)).to be false
      end
    end
  end
end
