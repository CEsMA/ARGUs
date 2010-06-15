class CreateConsultas < ActiveRecord::Migration
  def self.up
    create_table "consultas ", :force => true do |t|
      t.column :usuario_id,                :integer
      t.column :texto_pregunta,            :string, :limit => 500
    end
  end

  def self.down
    drop_table "consultas"
  end
end


