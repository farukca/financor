require_dependency "financor/application_controller"

module Financor
  class BudgetlinesController < ApplicationController
    def index
    end

    def new
    	@budgetline = Budgetline.new
    end

    def edit
    	@budgetline = Budgetline.find(params[:id])
    end
  end
end
