#Una clase que permite representar a la tabla de los hechos
#con un modelo AR que facilita la generacion de reportes.

class MedidavarhcFactAr < ActiveRecord::Base
  set_table_name "medidavarhc_facts"

  belongs_to :estacion_dimension_ar
  belongs_to :nivelagregacion_dimension_ar
  belongs_to :tiempo_dimension_ar
  belongs_to :unidad_dimension_ar
  belongs_to :variable_dimension_ar
end