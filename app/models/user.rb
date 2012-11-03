	class User < ActiveRecord::Base

  hobo_user_model # Don't put anything above this

  fields do
    name          :string, :required, :unique
    rol	enum_string(:Operador, :Supervisor, :Grabador, :Gerente, :Facturador)
    email_address :email_address, :login => true
    administrator :boolean, :default => false
    iniciales     :string, :unique
    timestamps
  end

	has_many :intervencions
  has_many :tareas, :through => :intervencions
  has_many :asignacions, :class_name => "Tarea", :foreign_key => "asignada_a"
  has_many :procesos, :through => :user_labors, :accessible => true
  has_many :user_labors

  # This gives admin rights to the first sign-up.
  # Just remove it if you don't want that
  before_create { |user| user.administrator = true if !Rails.env.test? && count == 0 }

  #named_scope :administrators, lambda {|acting_user| {:conditions => {acting_user.administrator?} }}


	def facturador?
		self.rol == "Facturador"
	end


   def self.admines
    User.find(:all, :conditions => {:administrator => true})
  end

  def self.supervisores
		User.rol_is("Supervisor")
	end

  # --- Signup lifecycle --- #

  lifecycle do

    state :active, :default => true

    transition :request_password_reset, { :active => :active }, :new_key => true do
      UserMailer.deliver_forgot_password(self, lifecycle.key)
    end

    transition :reset_password, { :active => :active }, :available_to => :all,
               :params => [ :password, :password_confirmation ]

  end

  def superv?
    self.rol == "Supervisor"
  end

  def hace?(proce)
    self.procesos.*.nombre.include?(proce)
  end

  def sinfin
		self.intervencions.all(:conditions => {:termino => nil, :final => false})
	end




  # --- Permissions --- #

  def create_permitted?
    acting_user.administrator?
  end

  def update_permitted?
    acting_user.administrator? ||
      (acting_user == self && only_changed?(:email_address, :crypted_password,
                                            :current_password, :password, :password_confirmation))
    # Note: crypted_password has attr_protected so although it is permitted to change, it cannot be changed
    # directly from a form submission.
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    true
  end

end
