class CreateAtributos < ActiveRecord::Migration
  def self.up
    create_table :atributos do |t|
      t.column :nombre, :string
      t.column :valor, :string
      t.column :solicitudreporte_id, :string
    end
  end

  def self.down
    drop_table :atributos
  end
end
