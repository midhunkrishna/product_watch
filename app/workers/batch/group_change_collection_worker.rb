class Batch::GroupChangeCollectionWorker
  include Sidekiq::Worker

  def perform(group_id)
    group = Group.find(group_id)

    group.competitors.each do |product|
      collection_service = ProductDetailsChangeCollectionService.new(product)
      collection_service.process
    end
  end

  def on_complete(status, options)
    ChangeNotifierService.process
  end

  def self.execute(groups)
    batch = Sidekiq::Batch.new
    batch.description = "Batch started for groups: #{groups.map(&:id).join(", ")}"
    batch.on(:complete, "Batch::GroupChangeCollectionWorker")

    batch.jobs do
      groups.map(&:id).each do |group_id|
        self.perform_async(group_id)
      end
    end
  end
end
