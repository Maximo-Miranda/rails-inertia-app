class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy, :publish, :unpublish]

  def index
    posts = Post.all

    # Filtros
    posts = posts.where("title LIKE ?", "%#{params[:search]}%") if params[:search].present?
    posts = posts.where(published: params[:status] == 'published') if params[:status].present? && params[:status] != 'all'

    # Ordenamiento
    sort_column = %w[id title created_at].include?(params[:sort_by]) ? params[:sort_by] : 'created_at'
    sort_direction = %w[asc desc].include?(params[:sort_direction]) ? params[:sort_direction] : 'desc'
    posts = posts.order(sort_column => sort_direction)

    # Paginación manual simple
    page = (params[:page] || 1).to_i
    per_page = (params[:per_page] || 10).to_i
    total = posts.count
    posts = posts.offset((page - 1) * per_page).limit(per_page)

    render inertia: 'Posts/Index', props: {
      posts: posts.map { |post| serialize_post(post) },
      pagination: {
        page: page,
        per_page: per_page,
        total: total,
        total_pages: (total.to_f / per_page).ceil
      },
      filters: {
        search: params[:search] || '',
        status: params[:status] || 'all'
      }
    }
  end

  def show
    render inertia: 'Posts/Show', props: {
      post: serialize_post(@post)
    }
  end

  def new
    render inertia: 'Posts/New', props: {
      post: {
        title: '',
        body: '',
        published: false
      }
    }
  end

  def create
    @post = Post.new(post_params)

    if @post.save
      redirect_to posts_path, notice: 'Post creado exitosamente.'
    else
      render inertia: 'Posts/New', props: {
        post: post_params,
        errors: @post.errors.messages
      }
    end
  end

  def edit
    render inertia: 'Posts/Edit', props: {
      post: serialize_post(@post)
    }
  end

  def update
    if @post.update(post_params)
      redirect_to posts_path, notice: 'Post actualizado exitosamente.'
    else
      render inertia: 'Posts/Edit', props: {
        post: serialize_post(@post).merge(post_params),
        errors: @post.errors.messages
      }
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: 'Post eliminado exitosamente.'
  end

  def publish
    @post.publish!
    redirect_to posts_path, notice: 'Post publicado exitosamente.'
  end

  def unpublish
    @post.unpublish!
    redirect_to posts_path, notice: 'Post despublicado exitosamente.'
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body, :published)
  end

  def serialize_post(post)
    {
      id: post.id,
      title: post.title,
      body: post.body,
      published: post.published,
      published_at: post.published_at&.iso8601,
      status: post.status,
      created_at: post.created_at.iso8601,
      updated_at: post.updated_at.iso8601
    }
  end
end
