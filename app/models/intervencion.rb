class Intervencion < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    inicio        :datetime
    termino       :datetime
    final         :boolean
    observaciones :text
    timestamps
  end

  belongs_to :tarea, :accessible => true
  belongs_to :user
  
	attr_accessor :vuelta

  before_create :rellenar
  
  after_create :actitar
  
#  after_save :checktar
  
  def find_interu(cuser)
    @cuser = cuser
    Intervencion.find(:all, :joins => :user, :conditions => ["name = ?", @cuser.name.to_s])
  end
  # --- Permissions --- #

  def create_permitted?
    acting_user.signed_up?
  end

  def update_permitted?
    acting_user.signed_up?
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    true
  end
  
  private
    def rellenar
      self.inicio = Time.now
    end
    
    def actitar
				if self.tarea.state = "habilitada"
					self.tarea.lifecycle.iniciar!(acting_user)
					if self.tarea.ord_trab.state = "habilitada"
						self.tarea.ord_trab.lifecycle.iniciar!(acting_user)
					end
				end
    end
    
    def checktar
      @ter = 0
      if self.termino
        self.tarea.intervencions.each do |interv|
          if interv.termino
            @ter += 1
          end
        end
      end
      if self.tarea.intervencions.count.to_i == @ter
        self.tarea.lifecycle.terminar!(acting_user)
      end
    end
end
