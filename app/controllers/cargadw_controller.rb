class CargadwController < ApplicationController
  before_filter :permisosProv, :only => [ :validar, :parser, :parserFacts, :CTLexec, :crearArchivoLogError, :cleanTemporales]
  
  def post
    # Funcion dummy para realizar el upload del archivo de carga (remitirse al model -> Post)
  end
  
  
  
  def validar()
    if params[:archivo_a_validar].nil?  || params[:archivo_a_validar]==""
        # No hacer nada.
    else
        usuarioAct = current_usuario.id
        Post.save(params[:archivo_a_validar],usuarioAct, true)
        archivoMediciones = "./tmp/cargaDw/mediciones#{usuarioAct}.txt"

        # Abrir el archivo y parsearlo para crear el archivo de la dimension de tiempo. 
        lineas = IO.readlines(archivoMediciones)
        if formatoValido(lineas)
           flash[:notice] = 'El archivo provisto es válido.'
           flash[:error_input] = nil
        else
           flash[:error_input] = 'Archivo inválido. Detalles en el log'
           @logError = "./tmp/cargaDw/logCargaError#{usuarioAct}.txt"
           flash[:notice] = nil
        end
        File.delete(archivoMediciones)
    end
  end
  
  
  
  
  
  def parser
    if $semaforoCarga.to_s.eql?("verde") 
          $semaforoCarga = "rojo"

          if params[:archivoEntrada].nil? 
             # Ir a la vista a pedirle que señale los parametros y el archivo con las mediciones que desea cargar.
          elsif params[:archivoEntrada]==""
            flash[:error_input] = "Debe proveer todos los datos solicitados."
          else
             begin
                usuarioAct = current_usuario.id
                Post.save(params[:archivoEntrada], usuarioAct, nil)
                archivoMediciones = "./tmp/cargaDw/mediciones.txt"

                # Abrir el archivo y parsearlo para crear el archivo de la dimension de tiempo. 
                lineas = IO.readlines(archivoMediciones)
                if formatoValido(lineas)
                    # Archivos para la dimension-tiempo.
                    tiempoFile = File.new("./tmp/cargaDw/tiempoFile.txt", "w+")
                    # Recargo las lineas del archivo de entrada
                    lineas = IO.readlines(archivoMediciones)

                    detallesM = ""
                    for medicion in lineas
                        # detallesM contiene los datos de una linea de medicion bajo la forma de un arreglo.
                        # [valor_m (0)| obs_m (1)| tiempo (fecha)  (2)| hora (3) | obs_tiempo (4) | unidad_t (5) | nivel_agregacion (6)]
                        detallesM = medicion.split('|')

                        # [dia | mes | año]
                        jerFecha = detallesM[2].split('/')
                        # [unidad_t | observacio_t | fecha (detallesM[2].strip.chomp)| dia | mes | año | hora]
             fechaNuevoFormato = "#{jerFecha[1].strip.chomp}/#{jerFecha[0].strip.chomp}/#{jerFecha[2].strip.chomp}"
                         datoTiempo = "#{detallesM[5].strip.chomp}|#{detallesM[4].strip.chomp}|#{fechaNuevoFormato}|#{jerFecha[1].strip.chomp}|#{jerFecha[0].strip.chomp}|#{jerFecha[2].strip.chomp}|#{detallesM[3].strip.chomp}"
                         tiempoFile.puts(datoTiempo) 
                    end

                   #Cerramos el archivo recien escrito.
                   tiempoFile.close()

                   if !CTLexec("tiempo_dimension") 
                     raise Exception
                   end

                   parserFacts(archivoMediciones, params[:estacion]["estacion"], params[:variable]["variable"], params[:unidad]["unidad"])
                   flash[:notice] = "Carga exitosa de su archivo al repositorio."
                   flash[:error_input] = nil
                else
                  flash[:notice] = nil
                  flash[:error_input] = 'Disculpe, el archivo provisto posee errores. Detalles disponibles en el log.'
                  @logError = "./tmp/cargaDw/logCargaError#{current_usuario.id}.txt"
                end              


              # Si alguna de las tareas del sistema falla (system "etl" o creacion de archivos)
              rescue
                 flash[:notice] = nil
                 flash[:error_input] = 'Disculpe, ocurrio un error durante la carga. Inténtelo más tarde.'
              ensure
              end
            end
            cleanTemporales
            $semaforoCarga = "verde"
    else
        flash[:notice] = "Disculpe, en estos momentos el módulo de carga esta en uso."
        redirect_to :action => "validar"
    end
    
  end
  

  
  #Parser de Hechos.
  def parserFacts(archivoEntrada, id_estacion, id_variable, id_unidad)         
    lineas = IO.readlines(archivoEntrada)
    
    # Creo el archivo
    factsFile = File.new("./tmp/cargaDw/factsFile.txt", "w+")

    # Analizo cada una de las mediciones y escribo lo que sera el archivo de entrada para el CTL
    for med in lineas
      medicion = med.split("|")
      #tiempo = medicion[2].to_s.strip.chomp
      nuevoT = medicion[2].to_s.strip.chomp.split("/")
      tiempo = "#{nuevoT[1]}/#{nuevoT[0]}/#{nuevoT[2]}"
      # puts tiempo 
      hora = medicion[3].to_s.strip.chomp
      observacion_t = medicion[4].to_s.strip.chomp
      unidad_t = medicion[5].to_s.strip.chomp
      nivelagregacion = medicion[6]
      
      idTiempo = getIdTiempo(unidad_t, observacion_t, tiempo, hora)
      id_nivelagregacion = getIdAgregacion(nivelagregacion)
      medicionFact="#{idTiempo.strip.chomp}|#{id_unidad.strip.chomp}|#{id_estacion.strip.chomp}|#{id_nivelagregacion.strip.chomp}|#{id_variable.strip.chomp}|#{medicion[0].strip.chomp}|#{medicion[1].strip.chomp}"
      factsFile.puts(medicionFact)
    end
    factsFile.close()
    
    if !CTLexec("medidavarhc_facts")
      raise Exception
    end
 end
  
  
  
  
  
  
  # Escribe un archivo log con todos los errores encontrados en al archivo de entrada. 
  # [valor_m (0)| obs_m (1)| tiempo (fecha)  (2)| hora (3) | obs_tiempo (4) | unidad_t (5) | nivel_agregacion (6)]
   def formatoValido(archivoArray)
    lineasError = []
      if archivoArray.length < 1
         lineasError.push("El archivo provisto no posee la información mínima requerida. Por favor revise el formato.")
     else
        # Validacion para las mediciones del archivo:
        #    a) Longitud = 7.      b) Presencia de valores obligatorios.
        #    c) Tipos numericos.   d) Formato de fecha y hora válidos.
        numLinea = 1
        agregaciones = getAgregaciones

        for medicion in archivoArray
            arrayMedicion = medicion.split("|")
            arrayMedicion.map {|x| x.strip.chomp}
            
            if arrayMedicion.length != 7
               lineasError.push("En la línea #{numLinea}, el número de datos es distinto a 7.")
            else              
              if arrayMedicion[0].nil? || arrayMedicion[2].nil? || arrayMedicion[3].nil? || arrayMedicion[5].nil? || arrayMedicion[6].nil? || arrayMedicion[0] == "" || arrayMedicion[2] == "" || arrayMedicion[3] == "" || arrayMedicion[5] == ""  || arrayMedicion[6] == ""
                 lineasError.push("En la línea #{numLinea}, únicamente las observaciones para 'medicion' y 'tiempo' son opcionales.")
              end

              unless isAFloat(arrayMedicion[0].strip.chomp)
                 lineasError.push("En la línea #{numLinea}, recuerde que: el valor de la medición debe ser de tipo numérico.")
              end
            
              # Validacion para la fecha de acuerdo al calendario gregoriano.
              begin
                fecha = arrayMedicion[2].split("/")
                valido = Date.valid_civil?(fecha[2].to_i,fecha[0].to_i,fecha[1].to_i)

                if valido.nil?
                  raise FechaInvalida
                end  
              rescue
                lineasError.push("En la línea #{numLinea}, el formato de la fecha es inválido.")
              end
            
          
              # Validacion para la hora.
              begin
                hora = arrayMedicion[3].split(":")
                if hora[0].to_i>23 || hora[0].to_i<1 || hora[1].to_i<1 || hora[1].to_i>59
                    lineasError.push("En la línea #{numLinea}, el formato de la hora es inválido.")
                end
              rescue
                  lineasError.push("En la línea #{numLinea}, el formato de la hora es inválido.")
              end            
              
              # Se chequea que la granularidad de las mediciones este dentro de las permitidas. Para agregar una nueva como
              # válida, simplemente escribela dentro del arreglo "granularidades".
              unless arrayMedicion[5].nil?
                granularidades = ["horario","diario","semanal","mensual","anual"]
                if !granularidades.include?(arrayMedicion[5].to_s.strip.chomp.downcase)
                 lineasError.push("En la línea #{numLinea}, la granularidad de la medición debe ser una de los siguientes: #{granularidades.join(", ")}.")
                end
              end
              
              # Se verifica que el nivel de agregacion provisto este registrado en la dimension del DW.
              unless arrayMedicion[6].nil?     
                agregaciones =  agregaciones.to_a.collect {|x| x.to_s.strip.chomp.downcase}
                
                if !agregaciones.include?(arrayMedicion[6].to_s.strip.chomp.downcase)
                 lineasError.push("En la línea #{numLinea}, el nivel de agregación provisto no está registrado en el sistema.")
                end
              end
         end
          numLinea = numLinea + 1
       end
      end         
         
      # Creación y escritura del archivo Log de errores.
      unless lineasError.empty? || lineasError.nil?
        crearArchivoLogError(lineasError)
        return false
      else
        return true
      end
  end
  
      
  
  
  
# Obtiene el id para un tiempo.
def getIdTiempo(unidad_t, observacion_t, tiempo, hora)
    sql = ActiveRecord::Base.connection()
    sql.begin_db_transaction
    value = sql.execute("select id from tiempo_dimension where unidad_t = '#{unidad_t.to_s.strip.chomp.slice(0,255)}' and observacion_t = '#{observacion_t.to_s.strip.chomp.slice(0,255)}' and tiempo = '#{tiempo.to_s.strip.chomp}' and hora = '#{hora.to_s.strip.chomp}';")
    sql.commit_db_transaction
    idTiempo = value[0][0]
end


  # Obtiene el id para un nivel de agregacion.
  def getIdAgregacion(nivelagregacion)
      sql = ActiveRecord::Base.connection()
      sql.begin_db_transaction
      value = sql.execute("select id from nivelagregacion_dimension where nivel_agregacion = '#{nivelagregacion.strip.chomp.slice(0,255)}';")
      sql.commit_db_transaction
      id_nivelagregacion = value[0][0]
  end
        
        
  # Obtiene todas las agregaciones.
  def getAgregaciones
      sql = ActiveRecord::Base.connection()
      sql.begin_db_transaction
      agregaciones = sql.execute("select nivel_agregacion from nivelagregacion_dimension;")
      sql.commit_db_transaction
      return agregaciones
  end
        
        
        
               
  # Crea el log de errores para el archivo que se intenta cargar en el repositorio.
  def crearArchivoLogError(errores)    
      flash[:notice] = nil
      begin
        nombrefile = "./tmp/cargaDw/logCargaError#{current_usuario.id}.txt"
        f = File.open("#{nombrefile}", "w")
        for error in errores
          f.puts(error)     
        end 
        f.close()
      rescue
      end
  end       
       
  
    
  # Permite ver en una nueva pagina los errores.
  def verLogErrores
    flash[:notice] = nil
    flash[:error_input] = nil
    @errores = []
    nombrefile = "./tmp/cargaDw/logCargaError#{current_usuario.id}.txt"
    f = File.open("#{nombrefile}").each { |line| @errores << line}
    f.close 
    if @errores.size > 15
      @errores = @errores.slice(0, 15)
      @errores << "La lista de errores fue limitada a 15 entradas. Para ver el listado completo descargue el log."
    end
  end
  
  
  
  
  def verModeloFormato
    flash[:notice] = nil
    flash[:error_input] = nil
    # Es una accion dummy, que permite que el usuario observe en la vista los detalles del formato
    # que deben tener los archivos que se intentan registrar en el repositorio.
  end
  



def CTLexec(nombreCTL)
  begin
      system "etl ./tmp/cargaDw/ctls/#{nombreCTL}.ctl"       
      return true
  rescue
      flash[:error_input] =  "Se produjo un error durante la ejecucion del 'ETL'."
      return false
  end
end



# Se encarga de eliminar todos los archivos temporales que fueron creados para el parsing.
  def cleanTemporales
      begin         
        #  File.delete("./tmp/cargaDw/tiempoFile.txt")
      rescue
      end
      
      begin 
           File.delete("./tmp/cargaDw/factsFile.txt") 
      rescue
      end
      
      begin       
        File.delete("./tmp/cargaDw/mediciones.txt")
      rescue
      end
      
      begin       
        File.delete("./tmp/cargaDw/ctls/factsFileProcesada.txt")
      rescue
      end
      
      begin       
        File.delete("./tmp/cargaDw/ctls/tiempoFileProcesada.txt")
      rescue
      end
     end
  end
