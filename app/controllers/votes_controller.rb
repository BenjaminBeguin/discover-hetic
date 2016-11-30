class VotesController < ApplicationController
  def index
  	@votes = Vote.all()
  end

  def new
  end
end
