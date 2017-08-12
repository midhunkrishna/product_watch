namespace :groups do
  task collect_changes: :environment do
    groups = Group.all
    Batch::GroupChangeCollectionWorker.execute(groups)
  end
end
