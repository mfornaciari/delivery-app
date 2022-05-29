# Transportadora EXPRESS
express = ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                  email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                  address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')

# VEÍCULOS da Express
vehicle = Vehicle.create!(license_plate: 'BRA3R52', brand: 'Fiat', model: 'Uno', production_year: 1992,
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

# USUÁRIOS
admin = Admin.create!(email: 'admin@sistemadefrete.com.br', password: 'password')
User.create!(email: 'usuario@express.com.br', password: 'password')

# CONSULTAS DE PREÇO cadastradas
BudgetSearch.create!(height: 100, width: 100, depth: 100, weight: 10, distance: 10, admin:)
BudgetSearch.create!(height: 1000, width: 100, depth: 100, weight: 20, distance: 40, admin:)

# PEDIDOS cadastrados
order = Order.create!(pickup_address: 'Rua Rio Vermelho, n. 10', pickup_city: 'Natal', pickup_state: 'RN',
                      delivery_address: 'Rua Rio Verde, n. 10', delivery_city: 'Aracaju', delivery_state: 'SE',
                      recipient_name: 'João da Silva', product_code: 'ABCD1234', volume: 1, weight: 10, distance: 10,
                      estimated_delivery_time: 2, value: 500, shipping_company: express, status: :accepted,
                      vehicle:)
Order.create!(pickup_address: 'Av. Rio Azul, n. 310', pickup_city: 'Fortaleza', pickup_state: 'CE',
              delivery_address: 'Rua Mar Roxo, n. 210', delivery_city: 'São Luís', delivery_state: 'MA',
              recipient_name: 'Maria das Dores', product_code: 'ABCD1234', volume: 10, weight: 20, distance: 40,
              estimated_delivery_time: 2, value: 2000, shipping_company: express)

# ATUALIZAÇÕES DE TRAJETO do primeiro pedido
RouteUpdate.create!(date_and_time: 5.days.ago, latitude: 45.0, longitude: 90.0, order:)
RouteUpdate.create!(date_and_time: 1.day.ago, latitude: 50.0, longitude: 130.5, order:)
