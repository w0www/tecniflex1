class Proceso < ActiveRecord::Base

  hobo_model # Don't put anything above this

  acts_as_list

  fields do
    nombre                :string, :name => :true
    descripcion           :text
    prueba	              :boolean
    reiniciar         	  :boolean # Reiniciar procesos
    volver_a_revision	    :boolean # Volver a revision                    
    rev		                :boolean # Revision
    volver_desde_revision	:boolean # Destino de revision
    edicion_medidas	      :boolean # Edicion de medidas
    minutos_minimo        :integer
    factura               :boolean, :default => false # Facturacion
    timestamps
  end

  # Un proceso tiene muchas ordenes de trabajo (Tabla relacionada "Tareas")
  has_many :ord_trabs, :through => :tareas
  has_many :tareas, :dependent => :destroy

  has_many :recursos
  has_many :users, :through => :user_labors
  has_many :user_labors
  has_many :antecesors, :class_name => "Proceso", :foreign_key => "sucesor_id"
  belongs_to :sucesor, :class_name => "Proceso"
  belongs_to :grupoproc

  default_scope :order => 'position'

  def self.asignables
    @gasig = Grupoproc.asignar
    Proceso.find(:all, :conditions => ["grupoproc_id IN (?)", @gasig])
  end

  def self.checkproc(ticket)
    gpro = Proceso.all(:joins => [:grupoproc], :conditions => {"grupoprocs.#{ticket}" => true})
  end

  # --- Permissions --- #
  def create_permitted?
    acting_user.administrator?
  end

  def update_permitted?
    acting_user.administrator?
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    true
  end

end

