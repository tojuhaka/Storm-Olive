# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  firstname          :string(255)
#  lastname           :string(255)
#  nick               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#

class User < ActiveRecord::Base
    attr_accessor :password
    attr_accessible :firstname, :lastname, :nick, 
                    :email, :password, :password_confirmation
                    
                    

    email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

    validates :firstname, :presence => true,
                          :length => { :maximum => 50 }

    validates :lastname, :presence => true,
                          :length => { :maximum => 50 }

    validates :nick, :presence => true,
                     :uniqueness => { :case_sensitive => false },
                          :length => { :maximum => 19 }

    validates :email, :presence => true,
                      :format => { :with => email_regex },
                      :uniqueness => { :case_sensitive => false }
    # Automatically create the virtual attribute 'password_confirmation'
    validates :password, :presence => true,
                         :confirmation => true,
                         :length => { :within => 6..40 }

    before_save :encrypt_password

    def has_password?(submitted_password)
      self.encrypted_password == encrypt(submitted_password)
    end
    
    def self.authenticate(email, password)
      user = find_by_email(email)
      return nil if user.nil?
      return user if user.has_password?(password)
    end

    def self.authenticate_with_salt(id, cookie_salt)
      user = find_by_id(id)
      return nil if user.nil?
      return user if user.salt == cookie_salt
    end
#remove this comment
    private
      def encrypt_password
        self.salt = make_salt if new_record?
        self.encrypted_password = encrypt(password)
      end

      def encrypt(string)
        secure_hash("#{salt}--#{string}")
      end

      def make_salt
        secure_hash("#{Time.now.utc}--#{password}")
      end

      def secure_hash(string)
        Digest::SHA2.hexdigest(string)
      end
end
