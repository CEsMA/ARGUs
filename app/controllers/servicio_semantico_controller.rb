require 'soap/wsdlDriver'

class ServicioSemanticoController < ApplicationController
   before_filter :permisosInv, :only => [ :composser, :publicar ]
  
    # Procedimiento que se encarga de invocar al Composser de servicios.
    def composser      
      if(params[:algoritmo].nil? || params[:inputs].nil? || params[:outputs].nil?)
        # El usuario debe proveer los datos necesarios para la invocacion del servicio de composicion.
      else
       XSD::Charset.encoding = 'UTF8' 
       wsdlfile = "http://201.208.20.64:8080/axis/services/Composser?wsdl"     # Ubicacion del WSDL
       driver = SOAP::WSDLDriverFactory.new(wsdlfile).create_rpc_driver   
       @result = driver.composse("SamUnfolding","http://localhost:8080/owls/instancias.owl#e","http://localhost:8080/owls/MyConceptsEE2.owl#T")
      end
    end

  # CAmbiar la ubicación del wsdl (wsdlfile) y el nombre de la función que invoca el driver.
  def publicar
    if (params[:archivoEntrada].nil?)
      # Renderizar la vista.
    else
      Post.cargar(params[:archivoEntrada],"owls/#{current_usuario.id}")
      lineas = IO.readlines("./tmp/owls/#{current_usuario.id}.txt")
      File.delete("./tmp/owls/#{current_usuario.id}.txt")
      
      XSD::Charset.encoding = 'UTF8' 
      wsdlfile = "http://201.208.20.64:8080/axis/services/Composser?wsdl"    
      driver = SOAP::WSDLDriverFactory.new(wsdlfile).create_rpc_driver   
      @result = driver.publish(lineas.join(""))

    end
  end

end


       