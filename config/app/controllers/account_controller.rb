class AccountController < ApplicationController

  # say something nice, you goof!  something sweet.
  def index
    redirect_to(:action => 'signup') unless logged_in? || Usuario.count > 0
  end

  def login
    return unless request.post?
    self.current_usuario = Usuario.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        self.current_usuario.remember_me
        cookies[:auth_token] = { :value => self.current_usuario.remember_token , :expires => self.current_usuario.remember_token_expires_at }
      end
      redirect_back_or_default(:controller => '/account', :action => 'index')
    else
      flash[:error_input] = "Datos no válidos."
    end
  end

  def signup
    @usuario = Usuario.new(params[:user])
    return unless request.post?
    @usuario.save!
    self.current_usuario = @usuario
    redirect_back_or_default(:controller => '/account', :action => 'index')
    flash[:notice] = "Thanks for signing up!"
  rescue ActiveRecord::RecordInvalid
    render :action => 'signup'
  end
  
  def logout
    self.current_usuario.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    redirect_back_or_default(:controller => 'usuario', :action => 'welcome')
  end
  
  
    # A traves del login que provee el usuario, busca su correo y le envia una clave temporal 
    # aleatoria que es en esta misma accion.
    def olvidoContrasena
      if params[:loginA].nil? || params[:loginA] == ""
        flash[:notice] = "Recuerde proveer al menos un nombre de usuario."
        redirect_to :action => 'claveTemporal'
      else
        begin          
          usuario = Usuario.find_by_login(params[:loginA]) 
          clave = String.random_alpha(100)
          Usuario.update(usuario.id, {:clave_temporal => clave})
          Notifier.deliver_olvido_contrasena(usuario.email_address,clave)
        rescue
          flash[:notice] = "Disculpe, el nombre de usuario provisto no fue encontrado." 
          redirect_to  :action => 'claveTemporal'
        end  
      end
    end
    
    
    
    
    
    # Actualiza la contrasena del usuario, siempre y cuando la clave temporal provista coincida con 
    # con la enviada al correo del usuario.
    def updatepasswordClaveTemp
      unless (params[:old].nil? && params[:new].nil? && params[:newrep].nil? && params[:login].nil?)
        unless (params[:old].eql?("") || params[:new].eql?("") || params[:newrep].eql?("") || params[:login].eql?(""))
          usuario = Usuario.find_by_login(params[:login])  
          if !usuario.nil? && (params[:new].eql?(params[:newrep])) && (params[:old].eql?(usuario.clave_temporal))
            usuario.update_attribute("password",params[:new])
            flash[:notice] = 'Clave de acceso actualizada satisfactoriamente'
            redirect_to :action => 'welcome', :controller => 'usuario'
          else
            flash[:error_input] = 'Error en sus datos, ingréselos nuevamente'
            redirect_to :action => 'claveTemporal'
          end
        end
      end    
    end
    

    
    
    
    def claveTemporal  
       # Maneja los datos de la pagina principal de "olvide mi contrasena".
    end
  
end
