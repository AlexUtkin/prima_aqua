class PageContentsController < ApplicationController
  def show
    @page = PageContent.send(params[:id])
    redirect_to root_path unless @page
  end
end
