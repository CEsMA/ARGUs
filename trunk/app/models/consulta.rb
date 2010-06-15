class Consulta < ActiveRecord::Base
  has_many :consultatags

  validates_presence_of :texto_pregunta, :usuario_id, :message => "es un campo obligatorio."
  validates_numericality_of :usuario_id, :only_integer => true, :message => "es un campo numérico."
  validates_length_of :texto_pregunta, :maximum=>360, :too_long => "no puede tener más de 360 caracteres."
  validates_length_of :sql_query, :maximum=>1000, :too_long => "no puede tener más de 1000 caracteres.", :allow_nil => true
  
end