module Financor
  class Taxcode < ActiveRecord::Base

	  validates :name, presence: true, length: { maximum: 40 }, uniqueness: { scope: :patron_id }
	  validates :code, presence: true, length: { maximum: 40 }
	  validates :rate, numericality: { greater_than: 0 }

	  default_scope { where(patron_id: Nimbos::Patron.current_id) }
  end
end
