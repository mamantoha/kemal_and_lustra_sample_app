require "lustra"
require "../../src/db/migrations/**"
require "../../src/models/**"
require "../../src/db/seeds"

Lustra::SQL.init("postgres://postgres@localhost/kemal_and_lustra_sample_app")

Log.builder.bind "lustra.*", :debug, Log::IOBackend.new(STDOUT)
