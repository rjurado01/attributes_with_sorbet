require 'filewatcher'

Filewatcher.new(['**/*.rb']).watch do |_changes|
  `bundle exec tapioca dsl`
end
