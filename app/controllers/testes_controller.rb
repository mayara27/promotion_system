class TestesController < ApplicationController
  
    def index
    @promotions = Promotion.all
  end
end