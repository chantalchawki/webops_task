class CommentsController < ApplicationController
  before_action :authorized
  before_action :set_comment, only: %i[ show edit update destroy ]
  skip_before_action :verify_authenticity_token

  # GET /comments or /comments.json
  def index
    @comments = Comment.all
  end

  # GET /comments/1 or /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments or /comments.json
  def create
    user_id = decoded_token[0]['user_id']
    params = create_comment_params
    params[:user_id] = user_id
    @comment = Comment.new(params)
    if @comment.save
      render json: @comment, status: :created, location: @comment
    else
      render json: @comment.errors, status: :unprocessable_entity
    end

  end

  # PATCH/PUT /comments/1 or /comments/1.json
  def update
    user_id = decoded_token[0]['user_id']
    if user_id != @comment.user_id 
      render json: {errors: "Forbidden"}, status: :forbidden
    end
    if @comment.update(comment_params)
      render json: @comment, status: :ok, location: @comment
    else
      render json: @comment.errors, status: :unprocessable_entity
    end

  end

  # DELETE /comments/1 or /comments/1.json
  def destroy
    user_id = decoded_token[0]['user_id']
    if user_id == @comment.user_id
      @comment.destroy
      render json: @comment, status: :ok, location: @comment
     else
       render json: {errors: "Forbidden"}, status: :forbidden
     end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.require(:comment).permit(:body)
    end

    def create_comment_params
      params.require(:comment).permit(:body, :post_id)
    end

end
