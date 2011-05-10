require 'soap/wsdlDriver'

class ConsultasfisicasController < ApplicationController
  before_filter :permisosProv, :only => [ :injectionQuery ]
  
  # Precarga y lista el numero de repeticiones por tag que se poseen para las consultas.
  def listarOpc
     @tags = (Consultatag.find_by_sql("SELECT tag as nombre, count(*) as ocur FROM consultatags GROUP BY tag ORDER BY tag ;"))
  end

  def listar
        ids = Consultatag.find_by_sql("SELECT distinct c.texto_pregunta, c.id_pred, c.sql_query, ctag.consulta_id FROM consultas c, consultatags ctag WHERE ctag.consulta_id = c.id;")
        unless ids.nil? || ids == []
          @consultasShow = []
          for id in ids
            @consultasShow << id.consulta_id
            @consultasShow << id.texto_pregunta
            @consultasShow << id.id_pred
            @consultasShow << id.sql_query
            @tag = params[:nombretag]
          end
        end
  end
  
  
  # Dado el nombre de un tag, se precargan las consultas asociadas.
  def consultar
    if params[:nombretag].nil?
        # Si intentan acceder a traves de la ruta del navegador, son redirigidos al listado de palabras claves.
        redirect_to :action => "listarOpc"
    else 
        ids = Consultatag.find_by_sql("SELECT c.texto_pregunta, c.id_pred, c.sql_query, ctag.consulta_id FROM consultas c, consultatags ctag WHERE ctag.tag = '#{params[:nombretag]}' AND ctag.consulta_id = c.id;")
        unless ids.nil? || ids == []
          @consultasShow = []
          for id in ids
            @consultasShow << id.consulta_id
            @consultasShow << id.texto_pregunta
            @consultasShow << id.id_pred
            @consultasShow << id.sql_query
            @tag = params[:nombretag]
          end
        else
          #No hay resultados para mostrar
        end
    end
  end  
  
 
  
  
  def injectionQueryResult 
    @resultado = []
    if logged_in? 
        nombrefile = "#{current_usuario.nombre}#{current_usuario.id}.txt"
    else
        nombrefile = "#{'guest'}#{1232908}.txt"
    end 
    f = File.open("./tmp/descargas/#{nombrefile}").each { |line| @resultado << line}
    f.close 
  end
  
  
  
  # Maneja las consultas escritas en SQL puro.
  def injectionQuery
    permisosProv
    @texto = ""
    # Valido que sea un administrador o un proveedor
    if logged_in?      
          if params[:query].nil?
          else 
             # puts "ahi vamos"
             if chequeoQuery(params[:query])
               
                 @resultado = nil
                 begin
                  sql = ActiveRecord::Base.connection()
                  sql.begin_db_transaction
                  @texto = params[:query].to_s
                 
                  @resultado = sql.execute(params[:query].to_s.strip.chomp)
                  crearArchivo(@resultado, @texto)
                 rescue
                   eliminarArchivo
                   flash[:error_input] = "Error: Revise la sintaxis de su consulta."
                   @resultado = nil
                 ensure
                   sql.commit_db_transaction
                 end
              else
                  eliminarArchivo
                  flash[:error_input] = "Error: No posee privilegios para realizar dicha consulta."
                  @resultado = nil
              end        
          end
         # puts @resultado
    else
      flash[:error_input] = "Error: Usted no está loggeado en el sistema."
      redirect_to :action => "welcome", :controller => "usuario"
    end
  end
 
  
  
  
  def crearArchivo(result, texto)
    begin
      if logged_in?
	name_temp = current_usuario.nombre
	id_temp = current_usuario.id
      else
	name_temp = 'guest'
	id_temp = 1232908
      end
      nombrefile = "#{name_temp}#{id_temp}.txt" 
      f = File.open("./tmp/descargas/#{nombrefile}", "w")
      f.puts(texto) 
      for linea in result
        f.puts(linea.join(" | "))     
      end    
    rescue
    ensure
      f.close()
    end
  end
  
  
  
  
  def eliminarArchivo
    begin
      nombrefile = "#{current_usuario.nombre}#{current_usuario.id}.txt"
      File.delete("./tmp/descargas/#{nombrefile}", "w")      
    rescue
    end
  end

    
 # Listado de Consultas.
   def consultarRepositorio
     @id =  params[:id]
     @title =  params[:title]
     @id_pred = params[:id_pred]
     
     # Si la consulta NO es pre-determinada
     if params[:id_pred].to_i == 0
       @sql_query = params[:sql_query]
       @view = ''
       cond = extraer_condiciones(params[:sql_query],'{','}')
       contador = 1
       # por cada condición se genera una opción para la forma de la consulta
       for c in cond
         @view << generar_campo_vista(c,contador)
         contador = contador + 1
       end
     # Si la consulta es predeterminada, se cargan las variables necesarias.
     else
       sql = ActiveRecord::Base.connection()
       sql.begin_db_transaction
       @fenomenos = sql.execute("select nombre_f from fenomeno_meteorologicos")
       @variables = sql.execute("select nombre_hc from variable_hidroclimaticas") 
       @TO = sql.execute("select nombre_generico_TO from tipo_objetos")
       @estaciones = sql.execute("select nombre from estaciones")
       if (params[:id_pred].to_i == 6)
         info = []
         XSD::Charset.encoding = 'UTF8' 
         wsdlfile = "http://159.90.14.209:3000/georeference/wsdl"     
         driver = SOAP::WSDLDriverFactory.new(wsdlfile).create_rpc_driver   
         @result = driver.georeference(info)
         @variables = sql.execute("select nombre_hc from variable_hidroclimaticas WHERE acumulada_hc = 'N'")
       end
       sql.commit_db_transaction
     end     
   end
  
  # En caso de que la expresion este mal formada retorna un string vacio
  # Dado un texto, un delimitador inicial y uno final retorna un array cuyos elementos son el contenido que se encuentra entre los delimitadores
  def extraer_condiciones(texto, delim_inicial, delim_final)
    contenido = []
    begin
      query = texto.to_s
      while query != "" && query != nil && query.to_s.index(delim_inicial) != nil
        inicio = query.to_s.index(delim_inicial)
        final = query.to_s.index(delim_final)
        contenido << query.slice(inicio+1,final - inicio - 1).strip.chomp
        longitud = query.length
        query = query.slice(final+1,longitud)    
      end
    rescue
      contenido = ""
    end
      return contenido
  end
  
  
  # Dependiendo del tipo de condición se genera un campo de la forma para la vista.
  def generar_campo_vista(condicion,num_param)
    # FORMATO 
    ### {tabla.columna = [(texto || fecha || select):(nombre del campo)]}  --- Dependiendo del tipo de la columna, se colocarán los corchetes dentro de comillas simples
    ### {tabla.columna like [(' Nombre del campo ')]} 
    if condicion.split("like")[1].nil?
      tipo = extraer_condiciones(condicion,'[',']')[0].split(':')
      info = "#{condicion.split('[')[0]} #{condicion.split(':')[1].gsub("]","")}" 
      label = "<label for=\"#{tipo[1]}_#{num_param}\"> #{tipo[1]}: (#{info}) </label> <br/> "
      if tipo[0].eql?("texto")
        campo = "<p> #{label} <input class=\"textfield\" id=\"#{num_param}\" name=\"#{num_param}\" size=\"20\" type=\"text\" /> </p>"
      elsif tipo[0].eql?("fecha")
        campo = "<p> #{label} <input type=\"text\" name=\"#{num_param}\" value=\"\" class=\"textfield text-input\" id =\"#{num_param}\"/>
                 <img src=\"/images/calendar.png\" id=\"#{num_param}_trigger\" style=\"cursor: pointer;\" title=\"Date selector\" />
                 <script type=\"text/javascript\">
                 Calendar.setup({
                     button : \"#{num_param}_trigger\",
                     ifFormat : \"%m/%d/%Y\",
                     inputField : \"#{num_param}\",
                     singleClick    :    true
                 });
                 </script> </p>"
      elsif tipo[0].eql?("select")
        options = ''
        sql = ActiveRecord::Base.connection()
        sql.begin_db_transaction
        opciones = sql.execute("select distinct #{condicion.split(".")[1].split(" ")[0]} from #{condicion.split(".")[0]}")
        for opcion in opciones
          options << "<option value=\"#{opcion[0]}\">#{opcion[0]}</option>"
        end
        sql.commit_db_transaction
        campo = "<p> #{label} <select id=\"#{num_param}\" name=\"#{num_param}\"> #{options} </select> </p>"
      end
    else
      tipo = condicion.split("'")
      label = "<label for=\"#{tipo[1]}_#{num_param}\"> #{tipo[1]}: (#{condicion.gsub('[','').gsub(']','')}) </label> <br/> "
      campo = "<p> #{label} <input class=\"textfield\" id=\"#{num_param}\" name=\"#{num_param}\" size=\"20\" type=\"text\" /> </p>"
    end
    return campo
  end
 
  
  
  
  # Permite recuperar
  def encabezados_columnas(query)
    begin
        elementos = query.to_s.downcase.split("from")
        if elementos.length > 1 && !elementos.nil?
          select_clausula = elementos[0].to_s.slice(7,elementos[0].length).split(",").map{|x| x.chomp.strip}
          if !select_clausula[0].eql?("*")
              return select_clausula.join("    |    ")
          else
              tablas = elementos[1].split("where")[0].split(",").map{|x| x.chomp.strip}

              sql = ActiveRecord::Base.connection()
              sql.begin_db_transaction  
              columnas = []
              for tabla in tablas
                 columnas << sql.execute("select column_name from information_schema.columns where table_schema='public' and table_name = '#{tabla.to_s}'").to_a
              end
              sql.commit_db_transaction
              return columnas.flatten.join("    |    ")
            end
          end
    rescue
        return "Disculpe, no fue posible recuperar los nombres de las columnas para su salida."
    end
  end

  
  
  
  # Funcion generica para mostrar resultados.
  def listarResultados
      begin 
      sql = ActiveRecord::Base.connection()
      sql.begin_db_transaction
      @resultados = []
      # Si la consulta no es predeterminada, coloco mi respuesta genérica.
      if (params[:id_pred].to_i == 0)
        begin
          @title = params[:title]
          condiciones_query = ''
          contador = 1
          con_crudas = extraer_condiciones(params[:sql_query],"{","}")
          for con in con_crudas
            if !params[:"#{contador}"].nil? && !params[:"#{contador}"].to_s.eql?("")
              unless con.split("like")[1].nil?
                # puts con
                condiciones_query << "#{con.split("[")[0]}('#{params[:"#{contador}"]}')|"
              else
                comillita = ''
                unless con.split("]")[1].nil?
                comillita = con.split("]")[1]
                end
                condiciones_query << "#{con.split("[")[0]}#{params[:"#{contador}"]}#{comillita}|"
              end
              contador = contador + 1
            else
              condiciones_query << "#{con.split(" ")[0]} like ('%') |"
            end
          end
          
          query = params[:sql_query]
          
          count = 0
          condiciones_query_modif = condiciones_query.split("|")
          for c in con_crudas
            query = query.sub("{#{c}}",condiciones_query_modif[count])
            count = count + 1
          end
          
          @resultados = sql.execute(query)
          unless @resultados.nil?
            cabecera = @title.clone << "<h6>#{encabezados_columnas(query).to_s}</h6>"
            crearArchivo(@resultados,cabecera)
          end
        rescue
          flash[:error_input] = "Error en los datos ingresados. Por favor revise los datos provistos e intente de nuevo" 
        ensure
          redirect_to :action => "consultarRepositorio", :id => params[:id], :title => @title, :sql_query => params[:sql_query],  :id_pred => params[:id_pred], :resultados => @resultados
        end
      elsif (params[:id_pred].to_i == 1)
        @title = params[:title]
        @resultados << "<b>Variable hidroclimática que se ven afectadas por el fenómeno:</b>"
        result = sql.execute("select nombre_hc from variable_hidroclimaticas vh, afecta_fvhcs a, fenomeno_meteorologicos fm where fm.nombre_f = '#{params[:nombre]["nombre"]}' and fm.id = a.id_fenomeno_fvhc and a.id_varhidroclim_fvhc = vh.id")
        unless result[0].nil?
          @resultados << result
        else
          @resultados << "No existe ningún objeto de estudio registrado que afecte el fenómeno"
        end
      elsif (params[:id_pred].to_i == 2)
        @title = params[:title]
        @resultados << "<b>Tipos de objeto en los que el fenómeno incidió:</b>"
        result = sql.execute("select nombre_generico_to from tipo_objetos tog, incide_tofs i, fenomeno_meteorologicos fm where fm.nombre_f = '#{params[:nombre]["nombre"]}' and fm.id = i.id_fenomeno_tof and i.id_tipo_objeto_tof = tog.id")
        unless result[0].nil?
          @resultados << result
        else
          @resultados << "No existe ningún objeto de estudio registrado que afecte el fenómeno"
        end
      elsif (params[:id_pred].to_i == 3)
        # puts params[:nombre_var]["nombre_var"]
        @title = params[:title]
        @resultados << "<b>Variable acumulada:</b>"
        @resultados << sql.execute("select acumulada_hc from variable_hidroclimaticas hc where hc.nombre_hc = '#{params[:nombre_var]["nombre_var"]}' ")
        @resultados << "<b>Tipo de instrumentos que la miden:</b>"
        result = sql.execute("select nombre_ti from variable_hidroclimaticas hc, tipo_instrumentos t, puede_medir_vtins pm where hc.nombre_hc = '#{params[:nombre_var]["nombre_var"]}' and pm.id_varhidroclim_vtins = hc.nombre_hc and pm.id_tipo_ins_vtins = t.nombre_ti ")
        unless result[0].nil?
          ahiva = ""
          for r in result 
            ahiva << r[0] << " ; "
          end
          @resultados << ahiva
        else
          @resultados << "No se ha registrado ningún instrumento que la mida"
        end
        @resultados << "<b>Medio en que se guardan:</b>"
        result = sql.execute("select nombre_med from variable_hidroclimaticas hc, tipo_instrumentos t, puede_medir_vtins pm, medios m where hc.nombre_hc = '#{params[:nombre_var]["nombre_var"]}' and pm.id_varhidroclim_vtins = hc.id and pm.id_tipo_ins_vtins = t.id and t.id_medio = m.id")
        unless result[0].nil?
          ahiva = ""
          for r in result 
            ahiva << r[0] << " ; "
          end
          @resultados << ahiva
        else
          @resultados << "No se ha registrado ningún medio en que se guarde"
        end
        @resultados << "<b>Tipo de objetos que inciden en la variable:</b>"
        result = sql.execute("select nombre_generico_TO from variable_hidroclimaticas hc, tipo_objetos tog, se_asocia_vhctos sa where hc.nombre_hc = '#{params[:nombre_var]["nombre_var"]}' and hc.id = sa.id_varhidroclim_vhcto and sa.id_tipo_objeto_vhcto = tog.id ")
        unless result[0].nil?
          ahiva = ""
          for r in result 
            ahiva << r[0] << " ; "
          end
          @resultados << ahiva
        else
          @resultados << "No se ha registrado ningún instrumento que la mida"
        end
        @resultados << "<b>Unidad en que se mide:</b>"
        result = sql.execute("select nombre_unid from variable_hidroclimaticas hc, se_mide_vunis sm, unidads u where hc.nombre_hc = '#{params[:nombre_var]["nombre_var"]}' and sm.id_varhidroclim_vuni = hc.id and u.id = sm.id_unid_vuni ")
        unless result[0].nil?
          ahiva = ""
          for r in result 
            ahiva << r[0] << " ; "
          end
          @resultados << ahiva
        else
          @resultados << "No se ha registrado ninguna unidad para esta variable"
        end
      elsif (params[:id_pred].to_i == 4)
        @title = params[:title]
        @resultados << "<b>Nombre de la variable socioeconomicas relacionadas:</b>"
        result = sql.execute("select nombre_vse from variable_socioeconomicas v, tipo_objetos tog, se_relaciona_vsetos sr where tog.nombre_generico_to = '#{params[:nombre_obj]["nombre_obj"]}' and tog.id = sr.id_tipo_objeto_vseto and id_varsocioe_vseto = v.id ")
        unless result[0].nil?
          ahiva = ""
          for r in result 
            ahiva << r[0] << " ; "
          end
          @resultados << ahiva
        else
          @resultados << "No se ha registrado ninguna variable económica relacionada a este objeto"
        end
        @resultados << "<b>Alcance geográfico:</b>"
        result = sql.execute("select alcance_geo_TO from tipo_objetos t where t.nombre_generico_TO = '#{params[:nombre_obj]["nombre_obj"]}' ")
        unless result[0].nil?
          ahiva = ""
          for r in result 
            ahiva << r[0] << " ; "
          end
          @resultados << ahiva
        else
          @resultados << "No se ha registrado el alcance geográfico de esta variable"
        end
        @resultados << "<b>Variable hidroclimática que incide en el objeto:</b>"
        result = sql.execute("select nombre_hc from variable_hidroclimaticas hc, tipo_objetos tog, se_asocia_vhctos sa where tog.nombre_generico_TO = '#{params[:nombre_obj]["nombre_obj"]}' and sa.id_tipo_objeto_vhcto = tog.id and hc.id = sa.id_varhidroclim_vhcto")
        unless result[0].nil?
          ahiva = ""
          for r in result 
            ahiva << r[0] << " ; "
          end
          @resultados << ahiva
        else
          @resultados << "No se ha registrado el variable hidroclimática que incida en este objeto"
        end 
        @resultados << "<b>Fenómenos meteorológicos que inciden en el objeto:</b>"
        result = sql.execute("select nombre_F from fenomeno_meteorologicos f, tipo_objetos tog, incide_tofs i where tog.nombre_generico_TO = '#{params[:nombre_obj]["nombre_obj"]}' and i.id_tipo_objeto_tof = tog.id and f.id = i.id_fenomeno_tof ")
        unless result[0].nil?
          ahiva = ""
          for r in result 
            ahiva << r[0] << " ; "
          end
          @resultados << ahiva
        else
          @resultados << "No se ha registrado el variable hidroclimática que incida en este objeto"
        end 
      # Consulta Nro. 5
      elsif (params[:id_pred].to_i == 5)
        @title = params[:title]
        clausula_from = ""
        clausula_where = ""
        contador = 0
        ## puts params[:codigoEst]
        ## puts params[:opcion]
        if params[:opcion].to_i == 1
          results = sql.execute("select nombre, latitud, longitud from estaciones where codigo_omm = '#{params[:codigoEst]}'")
          # puts results.to_s
          unless results[0].nil?
            @resultados << "nombre: #{results[0][0]} <br/> latitud: #{results[0][1]} <br/> longitud: #{results[0][2]} "
          else
            @resultados << "Ninguna estación está registrada con el código #{params[:codigoEst]}"
          end
        end
        if params[:opcion].to_i == 2
          # chequeo que me hayan pasado las alturas 
          unless params[:altura_min].eql?("") && params[:altura_max].eql?("")
            clausula_where << "where #{params[:altura_min]} < e.altura AND e.altura < #{params[:altura_max]}"
            contador = contador + 1
          end
          # chequeo que me hayan pasado las fechas
          unless params[:rangoFecha][:fecha_inicio].eql?("") && params[:rangoFecha][:fecha_fin].eql?("")
            clausula_from << ", periodo_operacions po"
            if contador == 0
              clausula_where << "where po.estacion_id_po = e.id AND '#{params[:rangoFecha]["fecha_inicio"]}' < po.fecha_inicio_po OR po.fecha_fin_po > '#{params[:rangoFecha][:fecha_fin]}'"
            else
              clausula_where << " AND po.estacion_id_po = e.id AND '#{params[:rangoFecha]["fecha_inicio"]}' < po.fecha_inicio_po OR po.fecha_fin_po > '#{params[:rangoFecha][:fecha_fin]}'"
            end
            contador = contador + 1          
          end
          # chequeo que me hayan pasado los estados
          unless params[:estados].eql?("")
            estados_where = ""
            estados = params[:estados].split(",")
            count = 0
            for es in estados
              if count == 0 
                estados_where << "AND est.nombre = '#{es}'"
              else
                estados_where << " OR est.nombre = '#{es}'"
              end
              count = count + 1
            end
            clausula_from << ", estados est"
            if contador == 0
              clausula_where << "where est.id = e.estado_id #{estados_where}"
            else
              clausula_where << " AND est.id = e.estado_id #{estados_where}"
            end
            contador = contador + 1
          end
         # chequeo que me pasen las variables
         unless params[:variables].eql?("")
           variables_where = ""
            variables = params[:variables].split(" ")
            count = 0
            for var in variables
              if count == 0 
                variables_where << "AND so.nombre_hc = '#{var}'"
              else
                variables_where << " OR so.nombre_hc = '#{var}'"
              end
              count = count + 1
            end
            clausula_from << ", se_observas so"
            if contador == 0
              clausula_where << "where e.id = so.id_estacion #{variables_where}"
            else
              clausula_where << " AND e.id = so.id_estacion #{variables_where}"
            end
            contador = contador + 1
         end
        res = sql.execute("select distinct e.nombre, latitud, longitud, altura from estaciones e #{clausula_from} #{clausula_where} ")
        @resultados << ["<b> Estaciones encontradas bajo su parámetro de búsqueda </b>"]
        estacion = "<div class='centrado'> <table> <th>Nombre</th> <th>Latitud</th> <th>Longitud</th> <th>Altura</th>"
        for r in res
         estacion << "<tr>"
          for a in r
            estacion << "<td> #{a} </td>"
          end
         estacion << "</tr>"
        end
        estacion << "</table> </div>"
        
        @resultados << estacion
        
        if res[0].nil?
          @resultados << "NO SE ENCONTRARON ESTACIONES PARA SU BUSQUEDA"
        end
      end
     # Consulta Nro. 6
   elsif (params[:id_pred].to_i == 6)
            x1ok, x2ok, y1ok,y2ok = 0,0,0,0
            @resultados << "<h4>A continuación los estad'isticos para las mediciones del <b>#{params[:rangoFecha][:fecha_inicio]} al #{params[:rangoFecha][:fecha_fin]}</b> para la variable <b>#{params[:nombre_var]["nombre_var"]}</b> en las estaciones seleccionadas</h4>"
            @estacione = Estacione.find(:all)
            if (params[:tipoOperacion].to_s.eql?("ventana") && !(params[:longA].nil?) && !(params[:longB].nil?) && !(params[:latA].nil?) && !(params[:latB].nil?))
               # cambio los puntos para adaptarse al formato
             if (params[:longA].to_f > params[:longB].to_f)
               x1ok = params[:longB].to_f
               x2ok = params[:longA].to_f
             else
               x1ok = params[:longA].to_f
               x2ok = params[:longB].to_f
             end
             if (params[:latA].to_f < params[:latB].to_f)
               y1ok = params[:latB].to_f
               y2ok = params[:latA].to_f
             else
               y1ok = params[:latA].to_f
               y2ok = params[:latB].to_f
             end
           elsif (params[:tipoOperacion].to_s.eql?("estacion"))
              @estacione = Estacione.find(:all, :conditions => {:nombre => params[:nombre]["nombre"]}) 
              estacion = sql.execute("select latitud,longitud from estaciones where nombre = '#{params[:nombre]["nombre"]}'")
              x1ok, x2ok = estacion[0][1].to_f,estacion[0][1].to_f
              y1ok, y2ok = estacion[0][0].to_f,estacion[0][0].to_f
              # puts x1ok
              # puts x2ok
           else
            @resultados = "ERROR DE PARAMETROS: Asegúrese de ingresar una ventana geográfica"
           end
             # se busca en todas las estaciones
             respuesta = "<div class=\"centrado\">"
             no_info = ""
             paroimpar = 0
             estaciones = 0
               for p in @estacione
                 puts paroimpar
                 paroimpar = paroimpar + 1
                 # si su ubicación está dentro de la ventana geográfica, entonces se añade a la lista de puntos
                 if ( inside(x1ok,y1ok,x2ok,y2ok,p.longitud,p.latitud) == 0 )
                 # Sección para meter en "información" lo requerido por el usuario
                   estaciones = estaciones + 1
                    where_clause = ""
                    ## Busco en los metadatos si tengo la información dada por los parámetros.
                    res = sql.execute("select row_id_medida from metadatos_rowids id, metadatos_desc meta, estacion_dimension est where id.id_descriptor = meta.id_metadesc AND est.id = meta.codigo_estacion_muni AND est.nombre_est = '#{p.nombre}' AND meta.variable = '#{params[:nombre_var]["nombre_var"]}' AND ( ('#{params[:rangoFecha][:fecha_inicio]}' <= meta.fecha_inicio AND meta.fecha_inicio <= '#{params[:rangoFecha][:fecha_fin]}') OR ( '#{params[:rangoFecha][:fecha_inicio]}' <= meta.fecha_fin AND meta.fecha_fin <= '#{params[:rangoFecha][:fecha_fin]}') OR ('#{params[:rangoFecha][:fecha_inicio]}' <= meta.fecha_inicio AND meta.fecha_fin <= '#{params[:rangoFecha][:fecha_fin]}') OR ('#{params[:rangoFecha][:fecha_inicio]}' >= meta.fecha_inicio AND meta.fecha_fin >= '#{params[:rangoFecha][:fecha_fin]}') )")
                    # Si los metadatos no tienen respuesta, sorry baby!
                    if res[0].nil?
                      no_info << "<b>#{p.nombre}</b>" 
                    # Si tienen respuesta, tendré en "res" los rowids de las mediciones que me sirven :)
                    else
                      if paroimpar.modulo(2) == 1
                        respuesta << "<h3> Para la estacion <b>#{p.nombre}</b> se obtuvieron los siguientes estadisticos: </h3><ul> "
                      else
                        respuesta << "<h3> Para la estacion <b>#{p.nombre}</b> se obtuvieron los siguientes estadisticos: </h3> "
                      end
                      
                    
                      # PARA EL MINIMO
                        # Hago la clausula WHERE para el SQL
                        n = 0
                        for i in res
                        # puts i
                          if n == 0
                            where_clause << "med.id = #{i.to_s}"
                          else
                            where_clause << " OR med.id = #{i.to_s}"
                          end
                          n = n + 1
                        end
                        # Ejecuto el query
                        min = sql.execute("select valor_m, t.tiempo, t.unidad_t from tiempo_dimension t, medidavarhc_facts med where (#{where_clause}) AND med.tiempo_id = t.id AND '#{params[:rangoFecha][:fecha_inicio]}' <= t.tiempo AND t.tiempo <= '#{params[:rangoFecha][:fecha_fin]}' AND valor_m = (select min(valor_m) from tiempo_dimension t, medidavarhc_facts med where (#{where_clause}) AND med.tiempo_id = t.id AND '#{params[:rangoFecha][:fecha_inicio]}' <= t.tiempo AND t.tiempo <= '#{params[:rangoFecha][:fecha_fin]}')")                      
                        unless min[0].nil? 
                          respuesta << "<li>#{min[0][0].to_f} "
                          respuesta << "el d'ia <b>#{min[0][1].to_s}</b> tomado en una medición #{min[0][2].to_s} </li>"
                        else
                          respuesta << "<td>No </td>"
                        end
                      

                      # PARA EL MAXIMO
                      
                        # Ejecuto el query
                        max = sql.execute("select valor_m, t.tiempo, unidad_t from tiempo_dimension t, medidavarhc_facts med where (#{where_clause}) AND med.tiempo_id = t.id AND '#{params[:rangoFecha][:fecha_inicio]}' <= t.tiempo AND t.tiempo <= '#{params[:rangoFecha][:fecha_fin]}' AND valor_m = (select max(valor_m) from tiempo_dimension t, medidavarhc_facts med where (#{where_clause}) AND med.tiempo_id = t.id AND '#{params[:rangoFecha][:fecha_inicio]}' <= t.tiempo AND t.tiempo <= '#{params[:rangoFecha][:fecha_fin]}')")
                        unless max[0].nil? 
                          respuesta << "<li>#{max[0][0].to_f} "
                          respuesta << "el d'ia <b>#{max[0][1].to_s}</b>, tomado en una medición #{max[0][2].to_s} </li>"
                        else
                          respuesta << "<td>No </td>"
                        end



                      # PARA EL PROMEDIO
  
                        medicion = sql.execute("select avg(valor_m) from tiempo_dimension t, medidavarhc_facts med where (#{where_clause}) AND med.tiempo_id = t.id AND '#{params[:rangoFecha][:fecha_inicio]}' <= t.tiempo AND t.tiempo <= '#{params[:rangoFecha][:fecha_fin]}'")
                        unless medicion[0][0].nil? 
                          respuesta << "<li>El promedio de las mediciones para este periodo es: #{sprintf('%.4f',medicion[0][0])}</li>"
                        else
                          respuesta << "<td>No </td>"
                        end
  
                      
                    end
                 end
               end
             respuesta <<  " </div>"
             @resultados << "<br/> #{respuesta} <br/>"
             @resultados << "<p> &nbsp;&nbsp;&nbsp;Las siguientes estaciones no presentan registros para los parámetros ingresados: #{no_info} </p>"
             # else de por si viene vacio las estaciones
             if estaciones == 0
               @resultados = "No existen estaciones dentro del rango seleccionado."
             end
     else
        @title = ""
     end 
    end
   rescue
   ensure
     sql.commit_db_transaction
   end 
    
end
