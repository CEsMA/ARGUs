class Notifier < ActionMailer::Base
  
helper :application

  # Establece un canal de comunicacion entre el webmaster y los usuarios del sistema.
  def contactenos (asunto,cuerpo,autor)
    recipients "hidroclima.venezuela@gmail.com"
    from  autor
    subject asunto
    body cuerpo
  end
  
  
  # Realiza el envio de la contrasena temporal al usuario que asi lo solicite.
   def olvido_contrasena(email, clave)
    recipients email
    from  "hidroclima.venezuela@gmail.com"
    subject "Instrucciones para renovación de contraseña" 
    if clave.nil? 
      body "Se produjo un error durante el procesamiento de su solicitud. Por favor, intente más tarde."
    else
       cuerpo = "Por motivos de seguridad, el sistema no le permite recuperar su antigua clave sino generar una nueva. \nDiríjase al sistema hidroclima, bajo Opciones de clave e ingrese su clave temporal. \n\n\nSu clave temporal es: \n\t\t#{clave}"  
       body cuerpo
     end
   end
end

 
