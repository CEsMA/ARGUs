require 'ActiveWarehouse'
class MedidavarhcFact < ActiveWarehouse::Fact
  aggregate :valor_m , :label => "Valor"

  dimension :estacion
  dimension :unidad
  dimension :nivelagregacion
  dimension :tiempo
end
