class CreateUnidadDimension < ActiveRecord::Migration
    def self.up
      fields = {
        :unidad_medida_u => :string,
        :observacion_u => :string
      }
      create_table :unidad_dimension do |t|
        fields.each do |name,type|
          t.column name, type
        end
      end
      fields.each do |name,type|
        add_index :unidad_dimension, name unless type == :text      
      end
    end
  
    def self.down
      drop_table :unidad_dimension
    end
end