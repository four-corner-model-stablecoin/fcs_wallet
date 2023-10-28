FROM ruby:3.2.2

WORKDIR /fcs_wallet

COPY . .
RUN bundle install

CMD ["bin/wallet"]
