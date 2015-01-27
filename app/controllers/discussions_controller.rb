# encoding: utf-8

class DiscussionsController < ApplicationController
  before_action :set_discussion, only: [:show, :edit, :update, :destroy, :change_state, :vote, :change_following]
  before_action :authenticate_user!

  def index
    @state = params[:state]
    if @state.present?
      @discussions = Discussion.where(:state => @state)
    else
      @discussions = Discussion.all
    end
    respond_with(@discussions)
  end

  def show
    respond_with(@discussion)
  end

  def new
    @discussion = Discussion.new
    respond_with(@discussion)
  end

  def edit
  end

  def change_state
    @state = params[:state]
    if @state.present?
      @discussion.state = @state
      @discussion.save
    end
    redirect_to discussions_path(:state => @state)
  end

  def change_following
    if @discussion.followers.include?(current_user)
      @discussion.followers.delete(current_user)
    else
      @discussion.followers << current_user
    end
    redirect_to discussion_path(@discussion)
  end

  def create
    @discussion = Discussion.new(discussion_params)
    if current_user.present?
      @discussion.user = current_user
    end
    @discussion.state = "opened"
    @discussion.save
    respond_with(@discussion)
  end

  def update
    @discussion.update(discussion_params)
    respond_with(@discussion)
  end

  def destroy
    @discussion.destroy
    respond_with(@discussion)
  end

  def vote
    if params[:vote].present?
      if params[:vote] == "like"
        @discussion.liked_by current_user
        flash[:notice] = "Sie stimmen für dieses Thema."
      else
        @discussion.disliked_by current_user
        flash[:notice] = "Sie stimmen gegen dieses Thema."
      end
    end
    redirect_to discussion_path(@discussion)
  end

  private
    def set_discussion
      @discussion = Discussion.find(params[:id])
    end

    def discussion_params
      params.require(:discussion).permit(:title, :description, :user, :state, :tag_list)
    end
end
