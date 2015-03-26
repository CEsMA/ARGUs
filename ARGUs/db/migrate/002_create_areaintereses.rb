class CreateAreaintereses < ActiveRecord::Migration
  def self.up
    create_table "areaintereses", :force => true do |t|
      t.column :interes,                     :string, :limit => 50
    end
  end

  def self.down
    drop_table "areaintereses"
  end
end