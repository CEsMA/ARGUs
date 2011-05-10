class ConsultaController < ApplicationController
  before_filter :permisosProv, :only => [ :edit, :destroy, :update, :new, :create, :show, :insertTagsAsociados ]
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

         
         
  def list
    @consulta_pages, @consultas = paginate :consultas, :per_page => 5
    flash[:error_input] = nil
  end

  
  def show
    begin
        @consulta = Consulta.find(params[:id])
        tags = Consultatag.find(:all, :select => :tag, :conditions => {:consulta_id => params[:id]})
        @tagscomp = []
        for ta in tags
          @tagscomp << ta.tag << " "
        end
    rescue ActiveRecord::RecordNotFound
      handlingRecordNotFound
    end
  end

  
  
  def new
    @tags_pred = listar_tags
    @consulta = Consulta.new  
  end

  
  
  def validarSQL(query)
    error = ""
      puts "empiezo a validar!"
      if (query.eql?("") || query.nil?) &&
        error << "Debe ingresar una consulta SQL valida. SQL provisto vac'io."
        #raise SQLInvalido
      elsif !chequeoQuery(query)
        error << "Su consulta posee operaciones destructivas para el repositorio."
        #raise SQLInvalido
      elsif query.count("'").modulo(2) !=0
        error << "Su consulta es inválida: el número de comillas presentes no es par."
       # raise SQLInvalido
      elsif query.count("[") != query.count("]") || query.count("{") != query.count("}") || query.count("]") != query.count("{")
        error << "Su consulta es inválida: debe existir igual número de los siguientes caracteres '{', '[', ']', '}'."
        #raise SQLInvalido
      end
    puts "Todo parece estar bien en validarSQL"
    return error
  end
    
  
  
  def create
    begin
        @consulta = Consulta.new(params[:consulta])
        unless params[:pred] == 'true'
          @consulta.id_pred = 0
          @consulta.pred  = false
         
          error = validarSQL(@consulta.sql_query)
          # Si error es igual a "", es porque la consulta paso las validaciones realizadas.
          if !error.eql?("")
            raise FormatoInvalido
          end
        else
          @consulta.id_pred = maximo
          @consulta.pred  = true
        end

        @consulta.usuario_id = current_usuario.id 
        if @consulta.save
          tags_pred = listar_tags.to_a
          tags = params[:consultatag].chomp.split(" ").uniq
          insertTagsAsociados((tags & tags_pred).to_a.join(" "), nil)
          flash[:notice] = 'Consulta creada con éxito.'
          redirect_to :action => 'list'
        else
          render :action => 'new'
        end
    rescue
      flash[:error_input] = error
      render :action => 'new'
    end
  end
  
  
  
  
  # Retorna el maximo id_pred registrado en el repositorio.
  def maximo 
    sql = ActiveRecord::Base.connection()
    sql.begin_db_transaction
    @max = sql.execute("select max(id_pred) from consultas")
    sql.commit_db_transaction
    if @max.nil?
      return 1
    else
      return (@max[0][0].to_i + 1)
    end
  end

  
  
  def edit
    begin
      @consulta = Consulta.find(params[:id])
      @tags = Consultatag.find(:all, :select => :tag, :conditions => {:consulta_id => params[:id]})
      @tagscomp = []
      @tags_pred = listar_tags
      for ta in @tags
        @tagscomp << ta.tag << " "
      end
      
      if current_usuario.tipo.eql?("Administrador") || @consulta.usuario_id == current_usuario.id
        
      else 
         flash[:error_input] = 'Usted no puede editar un servicio que no es suyo.'
         redirect_to :action => 'list', :id => @consulta
      end
      #puts @tagscomp.to_s
    rescue ActiveRecord::RecordNotFound
       handlingRecordNotFound
    end
  end
  
  
  def update
    begin
        @consulta = Consulta.find(params[:id])
        @consulta.usuario_id = current_usuario.id 
  
       unless params[:pred] == 'true'
          @consulta.id_pred = 0
          @consulta.pred  = false
         
          error = validarSQL(@consulta.sql_query)
          # Si error es igual a "", es porque la consulta paso las validaciones realizadas.
          if !error.eql?("")
            raise FormatoInvalido
          end
        else
          
          @consulta.pred  = true
        end

        @consulta.usuario_id = current_usuario.id 
  
  
        if @consulta.update_attributes(params[:consulta])
          if !@consulta.pred?
            # puts @consulta.sql_query
            error = validarSQL(@consulta.sql_query)
            # Si error es igual a "", es porque la consulta paso las validaciones realizadas.
            if !error.eql?("")
               raise FormatoInvalido
            end
           end      

          tags_pred = listar_tags.to_a
          tags = params[:consultatag].chomp.split(" ").uniq
          Consultatag.destroy_all "consulta_id = '#{params[:id]}'"
          insertTagsAsociados((tags & tags_pred).to_a.join(" "), params[:id])

          flash[:notice] = 'Consulta actualizada.'
          redirect_to :action => 'list'
        else
          render :action => 'edit'
        end
    rescue
        flash[:error_input] = error
        render :action => 'edit', :id => @consulta
    end
  end

  
  def destroy
    begin
        if params[:id].nil?
          flash[:error_input] = "No fue posible eliminar la consulta seleccionada."
        else
          Consultatag.destroy_all "consulta_id = '#{params[:id]}'"
          Consulta.find(params[:id]).destroy

          flash[:notice] = "La consulta fue eliminada exitosamente del sistema."
          redirect_to :action => 'list'
        end
    rescue ActiveRecord::RecordNotFound
        handlingRecordNotFound
    end
  end
  
  
  def insertTagsAsociados (listasTags, idConsulta)
      if idConsulta.nil?
        id = (Consulta.find_by_sql("SELECT max(id) FROM consultas;"))[0].max
      else
        id = idConsulta 
      end
      @tags = (listasTags).chomp.split(" ").uniq    
      for tag in @tags
        @consultatag = Consultatag.new(:consulta_id => id, :tag => tag.to_s.slice(0,30))
        @consultatag.save
      end     
  end
  
  
  
  
 def busquedaconsultas
     tags = Consultatag.find(:all)
     @lista = []
      if (params[:patron].nil? || params[:patron]=="")
         flash[:notice] = 'Debe especificar una palabra clave.'
         redirect_to :action => 'list'
      else

        for pclave in tags 
          unless busquedaPatrones(pclave.tag,params[:patron].downcase,2).nil?
              @lista << pclave
          end  
        end
        
        if @lista.empty?
           flash[:notice] = "No hay consultas relacionadas con la palabra clave ingresada."
           redirect_to :action => 'list'
         else
           redirect_to :controller => "consultasfisicas", :action => "consultar", :nombretag => params[:patron].downcase
         end
     end
  end
  
 
   def listar_tags
     # Sección de dinamismo para la elección de información
     sql = ActiveRecord::Base.connection()
     sql.begin_db_transaction
     # Se busca en el esquema las columnas de las tablas de estacion
     value = sql.execute("select column_name from information_schema.columns where table_schema='public' and column_name NOT LIKE 'id%' AND column_name NOT LIKE 'activewarehouse%' AND column_name NOT LIKE '%_id' AND column_name NOT LIKE '%simple_captcha%' AND table_name != 'usuarios' AND table_name != 'consultatags'").to_a
     value << sql.execute("select table_name from information_schema.tables where table_schema='public'  AND table_name NOT LIKE 'activewarehouse%' AND table_name NOT LIKE '%simple_captcha%' AND table_name NOT LIKE 'column%'").to_a
     sql.commit_db_transaction
     value =  value.flatten 
     return value.sort.uniq
   end
  
end
