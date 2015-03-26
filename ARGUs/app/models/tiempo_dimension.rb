class TiempoDimension < ActiveWarehouse::Dimension
  set_order :id
  
  # define_hierarchy :variable, [:nombre_hc]
  define_hierarchy :tiempoHierar, [:anio,:mes,:dia]
end