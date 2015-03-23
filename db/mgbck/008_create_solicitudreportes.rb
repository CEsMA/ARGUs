class CreateSolicitudreportes < ActiveRecord::Migration
  def self.up
    create_table :solicitudreportes do |t|
      t.column :titulo, :string
      t.column :usuario_id, :integer
      t.column :consultor_id, :integer, :default => -1
      t.column :creacion, :date
      t.column :resolucion, :date
      t.column :variable, :string
      t.column :estacion, :string
      t.column :estado, :string
      t.column :cotainferior, :string
      t.column :cotasuperior, :string
      t.column :periododetiempo, :text
      t.column :granularidad, :string
      t.column :tipoestacion, :string
      t.column :institucion, :string
      t.column :comentario, :text
    end
  end

  def self.down
    drop_table :solicitudreportes
  end
end
