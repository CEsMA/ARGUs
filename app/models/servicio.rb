class Servicio < ActiveRecord::Base
  belongs_to :usuario
  
  validates_presence_of  :descripcion, :autor, :usuario_id, :nombre, :message => "es un campo obligatorio."
  validates_numericality_of :usuario_id, :only_integer => true, :message => "es un campo numérico."
  validates_length_of :autor, :nombre, :maximum=>30, :too_long => "no puede tener más de 30 caracteres."
  validates_length_of :descripcion, :maximum=>200, :too_long => "no puede tener más de 200 caracteres."
  validates_length_of :url_owls, :url_wsdl, :maximum=>100, :too_long => "no puede tener más de 100 caracteres.", :allow_nil => true
  validates_length_of :tags, :maximum=>255, :too_long => "no puede tener más de 255 caracteres.", :allow_nil=> true
  validates_inclusion_of :habilitado, :in => [true, false],  :message => "debe ser true o false." 

end
  