module PgHero
  module Kill
    def kill(pid)
      execute("SELECT pg_terminate_backend(#{pid.to_i})").first["pg_terminate_backend"] == "t"
    end

    def kill_long_running_queries
      long_running_queries.each { |query| kill(query["pid"]) }
      true
    end

    def kill_all
      select_all <<-SQL
        SELECT
          pg_terminate_backend(pid)
        FROM
          pg_stat_activity
        WHERE
          pid <> pg_backend_pid()
          AND query <> '<insufficient privilege>'
      SQL
      true
    end
  end
end
