require 'bundler'
Bundler.require

class SinatraPage < Jekyll::Page
  def initialize(site, base, dir, name, content)
    @site = site
    @base = base
    @dir  = dir
    @name = name

    process(name)
    self.content = content
    self.data = { 'layout' => 'default', 'disable_breadcrumbs' => true }

    data.default_proc = proc do |_, key|
      site.frontmatter_defaults.find(File.join(dir, name), type, key)
    end

    Jekyll::Hooks.trigger :pages, :post_init, self
  end
end

configure do
  # Setup Jekyll and create a site object for rendering purposes
  Jekyll::PluginManager.require_from_bundler
  set :site, Jekyll::Site.new(Jekyll.configuration(source: File.dirname(__FILE__) + '/kuvakazim'))
  settings.site.reset
  settings.site.read
end

helpers do
  def site
    settings.site
  end

  def payload
    @payload ||= site.site_payload
  end

  def render_into_jekyll_layout(content)
    page = SinatraPage.new(site, site.source, 'sinatra', 'index.html', content)
    Jekyll::Renderer.new(site, page, payload).run
  end
end

get '/' do
  if params[:postcode]
    @postcode = params[:postcode]
    url = "http://mapit.mysociety.org/postcode/#{URI.encode_www_form_component(@postcode)}"
    response = JSON.parse(open(url).read, symbolize_names: true)
    @areas = response[:areas]
  end
  render_into_jekyll_layout erb(:index)
end
