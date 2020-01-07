require "clear"
require "../../src/db/migrations/**"
require "../../src/models/**"
require "../../src/db/seeds"

Clear::SQL.init("postgres://postgres@localhost/kemal_and_clear_sample_app", connection_pool_size: 5)
# Clear.logger.level = ::Logger::DEBUG
