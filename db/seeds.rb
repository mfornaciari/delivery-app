# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

express = ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                  email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                  address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
ShippingCompany.create!(brand_name: 'A Jato', corporate_name: 'A Jato S.A.',
                        email_domain: 'ajato.com', registration_number: 19_824_380_000_107,
                        address: 'Avenida B, 23', city: 'Natal', state: 'RN')

Vehicle.create!(license_plate: 'BRA3R52', brand: 'Fiat', model: 'Uno', production_year: 1992,
                maximum_load: 100_000, shipping_company: express)
Vehicle.create!(license_plate: 'ARG4523', brand: 'Volkswagen', model: 'Fusca', production_year: 1971,
                maximum_load: 40_000, shipping_company: express)

first_volume_range = VolumeRange.create!(shipping_company: express, min_volume: 1, max_volume: 50)
second_volume_range = VolumeRange.create!(shipping_company: express, min_volume: 51, max_volume: 100)
WeightRange.create!(volume_range: first_volume_range, min_weight: 1, max_weight: 20, value: 50)
WeightRange.create!(volume_range: first_volume_range, min_weight: 21, max_weight: 40, value: 75)
WeightRange.create!(volume_range: second_volume_range, min_weight: 1, max_weight: 20, value: 75)

PriceDistanceRange.create!(shipping_company: express, min_distance: 0, max_distance: 100, value: 5000)
PriceDistanceRange.create!(shipping_company: express, min_distance: 101, max_distance: 200, value: 10000)

TimeDistanceRange.create!(shipping_company: express, min_distance: 0, max_distance: 100, delivery_time: 2)
TimeDistanceRange.create!(shipping_company: express, min_distance: 101, max_distance: 200, delivery_time: 3)

Admin.create!(email: 'admin@sistemadefrete.com.br', password: 'password')
User.create!(email: 'usuario@express.com.br', password: 'password')
