class CreateConsultatags < ActiveRecord::Migration
  def self.up
    create_table "consultatags ", :force => true do |t|
      t.column :consulta_id,               :integer
      t.column :tag,                       :string, :limit => 30
    end
  end

  def self.down
    drop_table "consultatags"
  end
end


