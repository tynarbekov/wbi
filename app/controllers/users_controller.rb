require 'uri'
require 'net/http'
require 'digest'
require 'json'

class UsersController < ApplicationController
  before_action :set_user, only: [:destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  # def show
  # end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  # def edit
  # end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        puts "---------------------------=============================="
        puts "SAVED"
        puts @user.studend_id
        sha256 = Digest::SHA256.hexdigest("#{@user.student_password}")


        uri = URI.join('https://ams.iaau.edu.kg/api/authentication/', "#{@user.studend_id}/", "#{sha256}")
        puts uri


        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = (uri.scheme == 'https')
        response = http.send_request('POST',uri.request_uri)
        token1 = response.body
        puts response.code

        if response.code == "200"

        token1 = JSON.parse(token1)
        token = []

        token1.each do |key, value|
          token.push(value)
        end

        url = URI("https://ams.iaau.edu.kg/api/v1/marks/2017-2018/fall")

        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = (uri.scheme == 'https')

        request = Net::HTTP::Get.new(url)
        puts token[0]
        request["bearer"] = token[0]
        response = http.request(request)

        # @body = JSON.parse(response.body)
        @user.studend_body = JSON.parse(response.body)

        @user.studend_body.each do |key, value|
          puts key, value
        end

      elsif response.code == "401"
        flash.now[:notice] = "You enter invalid ID or PASSWORD"
      else
        flash.now[:notice] = "Enter ID and PASSWORD"

      end



        format.html { render :new }
        # format.json { render :new, status: :created }
        destroy
      else
        format.html { render :new }
        # format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    # respond_to do |format|
    #   format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
    #   format.json { head :no_content }
    # end
  end

  #FOR 404 ERROR

  def catch_404
    raise ActionController::RoutingError.new(params[:path])
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      if @user = User.find(params[:id])
        @user = User.find(params[:id])
      else
        format.html { render :new }
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:studend_id, :student_password)
    end
end
