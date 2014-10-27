# encoding: utf-8

class AccountsController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, :except => [:login]
  before_action :check_admin_role, :except => [:login]

  def profile
    @account = current_user
  end

  def login
    if params[:user].present? && params[:user][:email].present?
      user = User.find_by_email(params[:user][:email])
      if user.present?
        user.save
        Mailer.login(user, request.referer).deliver
        flash[:notice] = "Es wurde eine Email an Ihre Adresse gesendet. Die Email enthält einen einmal gültigen Anmeldelink!"
        redirect_to root_path()
      else
        flash[:notice] = "Beim Anmelden ist ein Fehler aufgetreten."
      end
    else
      flash[:notice] = "Beim Anmelden ist ein Fehler aufgetreten."
      redirect_to :back
    end
  end

  # GET /users
  # GET /users.json
  def index
    @accounts = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @account = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @account = User.new(user_params)
    rand_pass = Digest::MD5.hexdigest(Time.now.to_i.to_s)
    @account.password = rand_pass
    @account.password_confirmation = rand_pass

    respond_to do |format|
      if @account.save
        format.html { redirect_to account_path(@account), notice: 'Account wurde erfolgreich erstellt' }
        format.json { render :show, status: :created, location: @account }
      else
        format.html { render :new }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @account.update(user_params)
        format.html { redirect_to profile_path(@account), notice: 'Account wurde erfolgreich aktualisiert.' }
        format.json { render :show, status: :ok, location: @account }
      else
        format.html { render :edit }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @account.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'Account wurde erfolgreich gelöscht' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @account = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:privacy, :gender, :first_name, :last_name, :apartment, :email, :notify_me_on_discussion_create, :notify_me_on_new_articles_i_follow, :notify_me_on_new_articles_i_moderate)
    end

    def check_admin_role
      if current_user.blank? || !current_user.has_role?(:admin)
        redirect_to root_path()
      end
    end
end
