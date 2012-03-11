class Proceso < ActiveRecord::Base

  hobo_model # Don't put anything above this

  acts_as_list
  
  fields do
    nombre      :string, :name => :true
    descripcion :text
    timestamps
  end

  has_many :tareas, :dependent => :destroy
  has_many :recursos
  has_many :users, :through => :user_labors
  has_many :user_labors
  has_many :antecesors, :class_name => "Proceso", :foreign_key => "sucesor_id"
  belongs_to :sucesor, :class_name => "Proceso"
  belongs_to :grupoproc


	def self.asignables
		@gasig = Grupoproc.asignar
		Proceso.find(:all, :conditions => ["grupoproc_id IN (?)", @gasig])
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

