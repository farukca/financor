require_dependency "financor/application_controller"

module Financor
  class TaxcodesController < ApplicationController

  	before_filter :require_login

    def index
    	@taxcodes = Taxcode.all
    	@taxcode  = Taxcode.new
    end

    def new
    	@taxcode = Taxcode.new
    end

    def edit
    	@taxcode = Taxcode.find(params[:id])
    end

    def create
      @taxcode = Taxcode.new(taxcode_params)
      @taxcode.user_id = current_user.id

      respond_to do |format|
        if @taxcode.save
          flash[:notice] = t("simple_form.messages.defaults.created", model: Financor::Taxcode.model_name.human)
          format.html { redirect_to taxcodes_url }
          format.json { render json: @taxcode, status: :created, location: @taxcode }
          format.js
        else
          format.html { render action: "new" }
          format.json { render json: @taxcode.errors, status: :unprocessable_entity }
          format.js
        end
      end
    end

    def update
      @taxcode = Taxcode.find(params[:id])
      respond_to do |format|
        if @taxcode.update_attributes(taxcode_params)
          format.html { redirect_to @taxcode, notice: t("simple_form.messages.defaults.updated", model: Financor::Taxcode.model_name.human) }
          format.json { head :ok }
          format.js
        else
          format.html { render action: "edit" }
          format.json { render json: @taxcode.errors, status: :unprocessable_entity }
          format.js
        end
      end
    end

    # def destroy
    #   @taxcode = Taxcode.find(params[:id])
    #   @taxcode.destroy!

    #   flash[:notice] = t("simple_form.messages.defaults.deleted", model: Financor::Taxcode.model_name.human)

    #   respond_to do |format|
    #     format.html { redirect_to taxcodes_url }
    #     format.json { head :ok }
    #     format.js
    #   end
    # end

    private
    def taxcode_params
      params.require(:taxcode).permit(:name, :rate, :code)
    end
  end
end
