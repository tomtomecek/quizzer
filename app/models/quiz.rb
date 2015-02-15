class Quiz < ActiveRecord::Base
  belongs_to :course
  has_many :exams
  has_many :questions, -> { order(:created_at) }, dependent: :destroy
  scope :published, -> { where(published: true) }

  validates :title, :description, :passing_percentage, presence: true
  validates :position, numericality: { only_integer: true }, if: :published?
  validates :questions, presence: { message: "requires at least 1 question." }

  accepts_nested_attributes_for :questions, allow_destroy: true
  before_create :generate_slug
  before_validation :normalize_positions

  def total_score
    questions.pluck(:points).inject(:+)
  end

  def generate_slug
    the_slug = title.parameterize
    while Quiz.where(slug: the_slug).exists?
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

  def passing_score
    passing_percentage / 100.0 * total_score
  end

  def previous
    previous_position = position - 1
    course.quizzes.published.find_by(position: previous_position)
  end

private

  def normalize_positions
    if published?
      self.position = course.quizzes.published.size + 1 if position.nil?
    else
      self.position = nil
    end
  end

  def slugify(the_slug)
    first_part = the_slug.split('-').slice(0...-1).join('-')
    second_part = the_slug.split('-').last.to_i + 1
    "#{first_part}-#{second_part}"
  end
end
