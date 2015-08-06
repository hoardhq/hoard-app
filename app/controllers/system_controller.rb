class SystemController < ApplicationController

  def index
    @system_info = {
      environment: Rails.env,
      ruby_version: RUBY_VERSION,
      hostname: `hostname`,
      server_time: `date`,
    }
    @db_info = {
      hostname: Rails.configuration.database_configuration[Rails.env]['host'],
      database: Rails.configuration.database_configuration[Rails.env]['database'],
      username: Rails.configuration.database_configuration[Rails.env]['username'],
      server_version: ActiveRecord::Base.connection.execute("SHOW server_version")[0]['server_version'],
      client_version: PG::VERSION,
      total_rows: ActiveRecord::Base.connection.execute("SELECT schemaname,relname,n_live_tup FROM pg_stat_user_tables ORDER BY n_live_tup DESC").sum { |row| row['n_live_tup'].to_i },
      total_size: ActiveRecord::Base.connection.execute('SELECT nspname || \'.\' || relname AS "relation",
    pg_relation_size(C.oid) AS "size"
  FROM pg_class C
  LEFT JOIN pg_namespace N ON (N.oid = C.relnamespace)
  WHERE nspname NOT IN (\'pg_catalog\', \'information_schema\')
  ORDER BY pg_relation_size(C.oid) DESC
  LIMIT 20;').sum { |row| row['size'].to_i }
    }
    @db_processes = ActiveRecord::Base.connection.execute("SELECT * FROM pg_stat_activity")
  end

end
