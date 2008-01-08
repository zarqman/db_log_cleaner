if %w{test development}.include? ENV['RAILS_ENV']
  if defined?(ActiveRecord::ConnectionAdapters::PostgreSQLAdapter)
    ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.class_eval do
      def log_info_with_system_call_filtering(sql, name, runtime)
        if (sql.nil? || !(sql =~ /pg_(class|index|attribute|constraint|tables)/)) && (name != 'PK and serial sequence')
          log_info_without_system_call_filtering(sql, name, runtime)
        end
      end
      alias_method_chain :log_info, :system_call_filtering
    end
  end
  if defined?(ActiveRecord::ConnectionAdapters::MysqlAdapter)
    ActiveRecord::ConnectionAdapters::MysqlAdapter.class_eval do
      def log_info_with_system_call_filtering(sql, name, runtime)
        if (sql.nil? || !(sql =~ /SHOW FIELDS/))
          log_info_without_system_call_filtering(sql, name, runtime)
        end
      end
      alias_method_chain :log_info, :system_call_filtering
    end
  end
end
