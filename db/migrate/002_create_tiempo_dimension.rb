class CreateTiempoDimension < ActiveRecord::Migration
    def self.up
      fields = {
        :unidad_t => :string,
        :observacion_t => :string,
        :tiempo => :date,
        :dia => :integer,
        :mes => :integer,
        :anio => :integer,
        :hora => :time,
       }
      create_table :tiempo_dimension do |t|
        fields.each do |name,type|
          t.column name, type
        end
      end
      fields.each do |name,type|
        add_index :tiempo_dimension, name unless type == :text      
      end
    end
  
    def self.down
      drop_table :tiempo_dimension
    end
end