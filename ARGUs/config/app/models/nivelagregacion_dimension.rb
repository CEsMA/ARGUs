class NivelagregacionDimension < ActiveWarehouse::Dimension
  define_hierarchy :nivel_agregacion, [:nivel_agregacion]
end