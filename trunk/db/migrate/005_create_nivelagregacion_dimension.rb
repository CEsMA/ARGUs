class CreateNivelagregacionDimension < ActiveRecord::Migration

    def self.up
      fields = {
        :nivel_agregacion => :string
      }
      create_table :nivelagregacion_dimension do |t|
        fields.each do |name,type|
          t.column name, type
        end
      end
      fields.each do |name,type|
        add_index :nivelagregacion_dimension, name unless type == :text      
      end
    end
  
    def self.down
      drop_table :nivelagregacion_dimension
    end
end