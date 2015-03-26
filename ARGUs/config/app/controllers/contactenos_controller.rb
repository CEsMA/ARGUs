class ContactenosController < ApplicationController
  def enviarComentario
    if params[:asunto].nil? || params[:cuerpo].nil? || params[:asunto] =="" || params[:cuerpo] ==""
        flash[:notice] = "Provea los datos que se le solicitan a continuación."
        # Renderizar la vista para que el usuario ingrese los datos del comentario.
    else
        Notifier.deliver_contactenos(params[:asunto],params[:cuerpo],params[:autor])
        flash[:notice] = "Gracias por enviárnos su opinión."
        redirect_to :action => 'welcome', :controller => 'usuario'
    end
  end
  
end
