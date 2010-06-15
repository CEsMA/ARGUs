class Post < ActiveRecord::Base
  # Se encarga de crear el archivo en el servidor, que contiene los datos que desea cargarse al repositorio.
  def self.save(archivoEntrada, current_usuario, solo_validacion)
    begin   
        if !solo_validacion
          f_Uploaded = File.new("./tmp/cargaDw/mediciones.txt", "wb")
        else 
          f_Uploaded = File.new("./tmp/cargaDw/mediciones#{current_usuario}.txt", "wb")
        end
        f_Uploaded.write archivoEntrada.read
        f_Uploaded.close
    rescue
        @errorFile = "Formato o nombre del archivo inválido."
    end  
  end
  
  
  def self.cargar(archivoEntrada, nombre_temp)
    begin    
        f_Uploaded = File.new("./tmp/#{nombre_temp}.txt", "wb")
        f_Uploaded.write archivoEntrada.read
        f_Uploaded.close
    rescue
        @errorFile = "Formato o nombre del archivo inválido."
    end  
  end

end
