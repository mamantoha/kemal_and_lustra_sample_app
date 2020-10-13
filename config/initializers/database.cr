require "clear"
require "../../src/db/migrations/**"
require "../../src/models/**"
require "../../src/db/seeds"

Clear::SQL.init("postgres://postgres@localhost/kemal_and_clear_sample_app", connection_pool_size: 5)

Log.builder.bind "clear.*", :debug, Log::IOBackend.new(STDOUT)
