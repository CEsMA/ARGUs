class CreateReportepentahos < ActiveRecord::Migration
  def self.up
    create_table :reportepentahos do |t|
      t.column :usuarios_id, :integer
      t.column :solicitudreporte_id, :integer
      t.column :link, :string
      t.column :privado, :boolean, :default => true
    end
  end

  def self.down
    drop_table :reportepentahos
  end
end
