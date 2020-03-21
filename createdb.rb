# Set up for the application and database. DO NOT CHANGE. #############################
require "sequel"
require "bcrypt"                                                                      #
connection_string = ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.sqlite3"  #
DB = Sequel.connect(connection_string)                                                #
#######################################################################################

# Database schema - this should reflect your domain model
DB.create_table! :purchases do
  primary_key :id
  foreign_key :user_id
  String :title
  String :cost
  String :purchase_date
  String :comments, text: true
  String :purchase_location
end
DB.create_table! :bandwagoners do
  primary_key :id
  foreign_key :purchase_id
  foreign_key :user_id
  String :comments, text: true
  Integer :number_of_items
end
DB.create_table! :users do
  primary_key :id
  String :name
  String :email
  String :password
end


# Insert initial (seed) data
purchases_table = DB.from(:purchases)
bandwagoners_table = DB.from(:bandwagoners)
users_table = DB.from(:users)

purchases_table.insert(title: "iPhone 11", 
                    cost: "$749",
                    purchase_date: "June 21 2020",
                    comments: "Woow can't wait to get the new iPhone",
                    purchase_location: "Apple Store, Old Orchard, Skokie",
                    user_id: 1)

purchases_table.insert(title: "Thursday Boots", 
                    cost: "$230",
                    purchase_date: "August 03 2020",
                    comments: "Awesome new D2C brand, check it out",
                    purchase_location: "E2 Apartments Evanston",
                    user_id: 1)

bandwagoners_table.insert(purchase_id: 1, 
                    user_id: 2,
                    comments: "Wow love this!!",
                    number_of_items: 2)

bandwagoners_table.insert(purchase_id: 2, 
                    user_id: 2,
                    comments: "I really needed some new leather boots",
                    number_of_items: 2)

users_table.insert(name: "Jim", 
                    email: "jim@lit",
                    password: BCrypt::Password.create("lit"))

users_table.insert(name: "Damo", 
                    email: "damo@fun",
                    password: BCrypt::Password.create("fun"))