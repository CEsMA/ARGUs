class ApplicationController < ActionController::Base
  
  if $semaforoCarga.nil?
     $semaforoCarga = "verde"
  end
  
  
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  
  # If you want "remember me" functionality, add this before_filter to Application Controller
  before_filter :login_from_cookie
  
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_hidro_session_id'
 

  
  # Chequea si el usuario esta logueado y si es administrador. 
   def permisosAdmin
    if logged_in?
       unless current_usuario.tipo.eql?("Administrador")
          flash[:error_input] = 'Usted no tiene permiso para acceder a ésta página.'
          redirect_to :controller => 'usuario', :action=>'welcome'
          return false
       end
    else
       flash[:error_input] = 'Usted no está logueado.'
       redirect_to :controller => 'usuario', :action=>'welcome' 
       return false
       
    end
  end
  
   def permisosProv
    if logged_in?
       unless (current_usuario.tipo.eql?("Proveedor") || current_usuario.tipo.eql?("Administrador") )
          flash[:error_input] = 'Usted no tiene permiso para acceder a ésta página.'
          redirect_to :controller => 'usuario', :action=>'welcome' 
       end
    else
       flash[:error_input] = 'Usted no está logueado.'
       redirect_to :controller => 'usuario', :action=>'welcome'
    end
  end
  
   def permisosInv
    if logged_in?
       unless (current_usuario.tipo.eql?("Investigador") || current_usuario.tipo.eql?("Proveedor") || current_usuario.tipo.eql?("Administrador"))
          flash[:error_input] = 'Usted no tiene permiso para acceder a ésta página.'
          redirect_to :controller => 'usuario', :action=>'welcome'
       end
    else
       flash[:error_input] = 'Usted no está logueado.'
       redirect_to :controller => 'usuario', :action=>'welcome'
    end
  end
  
  def whatami
    if logged_in?
          if current_usuario.tipo.eql?("Administrador")
            return 0
          elsif current_usuario.tipo.eql?("Proveedor")
            return 1
          elsif current_usuario.tipo.eql?("Investigador")
            return 2
          else 
            redirect_to :controller => "account", :action => "logout"
            return 3
          end
    else
      redirect_to :action => "welcome", :controller => "usuario"
    end
  end
  

def whatami_vinculo
    if logged_in?
          if current_usuario.tipo.eql?("Administrador")
            return 0
          elsif current_usuario.tipo.eql?("Proveedor")
            return 1
          elsif current_usuario.tipo.eql?("Investigador")
            return 2
          else 
            redirect_to :controller => "account", :action => "logout"
          end
    else
      return 3
    end
  end
  

  def oficial
    if (logged_in?)
      if (current_usuario.tipo.eql?("Investigador"))
        return false
      end
      return true
    end
    return false
  end
  
  
  
  def busquedaPatrones(cadena,patron,opciones)
    if (opciones == 1)
      (cadena.downcase).match(patron)
    else
      matchExactly(cadena.downcase,patron)
    end
  end
  
  def matchExactly (tag,word)
    tags = tag.split(" ")
    for t in tags
      if (t.eql?(word))
        return "true"
      end
    end
    return nil
  end
  
  
  def handlingRecordNotFound
      flash[:error_input] = 'Disculpe, no se encontró el elemento solicitado.'
      redirect_to :action => 'index' 
  end
  
  
  # Permite generar claves alfanumericas aleatorias.
  def String.random_alpha(size=16)
      s = ""
      size.times { s << (i = Kernel.rand(62); i += ((i < 10) ? 48 : ((i < 36) ? 55 : 61 ))).chr }
      s
  end


### USADAS POR ALFREDO.

   def inside(x1,y1,x2,y2,xn,yn)
       if ((x1 <= xn) && (xn <= x2))
         if ((y1 >= yn) && (yn >= y2))
           return 0
         else
           return 1
         end
       else
         return 1
       end
     end
     
### USADAS POR GIANPAOLO. 
   
 # Funcion que dice si un string es un float valido o no.
  def isAFloat(numero)
    num = numero.to_s.gsub(/[0-9]/, '') 
    numero = num.to_s.gsub(/\s/, '') 
    
    if numero == "." || num == ""
      return true
    else
      return false
    end
  end
  
  
  
  
  # Aqui verifico que un query ingresado no posea operaciones destructivas.
  def chequeoQuery(query)
    whatami
    keyword = ["drop", "insert", "create", "delete", "update","truncate"]
    query = query.to_s.strip.chomp.split(" ")
    
    for k in keyword
      for q in query
        if q.eql?(k)        
          return false
        end        
      end
    end
    return true
  end

end
