module Financor
  class Budgetline < ActiveRecord::Base

	  belongs_to :company, class_name: Financor.company_class
	  belongs_to :user, class_name: Financor.user_class

	  has_many :comments, class_name: Financor.comment_class, as: :commentable, dependent: :destroy
	  
	  validates :name, presence: { message: I18n.t('defaults.inputerror.cant_be_blank') }, length: { maximum: 255 }
	  validates :notes, length: { maximum: 500 }

	  default_scope { where(patron_id: Nimbos::Patron.current_id) }
	  scope :active, where(status: "active")
	  scope :latests, order("created_at desc")

	  def to_s
	    name
	  end

	  def to_param
	  	"#{id}-#{name.parameterize}"
	  end

  end
end
