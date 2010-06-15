class Solicitude < ActiveRecord::Base
  validates_presence_of  :solicitante, :requerimiento, :prioridad, :message => "es un campo obligatorio."
  validates_length_of :requerimiento, :maximum=>50, :too_long => "no puede tener más de 50 caracteres."
  validates_length_of :prioridad, :maximum=>20, :too_long => "no puede tener más de 20 caracteres."
  validates_length_of :comentarios, :maximum=>250, :too_long => "no puede tener más de 250 caracteres.", :allow_nil => true
end

