class Estado < ActiveRecord::Base
  has_many :estaciones
  
  validates_presence_of  :nombre
  validates_length_of :nombre, :maximum=>40, :too_long => "no debe exceder 40 caracteres."
  validates_uniqueness_of   :nombre, :case_sensitive => false, :message => "de estado ya existente."
end
