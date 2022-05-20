require 'rails_helper'

RSpec.describe VolumeRange, type: :model do
  describe '#valid?' do
    context 'Presença:' do
      it 'Falso quando transportadora está em branco' do
        vrange = VolumeRange.new(shipping_company: nil)

        vrange.valid?

        expect(vrange.errors[:shipping_company]).to include 'é obrigatório(a)'
      end
    end

    context 'Valor:' do
      it 'Falso quando volume mínimo está em branco ou é < 0' do
        express = ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                          email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                          address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
        empty_range = VolumeRange.new(min_volume: '')
        invalid_range = VolumeRange.new(min_volume: -1)
        valid_range = VolumeRange.new(shipping_company: express, min_volume: 0, max_volume: 20)

        [empty_range, invalid_range, valid_range].each(&:valid?)

        expect(empty_range.errors[:min_volume]).to include 'não pode ficar em branco'
        expect(invalid_range.errors[:min_volume]).to include 'deve ser maior ou igual a 0'
        expect(valid_range.errors.include?(:min_volume)).to be false
      end

      it 'Falso quando volume máximo está em branco ou é < 1' do
        express = ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                          email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                          address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
        empty_range = VolumeRange.new(max_volume: '')
        invalid_range = VolumeRange.new(max_volume: 0)
        valid_range = VolumeRange.new(shipping_company: express, min_volume: 0, max_volume: 20)

        [empty_range, invalid_range, valid_range].each(&:valid?)

        expect(empty_range.errors[:max_volume]).to include 'não pode ficar em branco'
        expect(invalid_range.errors[:max_volume]).to include 'deve ser maior ou igual a 1'
        expect(valid_range.errors.include?(:max_volume)).to be false
      end
    end

    context 'Singularidade:' do
      it 'Falso quando volume mínimo está incluso em intervalos já cadastrados' do
        express = ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                          email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                          address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
        VolumeRange.create!(shipping_company: express, min_volume: 0, max_volume: 20)
        invalid_range = VolumeRange.new(shipping_company: express, min_volume: 0)
        valid_range = VolumeRange.new(shipping_company: express, min_volume: 21, max_volume: 40)

        express.reload
        [invalid_range, valid_range].each(&:valid?)

        expect(invalid_range.errors[:min_volume]).to include('não pode estar contido em intervalos já registrados')
        expect(valid_range.errors.include?(:min_volume)).to be false
      end

      it 'Falso quando volume máximo está incluso em intervalos já cadastrados' do
        express = ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                          email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                          address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
        VolumeRange.create!(shipping_company: express, min_volume: 0, max_volume: 20)
        invalid_range = VolumeRange.new(shipping_company: express, max_volume: 20)
        valid_range = VolumeRange.new(shipping_company: express, min_volume: 21, max_volume: 40)

        express.reload
        [invalid_range, valid_range].each(&:valid?)

        expect(invalid_range.errors[:max_volume]).to include('não pode estar contido em intervalos já registrados')
        expect(valid_range.errors.include?(:max_volume)).to be false
      end
    end
  end
end
