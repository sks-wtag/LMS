class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  USER_TYPE_LEARNER = 'learner'.freeze
  USER_TYPE_INSTRUCTOR = 'instructor'.freeze
end
