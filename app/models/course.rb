class Course < ActiveRecord::Base
  mount_uploader :image_cover, ImageUploader

  belongs_to :instructor, class_name: "Admin"
  has_many :quizzes, -> { order(:created_at) }
  has_many :enrollments

  validates :description, presence: true

  before_create :generate_slug

  def starting_quiz
    quizzes.published.find_by(position: 1)
  end

  def published_quizzes
    quizzes.published
  end

  def generate_slug
    the_slug = title.parameterize
    while Course.where(slug: the_slug).exists?
      if the_slug.split('-').last.to_i != 0
        the_slug = slugify(the_slug)
      else
        the_slug += "-2"
      end
    end
    self.slug = the_slug
  end

  def to_param
    slug
  end
  
private
  
  def slugify(the_slug)
    first_part = the_slug.split('-').slice(0...-1).join('-')
    second_part = the_slug.split('-').last.to_i + 1
    "#{first_part}-#{second_part}"
  end
end