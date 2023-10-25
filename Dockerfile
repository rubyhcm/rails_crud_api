# Sử dụng image chứa Ruby và Node.js
FROM ruby:2.6.5

# Cài đặt các dependencies và PostgreSQL client
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

# Tạo thư mục app trong container
RUN mkdir /app
WORKDIR /app

# Sao chép các file Gemfile vào thư mục app trong container
COPY Gemfile Gemfile.lock ./

# Cài đặt các gems
RUN gem install bundler:2.4.13
RUN gem update --system 3.2.3
RUN bundle install

# Sao chép tất cả các file trong thư mục gốc vào thư mục app trong container
COPY . .

# Tạo database và chạy migrations
# RUN rails  db:migrate
RUN RAILS_ENV=production bundle exec rails db:migrate

# Khai báo cổng mà ứng dụng sẽ chạy trên container
EXPOSE 3000

# Khởi chạy ứng dụng khi container được khởi động
CMD ["rails", "server", "-b", "0.0.0.0"]
