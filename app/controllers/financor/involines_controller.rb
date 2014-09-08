require_dependency "financor/application_controller"

module Financor
  class InvolinesController < ApplicationController

    before_filter :require_login

    def index
    end

    def new
      @invoice  = nil
      if params[:invoice_id].present?
        @invoice = Invoice.find(params[:invoice_id])
        @involine = @invoice.involines.new(curr: @invoice.curr, unit_number: 1)
      elsif params[:position_id].present?
        @position = Logistics::Position.find(params[:position_id])
        @involine = @position.involines.new(unit_number: 1)
      else
        @involine = Involine.new(unit_number: 1)
      end
    end

    def edit
      @invoice  = Invoice.find(params[:invoice_id]) if params[:invoice_id].present?
      @involine = Involine.find(params[:id])
    end

    def show
      @invoice  = Invoice.find(params[:invoice_id]) if params[:invoice_id].present?
      @involine = Involine.find(params[:id])
    end

    def create
      if params[:invoice_id].present?
        @invoice = Invoice.find(params[:invoice_id])
        @involine = @invoice.involines.new(involine_params)
        @involine.set_invoice_values(@invoice)
      else
        @involine = Involine.new(involine_params)
      end
      @involine.user_id = current_user.id

      respond_to do |format|
        if @involine.save
          #format.html { redirect_to @invoice, notice: t("simple_form.messages.defaults.created", model: Financor::Involine.model_name.human) }
          #format.html { render 'detail', notice: 'invoice was successfully created.' }
          format.json { render json: @involine, status: :created, location: @involine }
          format.js { flash.now[:notice] = t("simple_form.messages.defaults.created", model: Financor::Involine.model_name.human) }
        else
          #format.html { render action: "new" }
          format.json { render json: @involine.errors, status: :unprocessable_entity }
          format.js
        end
      end
    end

    def update
      @invoice  = Invoice.find(params[:invoice_id])
      @involine = Involine.find(params[:id])

      @invoice_id_changed = false
      if params[:involine].has_key?(:invoice_id)
        @invoice_id_changed = true
      end
      
      respond_to do |format|
        if @involine.update_attributes(involine_params)
          if @invoice
            @invoice.reload
          end
          
          #format.html { redirect_to @involine, notice: t("simple_form.messages.defaults.updated", model: Financor::Involine.model_name.human) }
          format.json { head :ok }
          format.js { flash.now[:notice] = t("simple_form.messages.defaults.updated", model: Financor::Involine.model_name.human) }
        else
          #format.html { render action: "edit" }
          format.json { render json: @involine.errors, status: :unprocessable_entity }
          format.js
        end
      end
    end

    def destroy
      @invoice  = Invoice.find(params[:invoice_id]) if params[:invoice_id].present?
      @involine = Involine.find(params[:id])
      @involine.destroy!

      respond_to do |format|
        #format.html { redirect_to @invoice }
        format.json { head :ok }
        format.js { flash.now[:notice] = t("simple_form.messages.defaults.deleted", model: Financor::Involine.model_name.human) }
      end
    end

    private
    def involine_params
      params.require(:involine).permit(:name, :company_id, :unit_number, :unit_type, :unit_price, :total_amount, :line_type, :debit_credit, :branch_id, :curr, :curr_rate, :notes, :vat_id, :vat_status, :parent_type, :parent_id, :invoice_id)
    end

  end
end
