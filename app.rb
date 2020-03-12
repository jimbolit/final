# Set up for the application and database. DO NOT CHANGE. #############################
require "sinatra"                                                                     #
require "sinatra/reloader" if development?                                            #
require "sequel"                                                                      #
require "logger"                                                                      #
require "twilio-ruby"                                                                 #
require "bcrypt"                                                                      #
connection_string = ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.sqlite3"  #
DB ||= Sequel.connect(connection_string)                                              #
DB.loggers << Logger.new($stdout) unless DB.loggers.size > 0                          #
def view(template); erb template.to_sym; end                                          #
use Rack::Session::Cookie, key: 'rack.session', path: '/', secret: 'secret'           #
before { puts; puts "--------------- NEW REQUEST ---------------"; puts }             #
after { puts; }                                                                       #
#######################################################################################

purchases_table = DB.from(:purchases)
bandwagoners_table = DB.from(:bandwagoners)
users_table = DB.from(:users)

before do
    @current_user = users_table.where(id: session["user_id"]).to_a[0]
end


get "/" do
    @purchases = purchases_table.all.to_a
    view "purchases"
end

post "/purchases/thanks" do
    purchases_table.insert(user_id: session["user_id"],
                           title: params["title"],
                           cost: params["cost"],
                           purchase_date: params["purchase_date"],
                           comments:params["comments"],
                           purchase_location: params["purchase_location"])
    view "purchases_thanks"
end

get "/purchase/:id" do
    @purchase = purchases_table.where(id: params["id"]).to_a[0]
    @bandwagoners = bandwagoners_table.where(purchase_id: @purchase[:id]).to_a
    @users_table = users_table
    view "purchase"
end

get "/purchase/:id/bandwagoner/new" do
    @purchase = purchases_table.where(id: params[:id]).to_a[0]
    view "new_bandwagoner"
end

post "/purchase/:id/bandwagon/thanks" do
    @purchase = purchases_table.where(id: params[:id]).to_a[0]
    bandwagoners_table.insert(purchase_id: params["id"],
                       user_id: session["user_id"],
                       number_of_items: params["number_of_items"],
                       comments: params["comments"])
    view "bandwagon_thanks"
end

get "/users/new" do
     view "new_user"
end

post "/users/create" do
    puts params
    hashed_password = BCrypt::Password.create(params["password"])
    users_table.insert(name: params["name"], email: params["email"], password: hashed_password)
    view "create_user"
end

get "/logins/new" do
    view "new_login"
end

post "/logins/create" do
    user = users_table.where(email: params["email"]).to_a[0]
    puts BCrypt::Password::new(user[:password])
    if user && BCrypt::Password::new(user[:password]) == params["password"]
        session["user_id"] = user[:id]
        @current_user = user
        view "create_login"
    else
        view "create_login_failed"
    end
end

get "/logout" do
    session["user_id"] = nil
    @current_user = nil
    view "logout"
end