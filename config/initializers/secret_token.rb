# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.

if Rails.env.production? && ENV['SECRET_TOKEN'].blank?
  raise 'SECRET_TOKEN environment variable must be set!'
end

Centro::Application.config.secret_token = ENV['SECRET_TOKEN'] || 'f690fceacb4235899f36946ab4ac058124c2d5d98ecca7349a5661ff5acc5568563f9c862162ece38d5d69254a314158d24fd40a3976a378d414fb01162a1f8b'
