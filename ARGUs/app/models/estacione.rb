class Estacione < ActiveRecord::Base
  belongs_to :estado
  
  validates_presence_of     :latitud, :longitud, :pais, :informacion, :nombre, :estado_id, :message => "es un campo obligatorio."
  validates_numericality_of :latitud, :longitud, :altura, :message => "es un campo numérico (flotante).", :allow_nil => true
  validates_numericality_of :estado_id, :only_integer => true, :message => "es un campo numérico." 
  validates_length_of :pais, :maximum=>80, :too_long => "no puede tener más de 80 caracteres."
  validates_length_of :informacion, :maximum=>300, :too_long => "no puede tener más de 300 caracteres."
  validates_length_of :nombre, :codigoOMM, :maximum=>100, :too_long => "no puede tener más de 100 caracteres."
  validates_length_of :nombre, :maximum=>100, :too_long => "no puede tener más de 100 caracteres."
  validates_inclusion_of :actual, :in=> ["SI","NO"], :message=>"tiene como valores válidos 'SI' y 'NO'."
end



