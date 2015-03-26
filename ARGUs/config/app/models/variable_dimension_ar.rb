#Una clase que permite representar a la tabla de la dimension
#variable con un modelo AR que facilita la generacion de reportes. 

class VariableDimensionAr < ActiveRecord::Base
  set_table_name "variable_dimension"
end