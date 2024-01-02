class User < ApplicationRecord
	
	
	has_many :enrollments
	has_many :courses, through: :enrollments
	
	has_many :user_course_progresses
	
	
	#first_name and last_name can't be nul;
	validates :first_name,:last_name,:email,:phone,:address, presence:true
	
	#first_name ans last_name must have at least 3-20 character
	validates :first_name,:last_name, length: {minimum:3,maximum:20}
	
	#first name and lastname must start with capital letter and match this regular expression
	validates :first_name, :last_name, format:{ with: /\A[A-Z]+[a-z0-9]*\z/}
	
	#email must be unique and case insensitive
	validates :email, uniqueness: { case_sensitive: false }
	
	#email should be valid according to this regular expression
	validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
	
	#phone number must match this valid regular expression
	# where the number start with +88 with optional number
	# and must have 01 prefix
	# third number must be 3 to 9
	# after that have 8 digit
	# this phone number look like +8801712198555 or 01712198333
	validates :phone, format: { with: /\A(\+?88)*01[3-9]\d{8}\z/, message: "must be valid phone number" }
	
	#address have at least 10 character and maximum 100 character
	validates :address, length: {minimum:10, maximum:100}
	
	enum role: {
		learner: 0,
		instructor: 1,
		admin: 2
	}
	
	#this function name return the full_name of a person
	def name
		"#{first_name} #{last_name}"
	end
end
