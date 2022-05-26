# Transportadora EXPRESS
express = ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                  email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                  address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')

# VEÍCULOS da Express
Vehicle.create!(license_plate: 'BRA3R52', brand: 'Fiat', model: 'Uno', production_year: 1992,
                maximum_load: 100_000, shipping_company: express)
Vehicle.create!(license_plate: 'ARG4523', brand: 'Volkswagen', model: 'Fusca', production_year: 1971,
                maximum_load: 40_000, shipping_company: express)

# Intervalos de VOLUME na tabela de PREÇOS da Express
first_express_volume_range = VolumeRange.create!(shipping_company: express, min_volume: 0, max_volume: 50)
second_express_volume_range = VolumeRange.create!(shipping_company: express, min_volume: 51, max_volume: 100)

# Intervalos de PESO na tabela de PREÇOS da Express
WeightRange.create!(volume_range: first_express_volume_range, min_weight: 1, max_weight: 20, value: 50)
WeightRange.create!(volume_range: second_express_volume_range, min_weight: 1, max_weight: 10, value: 75)
WeightRange.create!(volume_range: second_express_volume_range, min_weight: 11, max_weight: 20, value: 100)

# Intervalos de DISTÂNCIA na tabela de PREÇOS MÍNIMOS da Express
PriceDistanceRange.create!(shipping_company: express, min_distance: 0, max_distance: 100, value: 500)
PriceDistanceRange.create!(shipping_company: express, min_distance: 101, max_distance: 200, value: 1_000)

# Intervalos de DISTÂNCIA na tabela de PRAZOS da Express
TimeDistanceRange.create!(shipping_company: express, min_distance: 0, max_distance: 100, delivery_time: 2)
TimeDistanceRange.create!(shipping_company: express, min_distance: 101, max_distance: 200, delivery_time: 3)

# Transportadora A JATO
a_jato = ShippingCompany.create!(brand_name: 'A Jato', corporate_name: 'A Jato S.A.',
                                 email_domain: 'ajato.com', registration_number: 19_824_380_000_107,
                                 address: 'Avenida B, 23', city: 'Natal', state: 'RN')

# Intervalos de VOLUME na tabela de PREÇOS da A Jato
a_jato_volume_range = VolumeRange.create!(shipping_company: a_jato, min_volume: 0, max_volume: 100)

# Intervalos de PESO na tabela de PREÇOS da A Jato
WeightRange.create!(volume_range: a_jato_volume_range, min_weight: 1, max_weight: 5, value: 50)

# Intervalos de DISTÂNCIA na tabela de PREÇOS MÍNIMOS da A Jato
PriceDistanceRange.create!(shipping_company: a_jato, min_distance: 0, max_distance: 100, value: 5_000)

# Intervalos de DISTÂNCIA na tabela de PRAZOS da A Jato
TimeDistanceRange.create!(shipping_company: a_jato, min_distance: 0, max_distance: 100, delivery_time: 3)
TimeDistanceRange.create!(shipping_company: a_jato, min_distance: 101, max_distance: 200, delivery_time: 4)

# Transportadora CARROÇA E CIA.
ShippingCompany.create!(brand_name: 'Carroça & Cia.', corporate_name: 'Carroça Companhia Ltda.',
                        email_domain: 'carrocaecia.com.br', registration_number: 10_659_266_000_102,
                        address: 'Avenida C, 155', city: 'Tanguá', state: 'RJ')

# Usuários
Admin.create!(email: 'admin@sistemadefrete.com.br', password: 'password')
User.create!(email: 'usuario@express.com.br', password: 'password')
