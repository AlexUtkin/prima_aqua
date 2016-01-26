PrimaAqua::Application.load_tasks

class UpdateSitemap
  include Sidekiq::Worker
  sidekiq_options retry: 5

  def perform(*args)
    Rake::Task['sitemap:clean'].execute
    Rake::Task['sitemap:create'].execute
  end
end
