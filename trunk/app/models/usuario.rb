require 'digest/sha1'
class Usuario < ActiveRecord::Base
  has_many :vinculotag
  has_many :usuario_interese
  has_many :consulta
  has_many :solicitude
  has_many :servicio
  

  attr_accessor :password

  validates_presence_of :login, :nombre, :nombre, :apellido, :tipo, :sexo, :fecha_nacimiento, :fecha_registro, :nivel_estudio, :campo_trabajo, :message => "es un campo obligatorio."
  validates_presence_of :password,                   :if => :password_required?, :message => "es un campo obligatorio."
  validates_presence_of :password_confirmation,      :if => :password_required?, :message => "es un campo obligatorio."
  validates_length_of :login, :maximum=>40, :too_long => "no puede tener más de 40 caracteres."
  validates_length_of :tipo, :maximum=>14, :too_long => "no puede tener más de 14 caracteres."
  validates_length_of :sexo, :maximum=>1, :too_long => "no puede tener más de 1 caracter."
  validates_length_of :nombre, :apellido, :maximum=>20, :too_long => "no puede tener más de 20 caracteres."
  validates_length_of :nivel_estudio, :maximum=>25, :too_long => "no puede tener más de 25 caracteres."
  validates_length_of :campo_trabajo, :email_address, :maximum=>30, :too_long => "no puede tener más de 30 caracteres."
  validates_length_of :direccion_hab, :maximum=>200, :too_long => "no puede tener más de 200 caracteres."
  validates_length_of :password, :within => 4..40, :if => :password_required?, :message => "debe estar entre 4 y 40 caracteres."
  validates_confirmation_of :password, :if => :password_required?
  validates_uniqueness_of :login, :email_address, :case_sensitive => false, :message => "ya está registrado."
    
  validates_inclusion_of :sexo, :in => %w{ H M }
   validates_numericality_of :telefono, :message => "debe ser numérico", :allow_nil => true
  before_save :encrypt_password

  
  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find_by_login(login) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    self.remember_token_expires_at = 2.weeks.from_now.utc
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

  protected
    # before filter 
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.crypted_password = encrypt(password)
    end
    
    def password_required?
      crypted_password.blank? || !password.blank?
    end
end
