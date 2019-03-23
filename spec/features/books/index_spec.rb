require "rails_helper"

RSpec.describe "book index workflow", type: :feature do
  context 'as a visitor' do
    describe 'primary information on index page' do
      before :each do
        @book_1 = Book.create(title: "Where the Crawdads Sing", number_of_pages: 384, year_published: 2018, book_cover_url: "https://prodimage.images-bn.com/pimages/9780735219090_p0_v10_s550x406.jpg")
        @book_2 = Book.create(title: "East of Eden", number_of_pages: 608, year_published: 1952, book_cover_url: "https://upload.wikimedia.org/wikipedia/en/5/56/EastOfEden.jpg")
        @book_3 = Book.create(title: "Book_3", number_of_pages: 300, year_published: 3, book_cover_url: "image_3")
        @book_4 = Book.create(title: "Book_4", number_of_pages: 400, year_published: 4, book_cover_url: "image_4")

        @author_1 = @book_1.authors.create(name: "Delia Owens")
        @author_2 = @book_2.authors.create(name: "John Steinbeck")
        @author_2 = @book_2.authors.create(name: "Other Guy")
        @book_3.authors = [@author_1]
        @book_4.authors = [@author_1, @author_2]

        @review_1 = @book_1.reviews.create(title: 'title_1', rating: 5, text: 'body_1', username: 'user_1')
        @review_2 = @book_1.reviews.create(title: 'title_2', rating: 5, text: 'body_2', username: 'user_1')
        @review_3 = @book_1.reviews.create(title: 'title_3', rating: 3, text: 'body_3', username: 'user_2')
        @review_4 = @book_1.reviews.create(title: 'title_4', rating: 3, text: 'body_4', username: 'user_2')

        @review_5 = @book_2.reviews.create(title: 'title_5', rating: 5, text: 'body_5', username: 'user_1')
        @review_6 = @book_2.reviews.create(title: 'title_6', rating: 4, text: 'body_6', username: 'user_1')
        @review_7 = @book_2.reviews.create(title: 'title_7', rating: 3, text: 'body_7', username: 'user_2')
        @review_8 = @book_2.reviews.create(title: 'title_8', rating: 3, text: 'body_8', username: 'user_2')

        @book_3.reviews.create(title: 'title_8', rating: 5, text: 'body_8', username: 'user_3')

        @book_4.reviews.create(title: 'title_8', rating: 1, text: 'body_8', username: 'user_4')
      end

      it "displays all books correctly" do
        visit books_path

        within "#book-card-#{@book_1.id}" do
          expect(page).to have_link(@book_1.title)
          expect(page).to have_content("Number of Pages: #{@book_1.number_of_pages}")
          expect(page).to have_content("Author(s): Delia Owens")
          expect(page).to have_link("Delia Owens")
          expect(page).to have_content("Year Published: #{@book_1.year_published}")
          expect(page).to have_xpath("//img[@src='#{@book_1.book_cover_url}']")
          expect(page).to have_content("Average Book Rating: #{@book_1.average_review}")
          expect(page).to have_content("Total Reviews: #{@book_1.reviews.count}")
        end

        within "#book-card-#{@book_2.id}" do
          expect(page).to have_link(@book_2.title)
          expect(page).to have_content("Number of Pages: #{@book_2.number_of_pages}")
          expect(page).to have_content("Author(s): John Steinbeck Other Guy")
          expect(page).to have_link("John Steinbeck")
          expect(page).to have_link("Other Guy")
          expect(page).to have_content("Year Published: #{@book_2.year_published}")
          expect(page).to have_xpath("//img[@src='#{@book_2.book_cover_url}']")
          expect(page).to have_content("Average Book Rating: #{@book_2.average_review}")
          expect(page).to have_content("Total Reviews: #{@book_2.reviews.count}")
        end
      end

      it 'should display statistics' do
        visit books_path

        within('#stats') do
          within('#top-books') do
            expect(page).to have_content("#{@book_3.title} #{@book_1.title} #{@book_2.title}")
          end

          within('#btm-books') do
            expect(page).to have_content("#{@book_4.title} #{@book_2.title} #{@book_1.title}")
          end
        end
      end
    end
  end
end
