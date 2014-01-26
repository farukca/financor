require_dependency "financor/application_controller"

module Financor
  class InvolinesController < ApplicationController
    def new
    end

    def edit
    end

    def index
    end


    def create
      @invoice = Invoice.find(params[:invoice_id])
      @involine = @invoice.involines.build(involine_params)
      @involine.set_invoice_values(@invoice)
      @involine.user_id = current_user.id

      respond_to do |format|
        if @involine.save
          flash[:notice] = t("involines.message.created")
          format.html { redirect_to @invoice }
          #format.html { render 'detail', notice: 'invoice was successfully created.' }
          format.json { render json: @involine, status: :created, location: @involine }
          format.js
        else
          format.html { render action: "new" }
          format.json { render json: @invoice.errors, status: :unprocessable_entity }
          format.js
        end
      end
    end

    private
    def involine_params
      params.require(:involine).permit(:name, :company_id, :unit_number, :unit_price, :total_amount, :line_type, :debit_credit, :branch_id, :curr, :curr_rate, :notes)
    end

  end
end
