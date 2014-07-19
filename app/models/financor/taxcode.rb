module Financor
  class Taxcode < ActiveRecord::Base

	  validates :name, uniqueness: { scope: :patron_id, message: I18n.t('defaults.inputerror.must_be_unique') }, length: { maximum: 40 }, presence: true
	  validates :code, length: { maximum: 40 }
	  validates :rate, numericality: { greater_than: 0 }

	  default_scope { where(patron_id: Nimbos::Patron.current_id) }
  end
end
