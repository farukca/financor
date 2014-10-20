module Financor
  class CurrencyRate < ActiveRecord::Base

  	attr_accessor :process_rate, :usd_rate, :eur_rate, :find_usd_rate, :find_eur_rate


  	def self.convert(amount, curr, bank, bank_curr, rate_date)
  		@usd_currency = Financor::CurrencyRate.find_by(bank: bank, curr: "USD", bank_curr: bank_curr, rate_date: rate_date)
  		@eur_currency = Financor::CurrencyRate.find_by(bank: bank, curr: "EUR", bank_curr: bank_curr, rate_date: rate_date)
  		@sel_currency = nil
  		if curr == "USD"
  			@sel_currency = @usd_currency
  		elsif curr = "EUR"
  			@sel_currency = @eur_currency
  		else
  			@sel_currency = Financor::CurrencyRate.find_by(bank: bank, curr: curr, bank_curr: bank_curr, rate_date: rate_date)
  		end

  		converted_amount = (@sel_currency.rate * amount).round(2)
  		usd_amount       = (converted_amount / @usd_currency.rate).round(2)
  		eur_amount       = (converted_amount / @eur_currency.rate).round(2)

  		rate_curr        = @sel_currency.rate
  		rate_usd         = @usd_currency.rate
  		rate_eur         = @eur_currency.rate
  	end
  end
end
