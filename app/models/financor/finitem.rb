module Financor
  class Finitem < ActiveRecord::Base
    
	  belongs_to :user, class_name: Financor.user_class
    belongs_to :invoiced, polymorphic: true, touch: true#, counter_cache: true
	  belongs_to :branch, class_name: Financor.branch_class

  	has_many   :involines
	  accepts_nested_attributes_for :involines, :reject_if => proc { |a| a[:name].blank? }

	  has_many :comments, class_name: Financor.comment_class, as: :commentable, dependent: :destroy

    attr_accessor :invoice_financial_id, :local_curr

	  validates :name, presence: true, length: { maximum: 255 }
    validates :code, presence: true, length: { maximum: 255 }, uniqueness: { case_sensitive: false, scope: :patron_id }
    validates :item_type, presence: true, length: { maximum: 50 }
	  validates :sales_notes, :purchase_notes, length: { maximum: 500 }
    validates :purchase_price, numericality: true
    validates :sales_price, numericality: true
    validates :min_stock_unit, numericality: { integer: true }
    validates :purchase_curr, :sales_curr, length: { maximum: 3 }
    validates :stock_unit, length: { maximum: 30 }
    #validates :status, inclusion: { in: %w(active confirmed cancelled) }
    
	  default_scope { where(patron_id: Nimbos::Patron.current_id) }

    def token_inputs
      { id: id, text: name }
    end

    def prepopulate_tokens
      { id: id, text: name }
    end

    def to_param
      "#{id}-#{name.parameterize}"
    end

    def to_s
      "#{code} #{name}"
    end

  end
end
