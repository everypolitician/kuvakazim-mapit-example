require 'bundler'
Bundler.require

class SinatraPage < Jekyll::Page
  def initialize(site, base, dir, name)
    @site = site
    @base = base
    @dir  = dir
    @name = name

    process(name)
    self.content = File.read('views/index.html')
    self.data = { 'layout' => 'default' }

    data.default_proc = proc do |_, key|
      site.frontmatter_defaults.find(File.join(dir, name), type, key)
    end

    Jekyll::Hooks.trigger :pages, :post_init, self
  end
end

# Setup Jekyll and create a site object for rendering purposes
Jekyll::PluginManager.require_from_bundler
site = Jekyll::Site.new(Jekyll.configuration(source: File.dirname(__FILE__) + '/kuvakazim'))
site.reset
site.read

get '/' do
  payload = site.site_payload
  page = SinatraPage.new(site, '', 'views', 'index.html')
  Jekyll::Renderer.new(site, page, payload).run
end
