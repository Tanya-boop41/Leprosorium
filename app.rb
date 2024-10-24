#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db
	@db = SQLite3::Database.new 'leprosorium.db'
	@db.results_as_hash = true
	#return @db
end

#before вызывается каждый раз при перезагрузке
#любой страницы 
before do
	#инциализация БД
	init_db
end

#configure вызывается каждый раз при конфигурации приложения:
#когда изменился код программы и пеезагрузилась страница

configure do
	#инциализация БД
	init_db
	#создает таблицу если таблица не существует
	@db.execute 'CREATE TABLE IF NOT EXISTS "Posts" 
	(
		"id"	INTEGER PRIMARY KEY AUTOINCREMENT,
		"created_date"	DATE,
		"content"	TEXT
	)'

end

get '/' do
	#выбираем список постов из БД

	@results = @db.execute 'select * from Posts order by id desc'
	
	erb :index			
end

get '/posts' do
	'Hello'
end

# обработчик post - запроса /new
# (браузер получает страницу с сервера)

get '/new' do
  erb :new
end

# обработчик post - запроса /new
# (браузер отправляет данные на сервер)

post '/new' do
	#получаем переменную из post-запроса
 	content = params[:content]

 	if content.length <= 0
 		@error = 'Type post text'
 		return erb :new
 	end

 	#сохранение данных БД
 	@db.execute 'insert into Posts (content, created_date) values (?, datetime())', [content]

 	#перенаправление на главную страницу
 	redirect to '/'
 	
end