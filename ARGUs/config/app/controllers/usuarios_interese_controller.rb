class UsuariosIntereseController < ApplicationController
  before_filter :permisosInv, :only => [ :list, :new, :update ]
  
  def index
    list
    render :action => 'list'
  end

  
  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [:update ],
         :redirect_to => { :action => :list }

         
         
  def list
   usuarios_interese = UsuariosInterese.find(:all, :conditions => {:usuario_id => current_usuario.id})
   areas = Areainterese.find(:all)
   @areasinteres = Areainterese.find(:all)
   @checked = [] 
   if (params[:intereses].nil?)
      for area in areas
        for  u_int in usuarios_interese
            if u_int.areainterese_id.to_s.eql?(area.id.to_s)
              @checked.push(area)
              @areasinteres.delete(area)
            end
        end
      end
    end
  end
         
  

  def new
    @usuarios_interese = UsuariosInterese.new
  end
  
  
  def update
    UsuariosInterese.destroy_all "usuario_id = '#{current_usuario.id}'"
    unless (params[:intereses]).nil?
          for interes in params[:intereses]
            interesusuario = UsuariosInterese.new
            interesusuario.areainterese_id = interes
            interesusuario.usuario_id = current_usuario.id
            interesusuario.save
           end
    end
    flash[:notice] = "Sus áreas de interés fueron actualizadas exitosamente."
    redirect_to :action => 'list'
  end
  
end
