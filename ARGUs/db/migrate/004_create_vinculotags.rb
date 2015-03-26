class CreateVinculotags < ActiveRecord::Migration
  def self.up
    create_table "vinculotags", :force => true do |t|
      t.column :usuario_id,                :integer
      t.column :vinculo,                   :string, :limit => 100
      t.column :tag,                       :string, :limit => 300
      t.column :descripcion,               :string, :limit => 200
      t.column :oficial,                   :string, :limit => 2
    end
  end

  def self.down
    drop_table "vinculotags"
  end
end
