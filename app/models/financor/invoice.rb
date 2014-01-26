module Financor
  class Invoice < ActiveRecord::Base

		belongs_to :company, class_name: Financor.company_class
	  belongs_to :user, class_name: Financor.user_class
	  #belongs_to :branch, class_name: Financor.branch_class

  	has_many   :involines
	  accepts_nested_attributes_for :involines

	  has_many :comments, class_name: Financor.comment_class, as: :commentable, dependent: :destroy

	  validates :name, presence: true, uniqueness: { case_sensitive: false, scope: :patron_id }
	  #validates :branch_id, :load_coun, :unload_coun, presence: true
	  validates :company_id, presence: true
	  validates :invoice_date, presence: true
	  validates :invoice_type, presence: true
	  validates :debit_credit, presence: true
	  validates :curr, presence: true
	  validates :user_id, presence: true
	  validates :notes, length: { maximum: 500 }

	  default_scope { where(patron_id: Nimbos::Patron.current_id) }
	  scope :active, where(status: "active")

  	before_create :generate_uuid

  	def generate_uuid
  		self.uuid = Time.now.to_i.to_s
  		self.curr_rate = 1
  	end
  	
  end
end
