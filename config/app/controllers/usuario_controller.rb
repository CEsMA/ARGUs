class UsuarioController < ApplicationController
 
before_filter :login_required, :only => [ :destroy ]
before_filter :permisosAdmin, :only => [ :edit, :destroy, :show, :list ]

  def index
    list
    render :action => 'list'
  end

  
  
  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create],
         :redirect_to => { :action => :list }

  
  
  def list   
      sort = case params[:sort]
               when "Login"  then "login"
               when "Tipo"   then "tipo"
               when "fecha_registro" then "fecha_registro"
               when "Login_reverse"  then "login DESC"
               when "Tipo_reverse"   then "tipo DESC"
               when "fecha_registro_reverse" then "fecha_registro DESC"
             end
      
      @usuario_pages, @usuarios = paginate :usuarios, :order => sort, :per_page => 10

     if request.xml_http_request?
        render :partial => "list", :layout => false
      end
    end
  
  
  def auto_complete_for_usuario_login
    @usuarioL = Usuario.find(:all, :conditions => ["LOWER(login) LIKE ?","%#{params[:usuario][:login].to_s.split(" ").last.downcase}%"], :order => 'login ASC')
    render :partial => 'userlogins'
  end

  
  
  def show
    begin
      if (params[:usuario]).nil?
        @usuario = Usuario.find(params[:id])
      else
        @usuario = Usuario.find_by_login((params[:usuario][:login]).strip.chomp)
        if @usuario.nil?
          raise ActiveRecord::RecordNotFound
        end
      end
    rescue ActiveRecord::RecordNotFound
      handlingRecordNotFound
    end
 end

  
  
  def new
    unless params[:tipo].nil?
      @tipo = "user"
    else
      permisosAdmin
    end
    @usuario = Usuario.new
  end

  
  
  def create
    if simple_captcha_valid?
      @usuario = Usuario.new(params[:usuario])
      @usuario.fecha_registro = Time.now
      unless params[:tipo].nil?
        @usuario.tipo = "Investigador"
      end
      if @usuario.save
        flash[:notice] = 'Usuario creado.'
        unless (params[:tipo].nil?)
          redirect_to :action => 'welcome'
        else
          redirect_to :action => 'list'
        end

      else
        render :action => 'new'
      end
    else
      flash[:notice] = 'Disculpe, los datos no coinciden con la imagen. Por la seguridad del sistema usted fue redireccionado.'
      redirect_to :action => 'welcome', :controller => 'usuario'
    end
    
  end

  
  
  def edit
    begin
      @usuario = Usuario.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      handlingRecordNotFound
    end
  end
  
  
  def editunico
    begin 
      if params[:id].to_s.eql?(current_usuario.id.to_s) 
         @usuario = Usuario.find(params[:id])
      else
         redirect_to :action => 'welcome'
      end
    rescue ActiveRecord::RecordNotFound
      handlingRecordNotFound
    end
end

  
  def update
    begin
        @usuario = Usuario.find(params[:id])
        # puts @usuario.fecha_nacimiento 
        if @usuario.update_attributes(params[:usuario])
          flash[:notice] = 'Usuario actualizado.'
          if params[:unico].nil?
            redirect_to :action => 'show', :id => @usuario
          else
            redirect_to :action => 'modificar'
          end
        else
          if params[:unico].nil? 
            render :action => 'edit'
          else
            render :action => 'editunico'
          end 
        end
    rescue ActiveRecord::RecordNotFound
        handlingRecordNotFound
    end
  end
  
  
  
  def updatepassword
    unless (params[:old].nil? && params[:new].nil? && params[:newrep].nil?)
      unless (params[:old].eql?("") || params[:new].eql?("") || params[:newrep].eql?("") )
        user = Usuario.authenticate(params[:login],params[:old])
        if (!user.nil? && (params[:new].eql?(params[:newrep])) )
          user.update_attribute("password",params[:new])
          flash[:notice] = 'Password actualizado satisfactoriamente'
          redirect_to :action => 'welcome'
        else
          flash[:error_input] = 'Error en sus datos, ingréselos nuevamente'
        end
      end
    end
  end

  
  
  def destroy
    begin
      Usuario.find(params[:id]).destroy
      redirect_to :action => 'list'
    rescue ActiveRecord::RecordNotFound
      handlingRecordNotFound
    end
  end
  
    
  def welcome
    session[:inicio]= true
  end
  
  
  def modificar
  end
  
  
    ApplicationController.module_eval do
      include SimpleCaptcha::ControllerHelpers
      unloadable
    end
end
