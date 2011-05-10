class VinculotagController < ApplicationController
#  before_filter :permisosInv, :only => [ :new, :create, :edit, :destroy, :update ]
#
#  def index
#    list
#    render :action => 'list'
#  end
#
#
#  verify :method => :post, :only => [ :destroy, :create, :update ],
#         :redirect_to => { :action => :list }
#
#
#
#  def list
#    @whatami = whatami_vinculo
#      sort = case params[:sort]
#               when "Vinculo"  then "vinculo"
#               when "Tag"   then "tag"
#               when "Descripcion" then "descripcion"
#               when "Oficial"  then "oficial"
#
#               when "Vinculo_reverse"  then "vinculo DESC"
#               when "Tag_reverse"   then "tag DESC"
#               when "Descripcion_reverse" then "descripcion DESC"
#               when "Oficial_reverse"  then "oficial DESC"
#             end
#     @vinculotag_pages, @vinculotags = paginate :vinculotags, :order => sort, :per_page => 10
#
#     if request.xml_http_request?
#        render :partial => "list", :layout => false
#      end
#  end
#
#
#
#  def listmisvinculos
#      sort = case params[:sort]
#               when "Vinculo"  then "vinculo"
#               when "Tag"   then "tag"
#               when "Descripcion" then "descripcion"
#               when "Oficial"  then "oficial"
#
#               when "Vinculo_reverse"  then "vinculo DESC"
#               when "Tag_reverse"   then "tag DESC"
#               when "Descripcion_reverse" then "descripcion DESC"
#               when "Oficial_reverse"  then "oficial DESC"
#             end
#
#      if whatami == 0
#        @vinculotag_pages, @vinculotags = paginate :vinculotags, :order => sort, :per_page     => 10
#      else
#        @vinculotag_pages, @vinculotags = paginate :vinculotags, :order => sort, :conditions => ['usuario_id = ?', current_usuario.id], :per_page => 10
#      end
#
#
#     if request.xml_http_request?
#        render :partial => "listmisvinculos", :layout => false
#      end
#  end
#
#
#
#  def show
#    begin
#       @vinculotag = Vinculotag.find(params[:id])
#    rescue ActiveRecord::RecordNotFound
#        handlingRecordNotFound
#    end
#  end
#
#
#
#  def new
#    @vinculotag = Vinculotag.new
#  end
#
#
#  def create
#    @vinculotag = Vinculotag.new(params[:vinculotag])
#    @vinculotag.usuario_id = current_usuario.id
#    @vinculotag.tag =  @vinculotag.tag.to_s.slice(0,300)
#    @vinculotag.descripcion = @vinculotag.descripcion.to_s.slice(0,200)
#    @vinculotag.tag = @vinculotag.tag.chomp.downcase.split(' ').uniq.join(' ')
#
#    if oficial
#      @vinculotag.oficial = "SI"
#    else
#      @vinculotag.oficial = "NO"
#    end
#
#    if @vinculotag.save
#       flash[:notice] = 'V'inculo creado.'
#       redirect_to :action => 'list'
#    else
#      render :action => 'new'
#    end
#  end
#
#
#
#  def edit
#    begin
#      @vinculotag = Vinculotag.find(params[:id])
#    rescue ActiveRecord::RecordNotFound
#        handlingRecordNotFound
#    end
#  end
#
#
#
#  def update
#    begin
#        @vinculotag = Vinculotag.find(params[:id])
#        @vinculotag.tag = @vinculotag.tag.to_s.slice(0,300)
#        @vinculotag.descripcion = @vinculotag.descripcion.to_s.slice(0,200)
#        if @vinculotag.update_attributes(params[:vinculotag])
#          flash[:notice] = 'V'inculo actualizado.'
#          redirect_to :action => 'listmisvinculos'
#        else
#          render :action => 'edit'
#        end
#    rescue ActiveRecord::RecordNotFound
#        handlingRecordNotFound
#    end
#  end
#
#
#
#  def destroy
#    begin
#        Vinculotag.find(params[:id]).destroy
#        redirect_to :action => 'list'
#    rescue ActiveRecord::RecordNotFound
#        handlingRecordNotFound
#    end
#  end
#
#
#  def destroyMultiple
#     if request.post?
#      if params[:to_delete].nil?
#        flash[:notice] = 'Recuerde seleccionar al menos un vinculo.'
#      else
#        #find all requested records
#        vinculos  = params[:to_delete].map { |r| Vinculotag.find_by_id(r) }
#        #make sure you are only working with records that exist
#        vinculos.delete(nil)
#        #destroy valid records
#        vinculos.each { |r| r.destroy }
#      end
#        flash[:notice] = 'V'inculo(s) eliminado(s) exitosamente.'
#        redirect_to :action => 'listmisvinculos'
#
#    end
#  end
#
#
#
#  def busquedavinculos
#     vinculos = Vinculotag.find(:all)
#     @vinculotags = []
#      if (params[:patron].nil? || params[:patron].eql?(""))
#         flash[:notice] = 'Recuerde especificar una palabra clave.'
#         redirect_to :action => 'list'
#      else
#        for vinculo in vinculos
#           unless busquedaPatrones(vinculo.tag,params[:patron].downcase,params[:opcion].to_i).nil?
#              @vinculotags << vinculo
#           end
#         end
#         if @vinculotags==[]
#           flash[:notice] = "No hay vinculos relacionados con la palabra ingresado."
#           redirect_to :action => 'list'
#         else
#           @tag = params[:patron].downcase
#         end
#     end
#  end
end
