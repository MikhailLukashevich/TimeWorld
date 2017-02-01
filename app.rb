#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'


set :database, "sqlite3:timeworld.db"


after do
  ActiveRecord::Base.clear_active_connections!
end


class City < ActiveRecord::Base
end


get '/' do
  @time_now = Time.now
  erb :index
end


get '/about' do
	erb :about
end

post '/city' do
  @time_now = Time.now
  @city = params[:city].capitalize

  if @city.length <=0
    @error = 'Enter city'
  return erb :index
  end

  @uts = parser_city @city

  if @uts == 0
    @error = 'City is not in the database'
    @city = ''
    return erb :index
  else

  @uts_i = parser_greenwich @uts
  @uts_s = parser_uts @uts_i
  @res_time = parser_time_now @time_now, @uts_i

  @aaa = parser_data

  # @aaa.each do |a|
  #   City.create :title => a[1], :greenwich => a[3]
  # end

  erb :index
  end
end

def parser_city city
  result = 0
  city_all = City.all
  city_all.each do |c|
    if c.title == city
      result = c.greenwich
      break
    else
      result = 0
    end
  end
  return result
end

def parser_greenwich time
  t1 = time.to_i
end

def parser_time_now time_now, uts_i
  date_arr = time_now.to_s.split(' ')
  time_arr = date_arr[1].split(":")
  hour = time_arr[0].to_i
  time_city_now = hour + uts_i -3
  if time_city_now < 0
    time_city_now = 24 + time_city_now
  elsif time_city_now > 24
    time_city_now = time_city_now - 24
  else
    time_city_now
  end
  if time_city_now >= 0 && time_city_now < 10
    time_city_now = "0" + time_city_now.to_s
  else
    time_city_now = time_city_now.to_s
  end
  time_arr[0] = time_city_now
  str0 = time_arr[0]
  str1 = time_arr[1]
  str2 = time_arr[2]
  res_str = str0 + ":" + str1 + ":" + str2
  res_time = res_str
end

def parser_data
  @arr = []
  input = File.open "timeZones.txt", "r"
  while line = input.gets
    arr0 = line.split(' ')
    arr1 = arr0[1].split("/")
    arr0[1] = arr1[1]
    @arr << arr0
  end
  input.close
  @arr
end

def parser_uts uts_i
  uts_s = 0
  if uts_i >= 0
    uts_s = uts_i.to_s
    uts_s = "(UTS+" + uts_s + ")"
  else
    uts_s = uts_i.to_s
    uts_s = "(UTS" + uts_s + ")"
  end
  return uts_s
end
