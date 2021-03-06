class PostsController < ApplicationController
  before_action :authorized
  before_action :set_post, only: %i[ show edit update destroy ]
  skip_before_action :verify_authenticity_token


  # GET /posts or /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1 or /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)
    user_id = decoded_token[0]['user_id'] 
    @post.user_id = user_id
    if @post.save
      PostWorker.perform_at(24.hours.from_now, @post.id)
      render json: @post, status: :created, location: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end

  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    user_id = decoded_token[0]['user_id']
    if user_id != @post.user_id
      render json: {errors: "Forbidden"}, status: :forbidden
      return 
    end

    if @post.update(post_params) 
       render json: @post, status: :ok, location: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    user_id = decoded_token[0]['user_id']
    if user_id == @post.user_id
      @post.destroy
      render json: @post, status: :ok, location: @post
    else
      render json: {errors: "Forbidden"}, status: :forbidden
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :body, :tags)
    end

end
