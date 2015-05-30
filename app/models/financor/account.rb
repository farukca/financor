module Financor
  class Account < ActiveRecord::Base
    belongs_to :user, class_name: Financor.user_class
    belongs_to :parent, polymorphic: true
    
    validates :name, presence: true, length: { maximum: 255 }
    validates :sales_account, :purchase_account, length: { maximum: 50 }
    
    default_scope { where(patron_id: Nimbos::Patron.current_id) }
    
    def to_param
      "#{id}-#{name.parameterize}"
    end

    def to_s
      "#{name}"
    end

  end
end