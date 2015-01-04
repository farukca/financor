module Financor
  class Finpoint < ActiveRecord::Base
    belongs_to :branch, class_name: Financor.branch_class
    belongs_to :manager, class_name: Financor.user_class

	  validates :title, presence: true, uniqueness: { scope: :patron_id }, length: { maximum: 100 }
	  validates :point_type, presence: true, length: { maximum: 30 }
	  validates :curr, length: { maximum: 3 }
	  validates :reference, length: { maximum: 50 }
	  validates :bank, length: { maximum: 100 }

    default_scope { where(patron_id: Nimbos::Patron.current_id) }

	  def to_s
	    title
	  end

	  def to_param
	  	"#{id}-#{title.parameterize}"
	  end

  end
end
