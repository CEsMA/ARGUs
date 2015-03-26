class VariableHidroclimaticaController < ApplicationController
  before_filter :permisosAdmin, :only => [ :list, :new, :create, :edit, :destroy, :show, :update ]
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @variable_hidroclimatica_pages, @variable_hidroclimaticas = paginate :variable_hidroclimaticas, :per_page => 10
  end

  def show
    begin
      @variable_hidroclimatica = VariableHidroclimatica.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        handlingRecordNotFound
    end
  end

  
  def new
    @variable_hidroclimatica = VariableHidroclimatica.new
  end

  
  def create
    @variable_hidroclimatica = VariableHidroclimatica.new(params[:variable_hidroclimatica])
    if @variable_hidroclimatica.save
      flash[:notice] = 'Variable Hidroclimatica creada.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  
  def edit
    begin
      @variable_hidroclimatica = VariableHidroclimatica.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        handlingRecordNotFound
    end
  end

  
  def update
    begin
      @variable_hidroclimatica = VariableHidroclimatica.find(params[:id])
      if @variable_hidroclimatica.update_attributes(params[:variable_hidroclimatica])
        flash[:notice] = 'Variable Hidroclimatica actualizada.'
        redirect_to :action => 'show', :id => @variable_hidroclimatica
      else
        render :action => 'edit'
      end
    rescue ActiveRecord::RecordNotFound
        handlingRecordNotFound
    end
  end

  
  
  def destroy
    begin
       VariableHidroclimatica.find(params[:id]).destroy
       redirect_to :action => 'list'
    rescue ActiveRecord::RecordNotFound
        handlingRecordNotFound
    end
  end
end
