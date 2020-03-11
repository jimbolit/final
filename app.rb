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

get "/" do
    @purchases = purchases_table.all.to_a
    view "purchases"
end

get "/purchase/:id" do
    @purchase = purchases_table.where(id: params["id"]).to_a[0]
    view "purchase"
end

get "/purchase/:id/bandwagoner/new" do
    @purchase = purchases_table.where(id: params[:id]).to_a[0]
    view "new_bandwagoner"
end

get "/purchase/:id/bandwagon/thanks" do
    puts params
    @purchase = purchases_table.where(id: params[:id]).to_a[0]
    puts @purchase
    bandwagoners_table.insert(purchase_id: params["id"],
                       user_id: 1,
                       onwagon: params["onwagon"],
                       comments: params["comments"])
    view "bandwagon_thanks"
end
