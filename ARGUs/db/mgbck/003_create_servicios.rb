require "migration_helpers" 

class CreateServicios < ActiveRecord::Migration
  extend MigrationHelpers
  
  def self.up
    create_table "servicios", :force => true do |t|
      t.column :nombre,                    :string, :limit => 30
      t.column :descripcion,               :string, :limit => 200
      t.column :habilitado,                :boolean
      t.column :autor,                     :string, :limit => 30
      t.column :usuario_id,                :integer
      t.column :url_wsdl,                  :string, :limit => 100
      t.column :url_owls,                  :string, :limit => 100
      t.column :tags,                      :string, :limit => 255
    end
    
    foreign_key(:servicios, :usuario_id, :usuarios)
  end

  def self.down
    drop_table "servicios"
  end
end
