module Sitemapable
  extend ActiveSupport::Concern

  included do
    after_save :refresh_sitemap

    def refresh_sitemap
      UpdateSitemap.perform_async
    end
  end
end
