class Requerimiento < ActiveRecord::Base
  validates_presence_of  :requerimiento,  :message => "es un campo obligatorio."
  validates_length_of :requerimiento, :maximum=>50, :too_long => "no puede tener más de 50 caracteres."
  validates_length_of :detalles, :maximum=>250, :too_long => "no puede tener más de 250 caracteres.", :allow_nil => true
  validates_uniqueness_of  :requerimiento, :case_sensitive => false, :message => "ya registrado."
end

