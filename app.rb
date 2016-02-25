require 'bundler'
Bundler.require

configure do
  set :jekyll_site_path, 'kuvakazim'
end

get '/' do
  begin
    if params[:postcode] && params[:postcode] != ''
      @postcode = params[:postcode]
      url = "http://mapit.mysociety.org/postcode/#{URI.encode_www_form_component(@postcode)}"
      response = JSON.parse(open(url).read, symbolize_names: true)
      @areas = response[:areas]
    end
  rescue OpenURI::HTTPError => e
    @error = "Unknown postcode"
  end
  render_into_jekyll_layout erb(:index)
end

get '/area/:area_id' do
  url = "http://mapit.mysociety.org/area/#{params[:area_id]}"
  @area = JSON.parse(open(url).read, symbolize_names: true)
  render_into_jekyll_layout erb(:area)
end
