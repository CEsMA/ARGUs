class ReportesarController < ApplicationController

  def prepvariable
    @variables = VariableDimensionAr.find(:all, :order => 'nombre_hc ASC')
    @variables.each{|v|
      v.nombre_hc =  v.nombre_hc+' ('+v.id.to_s+')'
    }
  end

  def variable
    var = params[:variable]
    var = var[:id]
    variable = VariableDimensionAr.find(var).nombre_hc.to_s
    nombre = variable+".csv"

@registros = MedidavarhcFactAr.find_by_sql 'SELECT
           "medidavarhc_facts"."valor_m",
           "tiempo_dimension"."tiempo",
           "nivelagregacion_dimension"."nivel_agregacion",
           "unidad_dimension"."unidad_medida_u",
           "estacion_dimension"."nombre_est",
           "estaciones"."estado_acron",
           "estaciones"."serial_e",
           "estaciones"."tipo_estacion"
	 FROM
           "medidavarhc_facts" INNER JOIN "tiempo_dimension" ON "medidavarhc_facts"."tiempo_id" = "tiempo_dimension"."id"
           INNER JOIN "variable_dimension" ON "medidavarhc_facts"."variable_id" = "variable_dimension"."id"
           INNER JOIN "estacion_dimension" ON "medidavarhc_facts"."estacion_id" = "estacion_dimension"."id"
           INNER JOIN "estaciones" ON "medidavarhc_facts"."estacion_id" = "estaciones"."id"
	   INNER JOIN "nivelagregacion_dimension" ON "medidavarhc_facts"."nivelagregacion_id" = "nivelagregacion_dimension"."id"
           INNER JOIN "unidad_dimension" ON "medidavarhc_facts"."unidad_id" = "unidad_dimension"."id"
         WHERE
            "medidavarhc_facts"."variable_id" = '+var+'
         ORDER BY
            "estacion_dimension"."nombre_est"'


      csv_string = FasterCSV.generate do |csv|
        # header row
        csv << ["Valor", "Unidad de medida", "Fecha", "Acrónimo del estado", "Estacion", "Tipo de Estacion","Serial Estacion"]
        # data rows
        @registros.each do |registro|
          csv << [registro.valor_m, registro.unidad_medida_u, registro.tiempo, registro.estado_acron, registro.nombre_est, registro.tipo_estacion, registro.serial_e]
        end
      end

      # send it to the browsah
      send_data csv_string,
              :type => 'text/csv; charset=iso-8859-1; header=present',
               :disposition => "attachment; filename=\"#{nombre}\""

  end

  def prepestacionvariable
    @estaciones = Estacione.find(:all, :order => 'nombre ASC')
    @estaciones.each{|e|
      e.nombre =  e.nombre+' ('+e.serial_e.to_s+')'
    }
    @variables = VariableDimensionAr.find(:all, :order => 'nombre_hc ASC')
    @variables.each{|v|
      v.nombre_hc =  v.nombre_hc+' ('+v.id.to_s+')'
    }
  end

  def estacionvariable
    var = params[:variable]
    var = var[:id]
    est = params[:estacion]
    est = est[:id]
    variable = VariableDimensionAr.find(var).nombre_hc.to_s
    nombre = variable + "_" +EstacionDimensionAr.find(est).nombre_est.to_s + ".csv"
      
    @registros = MedidavarhcFactAr.find_by_sql 'SELECT
           "medidavarhc_facts"."valor_m",
           "tiempo_dimension"."tiempo",
           "nivelagregacion_dimension"."nivel_agregacion",
           "unidad_dimension"."unidad_medida_u",
           "estacion_dimension"."nombre_est",
	   "estaciones"."estado_acron",
     	   "estaciones"."serial_e",
           "estaciones"."tipo_estacion"
         FROM
           "medidavarhc_facts" INNER JOIN "tiempo_dimension" ON "medidavarhc_facts"."tiempo_id" = "tiempo_dimension"."id"
           INNER JOIN "variable_dimension" ON "medidavarhc_facts"."variable_id" = "variable_dimension"."id"
	   INNER JOIN "estaciones" ON "medidavarhc_facts"."estacion_id" = "estaciones"."id"
           INNER JOIN "estacion_dimension" ON "medidavarhc_facts"."estacion_id" = "estacion_dimension"."id"
           INNER JOIN "nivelagregacion_dimension" ON "medidavarhc_facts"."nivelagregacion_id" = "nivelagregacion_dimension"."id"
           INNER JOIN "unidad_dimension" ON "medidavarhc_facts"."unidad_id" = "unidad_dimension"."id" 
         WHERE
            "medidavarhc_facts"."variable_id" = '+var+'
          AND "medidavarhc_facts"."estacion_id" = '+est+'
         ORDER BY
            "tiempo_dimension"."tiempo"'

      csv_string = FasterCSV.generate do |csv|
        # header row
        csv << ["Valor", "Unidad de medida", "Fecha", "Acrónimo del estado", "Estacion", "Tipo de Estación","Serial Estacion"]
        # data rows
        @registros.each do |registro|
          csv << [registro.valor_m, registro.unidad_medida_u, registro.tiempo, registro.estado_acron, registro.nombre_est, registro.tipo_estacion, registro.serial_e]
        end
      end
      
      # send it to the browsah
      send_data csv_string,
              :type => 'text/csv; charset=iso-8859-1; header=present',
               :disposition => "attachment; filename=\"#{nombre}\""

  end

  def prepestacionvariablefecha
    @estaciones = Estacione.find(:all, :order => 'nombre ASC')
    @estaciones.each{|e|
      e.nombre =  e.nombre+' ('+e.serial_e.to_s+')'
    }
    @variables = VariableDimensionAr.find(:all, :order => 'nombre_hc ASC')
    @variables.each{|v|
      v.nombre_hc =  v.nombre_hc+' ('+v.id.to_s+')'
    }
  end

  def estacionvariablefecha
    var = params[:variable]
    var = var[:id]
    est = params[:estacion]
    est = est[:id]
    fecha = params[:date]
    #fechaini = Date.civil(y=fecha[:anho_inicial].to_i ,m=fecha[:mes_inicial].to_i, d=fecha[:dia_inicial].to_i )
    #fechafin = Date.civil(y=fecha[:anho_final].to_i ,m=fecha[:mes_final].to_i, d=fecha[:dia_final].to_i )

    @registros = MedidavarhcFactAr.find_by_sql 'SELECT
           "medidavarhc_facts"."valor_m",
           "tiempo_dimension"."tiempo",
           "nivelagregacion_dimension"."nivel_agregacion",
           "unidad_dimension"."unidad_medida_u",
           "estacion_dimension"."nombre_est",
	   "estaciones"."estado_acron",
     	   "estaciones"."serial_e",
    	   "estaciones"."tipo_estacion"
	FROM
           "medidavarhc_facts" INNER JOIN "tiempo_dimension" ON "medidavarhc_facts"."tiempo_id" = "tiempo_dimension"."id"
           INNER JOIN "variable_dimension" ON "medidavarhc_facts"."variable_id" = "variable_dimension"."id"
           INNER JOIN "estacion_dimension" ON "medidavarhc_facts"."estacion_id" = "estacion_dimension"."id"
	   INNER JOIN "estaciones" ON "medidavarhc_facts"."estacion_id" = "estaciones"."id"
	   INNER JOIN "nivelagregacion_dimension" ON "medidavarhc_facts"."nivelagregacion_id" = "nivelagregacion_dimension"."id"
           INNER JOIN "unidad_dimension" ON "medidavarhc_facts"."unidad_id" = "unidad_dimension"."id"
         WHERE
            "medidavarhc_facts"."variable_id" = '+var+'
          AND "medidavarhc_facts"."estacion_id" = '+est+'
          AND "tiempo_dimension"."tiempo" >= date \''+fecha[:anho_inicial].to_s+'-'+fecha[:mes_inicial].to_s+'-'+fecha[:dia_inicial].to_s+'\'
          AND "tiempo_dimension"."tiempo" <= date \''+fecha[:anho_final].to_s+'-'+fecha[:mes_final].to_s+'-'+fecha[:dia_final].to_s+'\'
          ORDER BY
            "tiempo_dimension"."tiempo"'

      csv_string = FasterCSV.generate do |csv|
         #header row
        csv << ["Valor", "Unidad de medida", "Fecha", "Acrónimo del estado", "Estacion", "Tipo de Estación","Serial Estacion"]
        # data rows
        @registros.each do |registro|
          csv << [registro.valor_m, registro.unidad_medida_u, registro.tiempo, registro.estado_acron, registro.nombre_est, registro.tipo_estacion, registro.serial_e]
        end
      end

      # send it to the browsah
      send_data csv_string,
              :type => 'text/csv; charset=iso-8859-1; header=present',
               :disposition => "attachment; filename=\""+VariableDimensionAr.find(var).nombre_hc+"_"+EstacionDimensionAr.find(est).nombre_est+".csv\""

  end

  def prepalturavariable
    @variables = VariableDimensionAr.find(:all, :order => 'nombre_hc ASC')
    @variables.each{|v|
      v.nombre_hc =  v.nombre_hc+' ('+v.id.to_s+')'
    }
  end

  def alturavariable
    var = params[:variable]
    var = var[:id]
    inf = params[:cotainferior]
    sup = params[:cotasuperior]

    @registros = MedidavarhcFactAr.find_by_sql 'SELECT
     "medidavarhc_facts"."valor_m",
     "tiempo_dimension"."tiempo",
     "tiempo_dimension"."hora",
     "unidad_dimension"."unidad_medida_u",
     "estacion_dimension"."nombre_est",
     "estacion_dimension"."altura_est",
     "estaciones"."estado_acron",
     "estaciones"."serial_e",
     "estaciones"."tipo_estacion"
FROM
     "medidavarhc_facts" INNER JOIN "tiempo_dimension" ON "medidavarhc_facts"."tiempo_id" =
     "tiempo_dimension"."id"
     INNER JOIN "estacion_dimension" ON "medidavarhc_facts"."estacion_id" =
     "estacion_dimension"."id"
     INNER JOIN "nivelagregacion_dimension" ON "medidavarhc_facts"."nivelagregacion_id" =
     "nivelagregacion_dimension"."id"
     INNER JOIN "unidad_dimension" ON "medidavarhc_facts"."unidad_id" =
     "unidad_dimension"."id"
     INNER JOIN "estaciones" ON "medidavarhc_facts"."estacion_id" = "estaciones"."id"
WHERE
     "medidavarhc_facts"."variable_id" = '+var+'
 AND "estacion_dimension"."altura_est" >= '+inf+'
 AND "estacion_dimension"."altura_est" <= '+sup+'
ORDER BY
     "estacion_dimension"."nombre_est"'

      csv_string = FasterCSV.generate do |csv|
         #header row
        csv << ["Valor", "Unidad de medida", "Fecha", "Acrónimo del estado","Altura", "Estacion", "Tipo de Estación","Serial Estacion"]
        # data rows
        @registros.each do |registro|
          csv << [registro.valor_m, registro.unidad_medida_u, registro.tiempo, registro.estado_acron,registro.altura_est, registro.nombre_est, registro.tipo_estacion,registro.serial_e]
        end
      end

    render_text "Su reporte se produjo con exito."
      # send it to the browsah
      send_data csv_string,
              :type => 'text/csv; charset=iso-8859-1; header=present',
               :disposition => "attachment; filename=\""+VariableDimensionAr.find(var).nombre_hc+"_de_"+inf.to_s+"_a_"+sup+"metros.csv\""

  end

  def prepalturavariablefecha
    @variables = VariableDimensionAr.find(:all, :order => 'nombre_hc ASC')
    @variables.each{|v|
      v.nombre_hc =  v.nombre_hc+' ('+v.id.to_s+')'
    }
  end
  
  def alturavariablefecha
    var = params[:variable]
    var = var[:id]
    inf = params[:cotainferior]
    sup = params[:cotasuperior]
    fecha = params[:date]

    @registros = MedidavarhcFactAr.find_by_sql 'SELECT
           "medidavarhc_facts"."valor_m",
           "tiempo_dimension"."tiempo",
           "tiempo_dimension"."hora",
           "nivelagregacion_dimension"."nivel_agregacion",
           "variable_dimension"."nombre_hc",
           "unidad_dimension"."unidad_medida_u",
           "estacion_dimension"."nombre_est",
           "estacion_dimension"."altura_est",
	   "estaciones"."estado_acron",
           "estaciones"."serial_e",
           "estaciones"."tipo_estacion"
      FROM
           "medidavarhc_facts" INNER JOIN "tiempo_dimension" ON "medidavarhc_facts"."tiempo_id" = "tiempo_dimension"."id"
           INNER JOIN "variable_dimension" ON "medidavarhc_facts"."variable_id" = "variable_dimension"."id"
           INNER JOIN "estacion_dimension" ON "medidavarhc_facts"."estacion_id" = "estacion_dimension"."id"
	   INNER JOIN "estaciones" ON "medidavarhc_facts"."estacion_id" = "estaciones"."id"
           INNER JOIN "nivelagregacion_dimension" ON "medidavarhc_facts"."nivelagregacion_id" = "nivelagregacion_dimension"."id"
           INNER JOIN "unidad_dimension" ON "medidavarhc_facts"."unidad_id" = "unidad_dimension"."id"
      WHERE
           "medidavarhc_facts"."variable_id" = '+var+'
        AND "estacion_dimension"."altura_est" >= '+inf+'
        AND "estacion_dimension"."altura_est" <= '+sup+'
        AND "tiempo_dimension"."tiempo" >= date \''+fecha[:anho_inicial].to_s+'-'+fecha[:mes_inicial].to_s+'-'+fecha[:dia_inicial].to_s+'\'
        AND "tiempo_dimension"."tiempo" <= date \''+fecha[:anho_final].to_s+'-'+fecha[:mes_final].to_s+'-'+fecha[:dia_final].to_s+'\'
      ORDER BY
        "estacion_dimension"."nombre_est", "tiempo_dimension"."tiempo"'

      csv_string = FasterCSV.generate do |csv|
         #header row
        csv << ["Valor", "Unidad de medida", "Fecha", "Acrónimo del estado","Altura", "Estacion", "Tipo de Estacion","Serial Estacion"]
        # data rows
        @registros.each do |registro|
          csv << [registro.valor_m, registro.unidad_medida_u, registro.tiempo, registro.estado_acron, registro.altura_est, registro.nombre_est, registro.tipo_estacion,registro.serial_e]
        end
      end

    render_text "Su reporte se produjo con exito."
      # send it to the browsah
      send_data csv_string,
              :type => 'text/csv; charset=iso-8859-1; header=present',
               :disposition => "attachment; filename=\""+VariableDimensionAr.find(var).nombre_hc+"_de_"+inf.to_s+"_a_"+sup+"metros.csv\""

  end

  def prepvariablecuadrante
    @variables = VariableDimensionAr.find(:all, :order => 'nombre_hc ASC')
    @variables.each{|v|
      v.nombre_hc =  v.nombre_hc+' ('+v.id.to_s+')'
    }
  end

  def variablecuadrante
    var = params[:variable]
    var = var[:id]
    latinf = params[:latinferior]
    latsup = params[:latsuperior]
    longinf = params[:longinferior]
    longsup = params[:longsuperior]

    @registros = MedidavarhcFactAr.find_by_sql 'SELECT
     "medidavarhc_facts"."valor_m",
     "tiempo_dimension"."tiempo",
     "unidad_dimension"."unidad_medida_u",
     "estacion_dimension"."nombre_est",
     "estacion_dimension"."latitud_est",
     "estacion_dimension"."longitud_est",
     "estacion_dimension"."altura_est",
     "estaciones"."estado_acron",
     "estaciones"."serial_e",
     "estaciones"."tipo_estacion"
FROM
     "medidavarhc_facts" INNER JOIN "tiempo_dimension" ON "medidavarhc_facts"."tiempo_id" = "tiempo_dimension"."id"
     INNER JOIN "estacion_dimension" ON "medidavarhc_facts"."estacion_id" = "estacion_dimension"."id"
     INNER JOIN "nivelagregacion_dimension" ON "medidavarhc_facts"."nivelagregacion_id" = "nivelagregacion_dimension"."id"
     INNER JOIN "unidad_dimension" ON "medidavarhc_facts"."unidad_id" = "unidad_dimension"."id"
     INNER JOIN "estaciones" ON "medidavarhc_facts"."estacion_id" = "estaciones"."id"
WHERE
     "medidavarhc_facts"."variable_id" = '+var+'
     AND "estacion_dimension"."latitud_est" >= '+latinf+'
 	AND "estacion_dimension"."latitud_est" <= '+latsup+'
 	AND "estacion_dimension"."longitud_est" >= '+longinf+'
 	AND "estacion_dimension"."longitud_est" <= '+longsup+'
ORDER BY
        "estacion_dimension"."nombre_est", "tiempo_dimension"."tiempo"'

      csv_string = FasterCSV.generate do |csv|
         #header row
        csv << ["Valor", "Unidad de medida", "Fecha", "Acrónimo del estado","Latitud", "Longitud", "Altura","Estacion", "Tipo de Estación","Serial Estacion"]
        # data rows
        @registros.each do |registro|
          csv << [registro.valor_m, registro.unidad_medida_u, registro.tiempo, registro.estado_acron, registro.latitud_est, registro.longitud_est, registro.altura_est,registro.nombre_est, registro.tipo_estacion, registro.serial_e]
        end
      end

    render_text "Su reporte se produjo con exito."
      # send it to the browsah
      send_data csv_string,
              :type => 'text/csv; charset=iso-8859-1; header=present',
               :disposition => "attachment;
                  filename=\""+VariableDimensionAr.find(var).nombre_hc+"_cuadrante_"+latinf+","+latsup+","+longinf+","+longsup+".csv\""

  end

  def prepvariablecuadrantefechas
    @variables = VariableDimensionAr.find(:all, :order => 'nombre_hc ASC')
    @variables.each{|v|
      v.nombre_hc =  v.nombre_hc+' ('+v.id.to_s+')'
    }
  end

  def variablecuadrantefechas
    var = params[:variable]
    var = var[:id]
    nombrevar = VariableDimensionAr.find(var).nombre_hc
    latinf = params[:latinferior]
    latsup = params[:latsuperior]
    longinf = params[:longinferior]
    longsup = params[:longsuperior]
    fecha = params[:date]
    ai = fecha[:anho_inicial].to_s
    mi = fecha[:mes_inicial].to_s
    di = fecha[:dia_inicial].to_s
    af = fecha[:anho_final].to_s
    mf = fecha[:mes_final].to_s
    df = fecha[:dia_final].to_s

    @registros = MedidavarhcFactAr.find_by_sql 'SELECT
          "medidavarhc_facts"."valor_m",
          "tiempo_dimension"."tiempo",
          "tiempo_dimension"."hora",
          "nivelagregacion_dimension"."nivel_agregacion",
          "variable_dimension"."nombre_hc",
          "unidad_dimension"."unidad_medida_u",
          "estacion_dimension"."nombre_est",
          "estacion_dimension"."latitud_est",
          "estacion_dimension"."longitud_est",
	  "estacion_dimension"."altura_est",
	  "estaciones"."estado_acron",
     	  "estaciones"."serial_e",
     	  "estaciones"."tipo_estacion"
	FROM
          "medidavarhc_facts" INNER JOIN "tiempo_dimension" ON "medidavarhc_facts"."tiempo_id" = "tiempo_dimension"."id"
          INNER JOIN "variable_dimension" ON "medidavarhc_facts"."variable_id" = "variable_dimension"."id"
          INNER JOIN "estacion_dimension" ON "medidavarhc_facts"."estacion_id" = "estacion_dimension"."id"
          INNER JOIN "nivelagregacion_dimension" ON "medidavarhc_facts"."nivelagregacion_id" = "nivelagregacion_dimension"."id"
          INNER JOIN "unidad_dimension" ON "medidavarhc_facts"."unidad_id" = "unidad_dimension"."id"
	  INNER JOIN "estaciones" ON "medidavarhc_facts"."estacion_id" = "estaciones"."id"
        WHERE
              "medidavarhc_facts"."variable_id" = '+var+'
          AND "estacion_dimension"."latitud_est" >= '+latinf+'
          AND "estacion_dimension"."latitud_est" <= '+latsup+'
          AND "estacion_dimension"."longitud_est" >= '+longinf+'
          AND "estacion_dimension"."longitud_est" <= '+longsup+'
          AND "tiempo_dimension"."tiempo" >= date \''+ai+'-'+mi+'-'+di+'\'
          AND "tiempo_dimension"."tiempo" <= date \''+af+'-'+mf+'-'+df+'\'
        ORDER BY
          "estacion_dimension"."nombre_est", "tiempo_dimension"."tiempo"'

      csv_string = FasterCSV.generate do |csv|
         #header row
        csv << ["Valor", "Unidad de medida", "Fecha", "Acrónimo del estado","Latitud", "Longitud","Altura", "Estacion", "Tipo de Estación", "Serial Estacion"]
        # data rows
        @registros.each do |registro|
          csv << [registro.valor_m, registro.unidad_medida_u, registro.tiempo, registro.estado_acron, registro.latitud_est, registro.longitud_est, registro.altura_est, registro.nombre_est, registro.tipo_estacion, registro.serial_e]
        end
      end

    render_text "Su reporte se produjo con exito."
      # send it to the browsah
      send_data csv_string,
              :type => 'text/csv; charset=iso-8859-1; header=present',
               :disposition => "attachment; 
                      filename=\""+nombrevar+"_cuadrante_"+latinf+","+latsup+","+longinf+","+longsup+".csv\""
    #_del_"+di+"/"+mi+"/"+ai+"_al_"+df+"/"+mf+"/"+af+"_cuadrante:"+latinf+","+latsup+","+longinf+","+longsup+
  end

  def prepvariableparalelepipedo
    @variables = VariableDimensionAr.find(:all, :order => 'nombre_hc ASC')
    @variables.each{|v|
      v.nombre_hc =  v.nombre_hc+' ('+v.id.to_s+')'
    }
  end

  def variableparalelepipedo
    var = params[:variable]
    var = var[:id]
    latinf = params[:latinferior]
    latsup = params[:latsuperior]
    longinf = params[:longinferior]
    longsup = params[:longsuperior]
    inf = params[:cotainferior]
    sup = params[:cotasuperior]


    @registros = MedidavarhcFactAr.find_by_sql 'SELECT
         "medidavarhc_facts"."valor_m",
         "tiempo_dimension"."tiempo",
         "tiempo_dimension"."hora",
         "nivelagregacion_dimension"."nivel_agregacion",
         "variable_dimension"."nombre_hc",
         "unidad_dimension"."unidad_medida_u",
         "estacion_dimension"."nombre_est",
         "estacion_dimension"."latitud_est",
         "estacion_dimension"."longitud_est",
         "estacion_dimension"."altura_est",
	 "estaciones"."estado_acron",
     	 "estaciones"."serial_e",
     	 "estaciones"."tipo_estacion"
        FROM
         "medidavarhc_facts" INNER JOIN "tiempo_dimension" ON "medidavarhc_facts"."tiempo_id" = "tiempo_dimension"."id"
         INNER JOIN "variable_dimension" ON "medidavarhc_facts"."variable_id" = "variable_dimension"."id"
         INNER JOIN "estacion_dimension" ON "medidavarhc_facts"."estacion_id" = "estacion_dimension"."id"
         INNER JOIN "nivelagregacion_dimension" ON "medidavarhc_facts"."nivelagregacion_id" = "nivelagregacion_dimension"."id"
         INNER JOIN "unidad_dimension" ON "medidavarhc_facts"."unidad_id" = "unidad_dimension"."id"
	 INNER JOIN "estaciones" ON "medidavarhc_facts"."estacion_id" = "estaciones"."id"
        WHERE
          "medidavarhc_facts"."variable_id" = '+var+'
          AND "estacion_dimension"."altura_est" >= '+inf+'
          AND "estacion_dimension"."altura_est" <= '+sup+'
          AND "estacion_dimension"."latitud_est" >= '+latinf+'
          AND "estacion_dimension"."latitud_est" <= '+latsup+'
          AND "estacion_dimension"."longitud_est" >= '+longinf+'
          AND "estacion_dimension"."longitud_est" <= '+longsup+'
        ORDER BY
          "estacion_dimension"."nombre_est", "tiempo_dimension"."tiempo"'

      csv_string = FasterCSV.generate do |csv|
         #header row
        csv << ["Valor", "Unidad de medida", "Fecha", "Acrónimo del estado","Latitud", "Longitud","Altura","Estacion", "Tipo de Estación","Serial Estacion"]
        # data rows
        @registros.each do |registro|
          csv << [registro.valor_m, registro.unidad_medida_u, registro.tiempo, registro.estado_acron, registro.latitud_est, registro.longitud_est, registro.altura_est,registro.nombre_est, registro.tipo_estacion, registro.serial_e]
        end
      end

    render_text "Su reporte se produjo con exito."
      # send it to the browsah
      send_data csv_string,
              :type => 'text/csv; charset=iso-8859-1; header=present',
               :disposition => "attachment;
                filename=\""+VariableDimensionAr.find(var).nombre_hc+"_cuad_"+latinf+","+latsup+","+longinf+","+longsup+"_"+inf+"_a_"+sup+"M.csv\""

  end

  def prepvariableparalelepipedofechas
    @variables = VariableDimensionAr.find(:all, :order => 'nombre_hc ASC')
    @variables.each{|v|
      v.nombre_hc =  v.nombre_hc+' ('+v.id.to_s+')'
    }
  end

  def variableparalelepipedofechas
    var = params[:variable]
    var = var[:id]
    latinf = params[:latinferior]
    latsup = params[:latsuperior]
    longinf = params[:longinferior]
    longsup = params[:longsuperior]
    inf = params[:cotainferior]
    sup = params[:cotasuperior]
    fecha = params[:date]
    ai = fecha[:anho_inicial].to_s
    mi = fecha[:mes_inicial].to_s
    di = fecha[:dia_inicial].to_s
    af = fecha[:anho_final].to_s
    mf = fecha[:mes_final].to_s
    df = fecha[:dia_final].to_s



    @registros = MedidavarhcFactAr.find_by_sql 'SELECT
           "medidavarhc_facts"."valor_m",
           "tiempo_dimension"."tiempo",
           "tiempo_dimension"."hora",
           "nivelagregacion_dimension"."nivel_agregacion",
           "variable_dimension"."nombre_hc",
           "unidad_dimension"."unidad_medida_u",
           "estacion_dimension"."nombre_est",
           "estacion_dimension"."latitud_est",
           "estacion_dimension"."longitud_est",
           "estacion_dimension"."altura_est",
	   "estaciones"."estado_acron",
    	   "estaciones"."serial_e",
    	   "estaciones"."tipo_estacion"
      FROM
           "medidavarhc_facts" INNER JOIN "tiempo_dimension" ON "medidavarhc_facts"."tiempo_id" = "tiempo_dimension"."id"
           INNER JOIN "variable_dimension" ON "medidavarhc_facts"."variable_id" = "variable_dimension"."id"
           INNER JOIN "estacion_dimension" ON "medidavarhc_facts"."estacion_id" = "estacion_dimension"."id"
           INNER JOIN "nivelagregacion_dimension" ON "medidavarhc_facts"."nivelagregacion_id" = "nivelagregacion_dimension"."id"
           INNER JOIN "unidad_dimension" ON "medidavarhc_facts"."unidad_id" = "unidad_dimension"."id"
	   INNER JOIN "estaciones" ON "medidavarhc_facts"."estacion_id" = "estaciones"."id"
      WHERE
                "medidavarhc_facts"."variable_id" = '+var+'
                AND "estacion_dimension"."altura_est" >= '+inf+'
                AND "estacion_dimension"."altura_est" <= '+sup+'
                AND "estacion_dimension"."latitud_est" >= '+latinf+'
                AND "estacion_dimension"."latitud_est" <= '+latsup+'
                AND "estacion_dimension"."longitud_est" >= '+longinf+'
                AND "estacion_dimension"."longitud_est" <= '+longsup+'
          	AND "tiempo_dimension"."tiempo" >= date \''+ai+'-'+mi+'-'+di+'\'
          	AND "tiempo_dimension"."tiempo" <= date \''+af+'-'+mf+'-'+df+'\'
       ORDER BY
        "estacion_dimension"."nombre_est", "tiempo_dimension"."tiempo"'

      csv_string = FasterCSV.generate do |csv|
         #header row
        csv << ["Valor", "Unidad de medida", "Fecha", "Acrónimo del estado","Latitud", "Longitud","Altura" ,"Estacion", "Tipo de Estación","Serial Estacion"]
        # data rows
        @registros.each do |registro|
          csv << [registro.valor_m, registro.unidad_medida_u, registro.tiempo, registro.estado_acron, registro.latitud_est, registro.altura_est, registro.longitud_est, registro.nombre_est, registro.tipo_estacion, registro.serial_e]
        end
      end

    render_text "Su reporte se produjo con exito."
      # send it to the browsah
      send_data csv_string,
              :type => 'text/csv; charset=iso-8859-1; header=present',
               :disposition => "attachment;
                filename=\""+VariableDimensionAr.find(var).nombre_hc+"_cuad_"+latinf+","+latsup+","+longinf+","+longsup+"_"+inf+"_a_"+sup+"M.csv\""

  end
  
  def prepvariableestado
    @variables = VariableDimensionAr.find(:all, :order => 'nombre_hc ASC')
    @variables.each{|v|
      v.nombre_hc =  v.nombre_hc+' ('+v.id.to_s+')'
    }
    @estados = Estado.find(:all, :order => 'nombre ASC')
  end

  def variableestado
    var = params[:variable]
    var = var[:id]
    edo = params[:estado]
    edo = edo[:acronimo]
    
    @registros = MedidavarhcFactAr.find_by_sql 'SELECT
           "medidavarhc_facts"."valor_m",
           "tiempo_dimension"."tiempo",
           "tiempo_dimension"."hora",
           "nivelagregacion_dimension"."nivel_agregacion",
           "variable_dimension"."nombre_hc",
           "unidad_dimension"."unidad_medida_u",
           "estaciones"."nombre",
           "estaciones"."latitud",
           "estaciones"."longitud",
           "estaciones"."estado_acron",
           "estaciones"."altura",
	   "estaciones"."serial_e",
     	   "estaciones"."tipo_estacion"
      FROM
           "medidavarhc_facts" INNER JOIN "tiempo_dimension" ON "medidavarhc_facts"."tiempo_id" = "tiempo_dimension"."id"
           INNER JOIN "variable_dimension" ON "medidavarhc_facts"."variable_id" = "variable_dimension"."id"
           INNER JOIN "estaciones" ON "medidavarhc_facts"."estacion_id" = "estaciones"."id"
           INNER JOIN "nivelagregacion_dimension" ON "medidavarhc_facts"."nivelagregacion_id" = "nivelagregacion_dimension"."id"
           INNER JOIN "unidad_dimension" ON "medidavarhc_facts"."unidad_id" = "unidad_dimension"."id"
      WHERE
                "medidavarhc_facts"."variable_id" = '+var+'
                AND "estaciones"."estado_acron" LIKE \''+edo+'\'
  ORDER BY
        "estaciones"."nombre", "tiempo_dimension"."tiempo"'
                    
          csv_string = FasterCSV.generate do |csv|
         #header row
        csv << ["Valor", "Unidad de medida", "Fecha", "Acrónimo del estado", "Latitud", "Longitud", "Altura", "Estacion", "Tipo de Estación","Serial Estacion"]
        # data rows
        @registros.each do |registro|
          csv << [registro.valor_m, registro.unidad_medida_u, registro.tiempo, registro.estado_acron, registro.latitud, registro.longitud, registro.altura, registro.nombre, registro.tipo_estacion, registro.serial_e]
        end
      end

    render_text "Su reporte se produjo con exito."
      # send it to the browsah
      send_data csv_string,
              :type => 'text/csv; charset=iso-8859-1; header=present',
               :disposition => "attachment;
                filename=\""+VariableDimensionAr.find(var).nombre_hc+"_estado_"+edo+".csv\""
  end

  def prepvariableestadofechas
    @variables = VariableDimensionAr.find(:all, :order => 'nombre_hc ASC')
    @variables.each{|v|
      v.nombre_hc =  v.nombre_hc+' ('+v.id.to_s+')'
    }
    @estados = Estado.find(:all, :order => 'nombre ASC')
  end

  def variableestadofechas
    var = params[:variable]
    var = var[:id]
    edo = params[:estado]
    edo = edo[:acronimo]
    fecha = params[:date]
    ai = fecha[:anho_inicial].to_s
    mi = fecha[:mes_inicial].to_s
    di = fecha[:dia_inicial].to_s
    af = fecha[:anho_final].to_s
    mf = fecha[:mes_final].to_s
    df = fecha[:dia_final].to_s


    @registros = MedidavarhcFactAr.find_by_sql 'SELECT
           "medidavarhc_facts"."valor_m",
           "tiempo_dimension"."tiempo",
           "tiempo_dimension"."hora",
           "nivelagregacion_dimension"."nivel_agregacion",
           "variable_dimension"."nombre_hc",
           "unidad_dimension"."unidad_medida_u",
           "estaciones"."nombre",
           "estaciones"."latitud",
           "estaciones"."longitud",
           "estaciones"."altura",
	   "estaciones"."estado_acron",
    	   "estaciones"."serial_e",
     	   "estaciones"."tipo_estacion"
      FROM
           "medidavarhc_facts" INNER JOIN "tiempo_dimension" ON "medidavarhc_facts"."tiempo_id" = "tiempo_dimension"."id"
           INNER JOIN "variable_dimension" ON "medidavarhc_facts"."variable_id" = "variable_dimension"."id"
           INNER JOIN "estaciones" ON "medidavarhc_facts"."estacion_id" = "estaciones"."id"
           INNER JOIN "nivelagregacion_dimension" ON "medidavarhc_facts"."nivelagregacion_id" = "nivelagregacion_dimension"."id"
           INNER JOIN "unidad_dimension" ON "medidavarhc_facts"."unidad_id" = "unidad_dimension"."id"
      WHERE
                "medidavarhc_facts"."variable_id" = '+var+'
		AND "estaciones"."estado_acron" LIKE \''+edo+'\'
                AND "tiempo_dimension"."tiempo" >= date \''+ai+'-'+mi+'-'+di+'\'
                AND "tiempo_dimension"."tiempo" <= date \''+af+'-'+mf+'-'+df+'\'
    ORDER BY
        "estaciones"."nombre", "tiempo_dimension"."tiempo"'

      csv_string = FasterCSV.generate do |csv|
         #header row
        csv << ["Valor", "Unidad de medida", "Fecha", "Acrónimo del estado", "Latitud", "Longitud", "Altura","Estacion","Tipo de Estación","Serial Estacion"]
        # data rows
        @registros.each do |registro|
          csv << [registro.valor_m, registro.unidad_medida_u, registro.tiempo, registro.estado_acron ,registro.latitud, registro.longitud, registro.altura, registro.nombre, registro.tipo_estacion, registro.serial_e]
        end
      end

    render_text "Su reporte se produjo con exito."
      # send it to the browsah
      send_data csv_string,
              :type => 'text/csv; charset=iso-8859-1; header=present',
               :disposition => "attachment;
                filename=\""+VariableDimensionAr.find(var).nombre_hc+"_estado_"+edo+".csv\""

  end

  def listado
    
  end
end
