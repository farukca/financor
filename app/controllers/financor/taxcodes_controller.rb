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
          flash[:notice] = t("taxcodes.message.created")
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
          format.html { redirect_to @taxcode, notice: t("taxcodes.message.updated") }
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

    #   flash[:notice] = t("taxcodes.message.deleted")

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
