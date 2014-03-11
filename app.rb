require 'bundler/setup'

require 'sinatra'
require 'slim'
require 'digest/md5'

configure :development do
  require 'sinatra/reloader'
  require 'pry'
end

configure do
  set :uploaded_path, File.join(settings.public_folder, 'uploaded_files')
end

get '/' do

  # file entries excluded dotfiles
  files = Dir.entries(settings.uploaded_path).select! { |filename| filename =~ /^[^\.]/}

  @entries = []

  files.each do |filename|
    @entries << {
      name: filename,
      url: "/files/#{filename}"
    }
  end

  slim :index
end

post '/files' do
  # TODO
  # - ファイルの保存に失敗した場合の例外処理
  # - バリデーション

  data = params[:uploaded_file][:tempfile].read
  filename = Digest::MD5.hexdigest(data)
  ext = File.extname(params[:uploaded_file][:filename])
  path = File.join(settings.uploaded_path, "#{filename}#{ext}")
  open(path, 'w') { |io| io.write(data) }

  redirect "/files/#{filename}#{ext}"
end

get '/files/:id' do
  # TODO
  # - ファイルが存在しない場合 404 を返すようにする

  @file = {
    name: params[:id],
    path: "/uploaded_files/#{params[:id]}",
  }

  slim :show
end

get '/files/:id/content' do
  # TODO
  # - ファイルが存在しない場合 404 を返す

  send_file File.join(settings.uploaded_path, params[:id]), disposition: :attachment
end

delete '/files/:id' do
  # TODO
  # - 削除に失敗した場合の例外処理
  # - ファイルが存在しない場合 404 を返すようにする
  # - 「削除しました」や「削除に失敗しました」のようなメッセージを表示する

  File.delete(File.join(settings.uploaded_path, params[:id]))

  redirect '/'
end

__END__
