class CreateExtensions < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        enable_extension 'fuzzystrmatch'
        enable_extension 'pg_trgm'
        enable_extension 'unaccent'
      end

      dir.down do
        disable_extension 'fuzzystrmatch'
        disable_extension 'pg_trgm'
        disable_extension 'unaccent'
      end
    end
  end
end
