class User
  include Mongoid::Document
  field :name, type: String

  has_many :entries

  validates :name, presence: true, allow_nil: false, allow_blank: false
end
