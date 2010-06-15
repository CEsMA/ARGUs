source :in, {  :file => '../factsFile.txt',  :parser => {  :name => :delimited,  :options => {  :col_sep => "|"  }  }}, [:tiempo_id, :unidad_id, :estacion_id, :nivelagregacion_id, :variable_id, :valor_m, :observacion_m]

transform :tiempo_id, :trim
transform :unidad_id, :trim
transform :estacion_id, :trim
transform :nivelagregacion_id, :trim
transform :valor_m, :trim
transform :observacion_m, :trim

transform :valor_m, :type, :type => :float
transform(:observacion_m){|n,v,r| v.to_s.substring(0,255)}

#before_write :require_non_blank, :fields => [:tiempo_id, :unidad_id, :estacion_id, :nivelagregacion_id, :variable_id, :valor_m]
#before_write :check_unique, :keys => [:tiempo_id, :unidad_id, :estacion_id, :nivelagregacion_id, :variable_id, :valor_m, :observacion_m]


destination :out, {:file => 'factsFileProcesada.txt' }, {:order => [:tiempo_id, :unidad_id, :estacion_id, :nivelagregacion_id, :variable_id, :valor_m, :observacion_m]}

post_process :bulk_import, {
  :file => 'factsFileProcesada.txt',
  :columns => [:tiempo_id, :unidad_id, :estacion_id, :nivelagregacion_id, :variable_id, :valor_m, :observacion_m],
  :field_separator => ',',
  :target => :development,
  :table => 'medidavarhc_facts'
}
