class Vinculotag < ActiveRecord::Base
   belongs_to :usuario
   
   validates_presence_of     :vinculo, :descripcion, :oficial, :usuario_id, :message => "es un campo obligatorio."
   validates_presence_of     :tag, :message => "(Palabras claves) es un campo obligatorio."
   validates_length_of :vinculo, :maximum=>100, :too_long => "no puede tener más de 100 caracteres."
   validates_length_of :tag, :maximum=>300, :too_long => "no puede tener más de 300 caracteres."
   validates_length_of :descripcion, :maximum=>200, :too_long => "no puede tener más de 200 caracteres."
   validates_length_of :oficial, :maximum=>2, :too_long => "no puede tener más de 2 caracteres."
   validates_numericality_of :usuario_id, :only_integer => true, :message => "es un campo numérico."  
   validates_inclusion_of :oficial, :in => ["SI","NO"] 
end

 