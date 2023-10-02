class BooksController < ApplicationController

  def show
    @new_book = Book.new
    @book_comment = BookComment.new
    @book = Book.find(params[:id])
    @user = @book.user
    # 閲覧数
    @book_detail = Book.find(params[:id])
    unless ViewCount.find_by(user_id: current_user.id, book_id: @book_detail.id)
      current_user.view_counts.create(book_id: @book_detail.id)
    end
    # unless ViewCount.where(created_at: Time.zone.now.all_day).find_by(user_id: current_user.id, book_id: @book.id)
    #   current_user.view_counts.create(book_id: @book_detail.id)
    # end
  end

  def index
    @book = Book.new
    to = Time.current.at_end_of_day
    from = (to - 6.day).at_beginning_of_day
    @books = Book.includes(:favorited_users).
      sort_by{|x|
      x.favorited_users.includes(:favorites).where(created_at: from...to).size}.reverse
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
    unless @book.user.id == current_user.id
      redirect_to books_path
    end
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body, :image, :star)
  end
end
