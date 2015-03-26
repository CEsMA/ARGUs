class UsuariosInterese < ActiveRecord::Base
  belongs_to :usuario
  belongs_to :interese
  
  validates_presence_of     :usuario_id, :areainterese_id, :message => "es un campo obligatorio."
  validates_numericality_of :usuario_id, :areainterese_id, :only_integer => true, :message => "es un campo numérico."
end



 