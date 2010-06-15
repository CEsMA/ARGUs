class Areainterese < ActiveRecord::Base
  has_many :usuario_interese
  
  validates_presence_of     :interes,  :message => "es un campo obligatorio."
  validates_length_of :interes, :maximum=>50, :too_long => "no puede tener más de 50 caracteres."
  validates_uniqueness_of   :interes, :case_sensitive => false, :message => "ya está registrado."
end



