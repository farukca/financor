require_dependency "financor/application_controller"

module Financor
  class FinitemsController < ApplicationController

		before_filter :require_login

		def index
      if params[:q]
        q = "%#{params[:q]}%".to_s.downcase
        @finitems = Finitem.where("lower(name) like ?", q).order(:name).limit(10)
      else
         if params[:id]
           @finitems = Finitem.where(id: params[:id])
         else
           @finitems = Finitem.order("name").page(params[:page]).per(10)
         end
      end

      respond_to do |format|
        format.html # index.html.erb
        format.js
        format.json { render json: @finitems.map(&:token_inputs) }
      end
		end

    def new
    	@finitem = Finitem.new(salable: true, purchasable: true, stockable: true)
    end

    def edit
      @finitem = Finitem.find(params[:id])
    end

    def show
      @finitem = Finitem.find(params[:id])
    end

    def create
      @finitem = Finitem.new(finitem_params)
      @finitem.user_id = current_user.id

      respond_to do |format|
        if @finitem.save
          #format.html { redirect_to @invoice, notice: t("simple_form.messages.defaults.created", model: Financor::Finitem.model_name.human) }
          #format.html { render 'detail', notice: 'invoice was successfully created.' }
          format.json { render json: @finitem, status: :created, location: @finitem }
          format.js { flash.now[:notice] = t("simple_form.messages.defaults.created", model: Financor::Finitem.model_name.human) }
        else
          #format.html { render action: "new" }
          format.json { render json: @finitem.errors, status: :unprocessable_entity }
          format.js
        end
      end
    end

    def update
      @finitem = Finitem.find(params[:id])

      
      respond_to do |format|
        if @finitem.update_attributes(finitem_params)          
          #format.html { redirect_to @finitem, notice: t("simple_form.messages.defaults.updated", model: Financor::Finitem.model_name.human) }
          format.json { head :ok }
          format.js { flash.now[:notice] = t("simple_form.messages.defaults.updated", model: Financor::Finitem.model_name.human) }
        else
          #format.html { render action: "edit" }
          format.json { render json: @finitem.errors, status: :unprocessable_entity }
          format.js
        end
      end
    end

    def destroy
      @finitem = Finitem.find(params[:id])
      @finitem.destroy!

      respond_to do |format|
        #format.html { redirect_to @invoice }
        format.json { head :ok }
        format.js { flash.now[:notice] = t("simple_form.messages.defaults.deleted", model: Financor::Finitem.model_name.human) }
      end
    end

	private
    def finitem_params
      params.require(:finitem).permit(:code, :name, :item_type, :salable, :sales_price, :sales_curr, :sales_tax_id, :sales_account_id, :sales_notes, :purchasable, :purchase_price, :purchase_curr, :purchase_tax_id, :purchase_account_id, :purchase_notes, :stockable, :stock_unit, :min_stock_unit)
    end
  end
end
