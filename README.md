# README

It's a simple emulator of ATM, written in form of RESTful API.
Made with the help of Ruby on Rails in API mode.
To start working with this app first clone it:
```
git clone git@github.com:ARiepin/atm.git
```
Then:
```
cd atm
```
```
bundle
```
```
rails db:create db:migrate db:seed
```
And finally run `rails s`.

To get acquainted with the existing endpoints and examine them, go to documentation at http://localhost:3000/docs

To run test execute `rspec` in terminal
