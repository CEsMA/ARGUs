class Consultatag < ActiveRecord::Base
  belongs_to :consulta
  
    validates_presence_of :consulta_id, :message => "es un campo obligatorio."
    validates_numericality_of :consulta_id, :only_integer => true, :message => "es un campo numérico."  
    validates_length_of :tag, :maximum=>30, :too_long => "no puede tener más de 30 caracteres.", :allow_nil => true
  
end
