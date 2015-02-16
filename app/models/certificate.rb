class Certificate < ActiveRecord::Base
  belongs_to :enrollment
  belongs_to :student, class_name: "User"
end
