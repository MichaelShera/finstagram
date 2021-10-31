configure do
  # Log queries to STDOUT in development
 if Sinatra::Application.development?
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    set :database, {
      adapter: "sqlite3",
      database: "db/db.sqlite3"
    }
  else
    db_url = 'postgres://uonwdbamkifopj:c2325472dba9444a7b6aefca3cb8acc7a0b5b3fe7241c1167ab1616fc59c77d9@ec2-44-199-158-170.compute-1.amazonaws.com:5432/d6uti02ktufv40'
    db = URI.parse(ENV['DATABASE_URL'] || db_url)
    set :database, {
      adapter: "postgresql",
      host: db.host,
      username: db.user,
      password: db.password,
      database: db.path[1..-1],
      encoding: "utf8"
    }
  end

  # Load all models from app/models, using autoload instead of require
  # See http://www.rubyinside.com/ruby-techniques-revealed-autoload-1652.html
  Dir[APP_ROOT.join('app', 'models', '*.rb')].each do |model_file|
    filename = File.basename(model_file).gsub('.rb', '')
    autoload ActiveSupport::Inflector.camelize(filename), model_file
  end

end