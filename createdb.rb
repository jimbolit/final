# Set up for the application and database. DO NOT CHANGE. #############################
require "sequel"                                                                      #
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
                    purchase_location: "Apple Old Orchard",
                    user_id: 1)

purchases_table.insert(title: "Thursday Boots", 
                    cost: "$230",
                    purchase_date: "August 03 2020",
                    comments: "Awesome new D2C brand, check it out",
                    purchase_location: "online",
                    user_id: 1)

bandwagoners_table.insert(purchase_id: 1, 
                    user_id: 1,
                    comments: "Awesome new D2C brand, check it out",
                    number_of_items: 2)

users_table.insert(name: "Jim", 
                    email: "jim@lit",
                    password: "lit")