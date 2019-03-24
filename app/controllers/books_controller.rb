class BooksController < ApplicationController

  def new
    @book = Book.new
  end

  def create
    author_names = params[:authors].split(',')
    book = Book.create(book_params)
    if Book.already_exists?(book)
      redirect_to new_book_path
    else


    end
  end

  def index
    @books = Book.all
    @top_books = Book.top_books(3)
  end

  def show
    @book = Book.find(params[:id])
    @bottom_three_reviews = @book.bottom_three_reviews
    @top_three_reviews = @book.top_three_reviews
  end

  private

  def book_params

    params.require(:book).permit(:title, :year_published, :number_of_pages, :book_cover_url, :authors)
    params[:book][:authors] = params[:book][:authors].split(',')
  end
end
