class Post < ApplicationRecord
  # Validaciones
  validates :title, presence: true, length: { minimum: 3, maximum: 255 }
  validates :body, presence: true, length: { minimum: 10 }

  # Scopes
  scope :published, -> { where(published: true) }
  scope :draft, -> { where(published: false) }
  scope :recent, -> { order(created_at: :desc) }
  scope :by_published_date, -> { order(published_at: :desc) }

  # Callbacks
  before_save :set_published_at, if: :publishing?

  # Métodos de instancia
  def publish!
    update(published: true, published_at: Time.current)
  end

  def unpublish!
    update(published: false, published_at: nil)
  end

  def draft?
    !published?
  end

  def status
    published? ? 'published' : 'draft'
  end

  private

  def publishing?
    published? && published_changed? && published_at.nil?
  end

  def set_published_at
    self.published_at = Time.current
  end
end
