require_dependency "financor/application_controller"

module Financor
  class CurrencyRatesController < ApplicationController
    before_filter :require_login
    layout "admin"

    def index
      @currency_rates = Financor::CurrencyRate.order("created_at desc, curr asc").limit(20).page(params[:page]).per(20)
    end

    def show
    end

    def find_rate
      date_for_rate = params[:rate_date] || Time.zone.today
    	@currency_rate = Financor::CurrencyRate.find_by("bank = 'tcmb' AND bank_curr = ? AND curr = ? AND rate_date = ?", current_patron.currency, params[:curr], date_for_rate)

      respond_to do |format|
        format.json { render json: @currency_rate }
      end
    end

    private
    def currency_rate_params
      params.require(:currency_rate).permit(:name, :company_id, :invoice_type, :debit_credit, :branch_id, :curr, :curr_rate, :invoice_date, :due_date, :notes, :status, :invoiced_type, :invoiced_id, :invoice_title, :invoice_taxno, :invoice_taxoffice, :invoice_city, :invoice_country_id, :invoice_address, :invoice_financial_id, involines_attributes: [:name, :notes, :unit_number, :unit_type, :unit_price, :curr, :vat_id, :total_amount, :vat_status])
    end
  end
end
