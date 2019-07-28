# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

physician = UserType.find_or_create_by(name: 'Physician')
professional = UserType.find_or_create_by(name: 'Professional')
patient = UserType.find_or_create_by(name: 'Patient')
institution = UserType.find_or_create_by(name: 'Institution')