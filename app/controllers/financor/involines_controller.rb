require_dependency "financor/application_controller"

module Financor
  class InvolinesController < ApplicationController

    before_filter :require_login

    def index
    end

    def new
      @invoice = Invoice.find(params[:invoice_id])
      @involine = @invoice.involines.new(curr: @invoice.curr, unit_number: 1)

    end

    def edit
      @invoice  = Invoice.find(params[:invoice_id])
      @involine = Involine.find(params[:id])
    end

    def show
      @invoice  = Invoice.find(params[:invoice_id])
      @involine = Involine.find(params[:id])
    end

    def create
      @invoice = Invoice.find(params[:invoice_id])
      @involine = @invoice.involines.build(involine_params)
      @involine.set_invoice_values(@invoice)
      @involine.user_id = current_user.id
      @involine.isfrom  = "manuel"

      respond_to do |format|
        if @involine.save
          flash[:notice] = t("simple_form.messages.defaults.created", model: Financor::Involine.model_name.human)
          format.html { redirect_to @invoice }
          #format.html { render 'detail', notice: 'invoice was successfully created.' }
          format.json { render json: @involine, status: :created, location: @involine }
          format.js
        else
          format.html { render action: "new" }
          format.json { render json: @involine.errors, status: :unprocessable_entity }
          format.js
        end
      end
    end

    def update
      @invoice  = Invoice.find(params[:invoice_id])
      @involine = Involine.find(params[:id])
      respond_to do |format|
        if @involine.update_attributes(involine_params)
          @invoice.reload

          format.html { redirect_to @involine, notice: t("simple_form.messages.defaults.updated", model: Financor::Involine.model_name.human) }
          format.json { head :ok }
          format.js
        else
          format.html { render action: "edit" }
          format.json { render json: @involine.errors, status: :unprocessable_entity }
          format.js
        end
      end
    end

    def destroy
      @invoice  = Invoice.find(params[:invoice_id])
      @involine = Involine.find(params[:id])
      @involine.destroy!

      flash[:notice] = t("simple_form.messages.defaults.deleted", model: Financor::Involine.model_name.human)

      respond_to do |format|
        format.html { redirect_to @invoice }
        format.json { head :ok }
        format.js
      end
    end

    private
    def involine_params
      params.require(:involine).permit(:name, :company_id, :unit_number, :unit_type, :unit_price, :total_amount, :line_type, :debit_credit, :branch_id, :curr, :curr_rate, :notes, :vat_id, :vat_status)
    end

  end
end
