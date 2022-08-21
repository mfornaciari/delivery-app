# frozen_string_literal: true

# Transportadora EXPRESS
express = FactoryBot.create :shipping_company,
                            :without_address,
                            brand_name: 'Express',
                            corporate_name: 'Express Transportes Ltda.',
                            email_domain: 'express.com.br',
                            registration_number: 28_891_540_000_121

# ENDEREÇO da Express
FactoryBot.create :address,
                  addressable: express,
                  line1: 'Avenida A, 10',
                  city: 'Rio de Janeiro',
                  state: :RJ,
                  kind: :company

# VEÍCULOS da Express
express_vehicle1 = FactoryBot.create :vehicle,
                                     shipping_company: express,
                                     license_plate: 'BRA3R52',
                                     brand: 'Fiat',
                                     model: 'Uno',
                                     production_year: 1992,
                                     maximum_load: 100_000
FactoryBot.create :vehicle,
                  shipping_company: express,
                  license_plate: 'ARG4523',
                  brand: 'Volkswagen',
                  model: 'Fusca',
                  production_year: 1971,
                  maximum_load: 40_000

# Intervalos de VOLUME na tabela de PREÇOS da Express
express_volume_range1 = FactoryBot.create :volume_range,
                                          shipping_company: express,
                                          min_volume: 0,
                                          max_volume: 50
express_volume_range2 = FactoryBot.create :volume_range,
                                          shipping_company: express,
                                          min_volume: 51,
                                          max_volume: 100

# Intervalos de PESO na tabela de PREÇOS da Express
FactoryBot.create :weight_range,
                  volume_range: express_volume_range1,
                  min_weight: 1,
                  max_weight: 20,
                  value: 50
FactoryBot.create :weight_range,
                  volume_range: express_volume_range2,
                  min_weight: 1,
                  max_weight: 10,
                  value: 75
FactoryBot.create :weight_range,
                  volume_range: express_volume_range2,
                  min_weight: 11,
                  max_weight: 20,
                  value: 100

# Intervalos de DISTÂNCIA na tabela de PREÇOS MÍNIMOS da Express
FactoryBot.create :price_distance_range,
                  shipping_company: express,
                  min_distance: 0,
                  max_distance: 100,
                  value: 500
FactoryBot.create :price_distance_range,
                  shipping_company: express,
                  min_distance: 101,
                  max_distance: 200,
                  value: 1_000

# Intervalos de DISTÂNCIA na tabela de PRAZOS da Express
FactoryBot.create :time_distance_range,
                  shipping_company: express,
                  min_distance: 0,
                  max_distance: 100,
                  delivery_time: 2
FactoryBot.create :time_distance_range,
                  shipping_company: express,
                  min_distance: 101,
                  max_distance: 200,
                  delivery_time: 3

# Transportadora A JATO
a_jato = FactoryBot.create :shipping_company,
                           :without_address,
                           brand_name: 'A Jato',
                           corporate_name: 'A Jato S.A.',
                           email_domain: 'ajato.com',
                           registration_number: 19_824_380_000_107

# ENDEREÇO da A Jato
FactoryBot.create :address,
                  addressable: a_jato,
                  line1: 'Avenida B, 23',
                  city: 'Natal',
                  state: :RN,
                  kind: :company

# Intervalos de VOLUME na tabela de PREÇOS da A Jato
a_jato_volume_range1 = FactoryBot.create :volume_range,
                                         shipping_company: a_jato,
                                         min_volume: 0,
                                         max_volume: 100

# Intervalos de PESO na tabela de PREÇOS da A Jato
FactoryBot.create :weight_range,
                  volume_range: a_jato_volume_range1,
                  min_weight: 1,
                  max_weight: 5,
                  value: 50

# Intervalos de DISTÂNCIA na tabela de PREÇOS MÍNIMOS da A Jato
FactoryBot.create :price_distance_range,
                  shipping_company: a_jato,
                  min_distance: 0,
                  max_distance: 100,
                  value: 5_000

# Intervalos de DISTÂNCIA na tabela de PRAZOS da A Jato
FactoryBot.create :time_distance_range,
                  shipping_company: a_jato,
                  min_distance: 0,
                  max_distance: 100,
                  delivery_time: 3
FactoryBot.create :time_distance_range,
                  shipping_company: a_jato,
                  min_distance: 101,
                  max_distance: 200,
                  delivery_time: 4

# Transportadora CARROÇA E CIA.
carroca_e_cia = FactoryBot.create :shipping_company,
                                  :without_address,
                                  brand_name: 'Carroça & Cia.',
                                  corporate_name: 'Carroça Companhia Ltda.',
                                  email_domain: 'carrocaecia.com.br',
                                  registration_number: 10_659_266_000_102

# ENDEREÇO da Carroça e Cia.
FactoryBot.create :address,
                  addressable: carroca_e_cia,
                  line1: 'Avenida C, 155',
                  city: 'Tanguá',
                  state: :RJ,
                  kind: :company

# USUÁRIOS
admin = FactoryBot.create :admin,
                          email: 'admin@sistemadefrete.com.br',
                          password: 'password'
FactoryBot.create :user,
                  email: 'usuario@express.com.br',
                  password: 'password'

# CONSULTAS DE PREÇO cadastradas
FactoryBot.create :budget_search,
                  height: 100,
                  width: 100,
                  depth: 100,
                  weight: 10,
                  distance: 10,
                  admin: admin
FactoryBot.create :budget_search,
                  height: 1000,
                  width: 100,
                  depth: 100,
                  weight: 20,
                  distance: 40,
                  admin: admin

# PEDIDOS cadastrados
order1 = FactoryBot.create :order,
                           shipping_company: express,
                           vehicle: express_vehicle1,
                           status: :accepted,
                           pickup_address: 'Rua Rio Vermelho, n. 10',
                           pickup_city: 'Natal',
                           pickup_state: 'RN',
                           delivery_address: 'Rua Rio Verde, n. 10',
                           delivery_city: 'Aracaju',
                           delivery_state: 'SE',
                           recipient_name: 'João da Silva',
                           product_code: 'ABCD1234',
                           volume: 1,
                           weight: 10,
                           distance: 10,
                           estimated_delivery_time: 2,
                           value: 500
FactoryBot.create :order,
                  shipping_company: express,
                  pickup_address: 'Av. Rio Azul, n. 310',
                  pickup_city: 'Fortaleza',
                  pickup_state: 'CE',
                  delivery_address: 'Rua Mar Roxo, n. 210',
                  delivery_city: 'São Luís',
                  delivery_state: 'MA',
                  recipient_name: 'Maria das Dores',
                  product_code: 'ABCD1234',
                  volume: 10,
                  weight: 20,
                  distance: 40,
                  estimated_delivery_time: 2,
                  value: 2000

# ATUALIZAÇÕES DE TRAJETO do primeiro pedido
FactoryBot.create :route_update,
                  order: order1,
                  date_and_time: 5.days.ago,
                  latitude: 45.0,
                  longitude: 90.0
FactoryBot.create :route_update,
                  order: order1,
                  date_and_time: 1.day.ago,
                  latitude: 50.0,
                  longitude: 130.5
