class ReportesController < ApplicationController
  before_filter :permisosProv, :only => [ :index, :generar_acumulados ]

  def index
     permisosProv
     sql = ActiveRecord::Base.connection()
     sql.begin_db_transaction
     @variables = sql.execute("select nombre_hc from variable_hidroclimaticas WHERE acumulada_hc = 'S'") 
     sql.commit_db_transaction
  end

  def generar_acumulados
    permisosProv
    param = "precipitacion"
    unless (params[:nombre_var].nil?)
      param = params[:nombre_var]
    end
    sql = ActiveRecord::Base.connection()
    sql.begin_db_transaction
    id = sql.execute("select id from variable_dimension WHERE nombre_hc = '#{param}'")
    sql.commit_db_transaction
     @report = ActiveWarehouse::Report::TableReport.new(
       :title => "Reporte para variable acumulada.",
       :cube_name => :reporte_acumulado,
       :column_dimension_name => :tiempo,
      # :column_constraints => {
      #  :nombre_hc => ['pluviosidad']
      # },
       :conditions => "medidavarhc_facts.variable_id = #{id[0][0].to_i}" ,
       :row_dimension_name => :estacion
     )
 end

  def example1
    @report = ActiveWarehouse::Report::TableReport.new(
      :title => "Example 1",
      :cube_name => :regional_sales,
      :column_dimension_name => :date,
      :column_hierarchy => :cy,
      :column_constraints => {
        :calendar_year => ['2005','2006']
      },
      :row_dimension_name => :store,
      :row_hierarchy => :region,
      :format => {:gross_margin => Proc.new {|value| sprintf("%.2f", value) }}
    )
  end
 
end
