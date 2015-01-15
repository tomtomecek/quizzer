require 'paratrooper'

namespace :deploy do
  desc 'Deploying application to staging environment'
  task :staging do
    deployment = Paratrooper::Deploy.new('squizzer', tag: 'staging')

    deployment.deploy
  end
  
  desc 'Deploying application to production environment'
  task :production do
    deployment = Paratrooper::Deploy.new('tl-quizzer') do |deploy|
      deploy.tag       = 'production'
      deploy.match_tag = 'staging'
    end

    deployment.deploy
  end
end