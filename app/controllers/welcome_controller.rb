class WelcomeController < ApplicationController
  def index
    cookies[:curso] = "Crypto coins "
    @meu_nome = params[:nome]
    @curso = params[:curso]
  end
end
