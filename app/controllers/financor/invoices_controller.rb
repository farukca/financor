require_dependency "financor/application_controller"

module Financor
  class InvoicesController < ApplicationController

    before_filter :require_login
    before_filter(:only => [:index]) { |c| c.set_tab "financenavigator" if params[:home].present? }

    def index
      @invoices = Invoice.order("created_at desc").limit(10).page(params[:page]).per(10)
    end

    def show
      @invoice = Invoice.find(params[:id])
    end

    def new
    	@invoice = Invoice.new(invoice_date: Time.zone.today)
      3.times do
        @involine = @invoice.involines.new
      end
      if params[:position_id].present?
        @position = Logistics::Position.find(params[:position_id])
        @invoice.invoiced = @position
      end
    end

    def edit
      @invoice = Invoice.find(params[:id])
    end

    def create
      @invoice = Invoice.new(invoice_params)
      @invoice.user_id = current_user.id

      respond_to do |format|
        if @invoice.save
          flash[:notice] = t("invoices.message.created")
          format.html { redirect_to @invoice }
          #format.html { render 'detail', notice: 'invoice was successfully created.' }
          format.json { render json: @invoice, status: :created, location: @invoice }
        else
          format.html { render action: "new" }
          format.json { render json: @invoice.errors, status: :unprocessable_entity }
        end
      end
    end

    def update
      @invoice = Invoice.find(params[:id])

      respond_to do |format|
        if @invoice.update_attributes(invoice_params)
          format.html { redirect_to @invoice, notice: t("invoices.message.updated") }
          format.json { head :ok }
        else
          format.html { render action: "edit" }
          format.json { render json: @invoice.errors, status: :unprocessable_entity }
        end
      end
    end

    def preview
      @invoice = Invoice.find(params[:id])
      
      if @invoice.company.country_id == "TR"
        I18n.locale = "tr"
      else
        I18n.locale = "en"
      end
      
      respond_to do |format|
        format.html { render layout: "preview" }
        format.json { render json: @lead }
        format.pdf
      end
    end

    def destroy
      @invoice = Invoice.find(params[:id])
      #@junk = Arsiv::Junk.send_to_junk(current_user.id, @invoice, @invoice.reference, @invoice.company_name)
      @invoice.destroy
      flash[:notice] = t("invoices.message.deleted")

      respond_to do |format|
        format.html { redirect_to financor.invoices_url }
        format.json { head :ok }
      end
    end

    private
    def invoice_params
      params.require(:invoice).permit(:name, :company_id, :invoice_type, :debit_credit, :branch_id, :curr, :curr_rate, :invoice_date, :due_date, :notes, :status, :invoiced_type, :invoiced_id, involines_attributes: [:name, :notes, :unit_number, :unit_type, :unit_price, :curr, :vat_id, :total_amount, :vat_status])
    end

  end

end
