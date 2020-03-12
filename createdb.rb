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

purchases_table.insert(title: "iPhone 11", 
                    cost: "$749",
                    purchase_date: "June 21 2020",
                    comments: "Woow can't wait to get the new iPhone",
                    purchase_location: "Apple Old Orchard")

purchases_table.insert(title: "Thursday Boots", 
                    cost: "$230",
                    purchase_date: "August 03 2020",
                    comments: "Awesome new D2C brand, check it out",
                    purchase_location: "online")
