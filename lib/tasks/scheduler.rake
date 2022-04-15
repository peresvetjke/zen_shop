desc "This task is called by the Heroku scheduler add-on"
task :update_fx_rates => :environment do
  Money::ConversionRatesRetriever.new.call
end