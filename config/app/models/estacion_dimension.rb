class EstacionDimension < ActiveWarehouse::Dimension
  define_hierarchy :nombre_est, [:nombre_est]
end