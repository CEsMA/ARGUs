class CreateMedidavarhcFacts < ActiveRecord::Migration
 def self.up
    create_table :medidavarhc_facts do |t|
      t.column :tiempo_id, :integer, :null => false
      t.column :estacion_id, :integer, :null => false
      t.column :unidad_id, :integer, :null => false
      t.column :nivelagregacion_id, :integer, :null => false
      t.column :variable_id, :integer, :null => false
      t.column :valor_m, :float, :null => false
      t.column :observacion_m, :string, :null => true
      # t.column :nombre_hc, :string, :null => false
    end
    add_index :medidavarhc_facts, :tiempo_id
    add_index :medidavarhc_facts, :estacion_id
    add_index :medidavarhc_facts, :unidad_id
    add_index :medidavarhc_facts, :nivelagregacion_id
    add_index :medidavarhc_facts, :variable_id
  end

  def self.down
    drop_table :medidavarhc_facts
  end
end