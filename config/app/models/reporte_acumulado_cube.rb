class ReporteAcumuladoCube < ActiveWarehouse::Cube
   reports_on :medidavarhc
   pivots_on :tiempo,:estacion,:nivelagregacion, :unidad

end
