source :in, {  :file => '../tiempoFile.txt',  :parser => {  :name => :delimited,  :options => {  :col_sep => "|"  }  }}, [:unidad_t, :observacion_t, :tiempo, :dia, :mes, :anio, :hora]

transform :unidad_t, :trim
transform :observacion_t, :trim
transform :tiempo, :trim
transform :dia, :trim
transform :mes, :trim
transform :anio, :trim
transform :hora, :trim
transform(:unidad_t){|n,v,r| v.to_s.slice(0,255)}
transform(:observacion_t){|n,v,r| v.to_s.slice(0,255)}

before_write :require_non_blank, :fields => [:unidad_t, :tiempo, :dia, :mes, :anio, :hora]
before_write :check_unique, :keys => [:unidad_t, :observacion_t, :tiempo, :dia, :mes, :anio, :hora]
before_write :check_exist, :target => :development, :table => 'tiempo_dimension'

destination :out, {:file => 'tiempoFileProcesada.txt' }, {:order => [:unidad_t, :observacion_t, :tiempo, :dia, :mes, :anio, :hora]}

post_process :bulk_import, {
  :file => 'tiempoFileProcesada.txt',
  :columns => [:unidad_t, :observacion_t, :tiempo, :dia, :mes, :anio, :hora],
  :field_separator => ',',
  :target => :development,
  :table => 'tiempo_dimension'
}




