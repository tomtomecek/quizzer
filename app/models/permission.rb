class Permission < ActiveRecord::Base
  belongs_to :student, class_name: "User"
  belongs_to :enrollment
  belongs_to :quiz
end
