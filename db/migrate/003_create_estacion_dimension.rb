class CreateEstacionDimension < ActiveRecord::Migration
    def self.up
      fields = {
        :nombre_est => :string,
        :latitud_est => :float,
        :longitud_est => :float,
        :altura_est => :float
      }
      create_table :estacion_dimension do |t|
        fields.each do |name,type|
          t.column name, type
        end
      end
      fields.each do |name,type|
        add_index :estacion_dimension, name unless type == :text      
      end
    end
  
    def self.down
      drop_table :estacion_dimension
    end
end