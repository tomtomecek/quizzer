class Quiz < ActiveRecord::Base
  belongs_to :course
  has_many :exams
  has_many :questions

  validates_presence_of :title, :description
  validates :questions, presence: { message: "requires at least 1 question." }
  before_create :generate_slug

  accepts_nested_attributes_for :questions, allow_destroy: true

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

  private

  def slugify(the_slug)
    first_part = the_slug.split('-').slice(0...-1).join('-')
    second_part = the_slug.split('-').last.to_i + 1
    "#{first_part}-#{second_part}"
  end
end
