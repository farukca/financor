require_dependency "financor/application_controller"

module Financor
  class FinpointsController < ApplicationController
    before_action :set_finpoint, only: [:show, :edit, :update, :destroy]

    def index
      @finpoints = Finpoint.all
    end

    def show
    end

    def new
      @finpoint = Finpoint.new
    end

    def edit
    end

    def create
      @finpoint = Finpoint.new(finpoint_params)

      if @finpoint.save
        redirect_to @finpoint, notice: 'Finpoint was successfully created.'
      else
        render :new
      end
    end

    def update
      if @finpoint.update(finpoint_params)
        redirect_to @finpoint, notice: 'Finpoint was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @finpoint.destroy
      redirect_to finpoints_url, notice: 'Finpoint was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_finpoint
        @finpoint = Finpoint.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def finpoint_params
        params.require(:finpoint).permit(:title, :point_type, :curr, :reference, :bank, :branch_id, :manager_id, :patron_id)
      end
  end
end
