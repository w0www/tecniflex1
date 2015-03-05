class Anilox < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    lineatura :integer
    bcm       :decimal, :precision => 5, :scale => 2
    marca     :string
    timestamps
  end
  
  validates_presence_of :lineatura, :bcm
  validates_inclusion_of :lineatura, :in => 100..1800, :message => "Debe estar entre 100 y 1800"
  belongs_to :impresora
  
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

  # ---------
  
  def name
    if marca == nil
      lineatura.to_s + '_' + bcm.to_s
    else
      marca + '_' + lineatura.to_s + '_' + bcm.to_s
    end
  end
end
