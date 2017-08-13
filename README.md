# Product Watch

![Build status](https://travis-ci.org/midhunkrishna/product_watch.svg?branch=master)

## Adding Groups
- A group can have multiple competitors for a group-product (has-many belongs-to)
- Uses [cocoon gem](https://github.com/nathanvda/cocoon) for nested form generation
- Uses either ASIN or amazon product page url for pulling in details from amazon server

## Change collector

Application can be accessed at https://product-watch.herokuapp.com/ and that days changes are viewable at http://product-watch.herokuapp.com/product_changes?date=mm-dd-yyyy

- A scheduler, preferably CRON like, in heroku deployment, [heroku-scheduler](https://elements.heroku.com/addons/scheduler) is used to run a [simple rake task](https://github.com/midhunkrishna/product_watch/blob/master/lib/tasks/collect_changes.rake) which spawns Sidekiq::Batch worker spawning a batch for each group. 
- [Batch Worker](https://github.com/midhunkrishna/product_watch/blob/master/app/workers/batch/group_change_collection_worker.rb) takes one group per batch and each competitor as a job inside the batch. It pulls details from amamzon for each product using [ProductDetailsChangeCollectionService](https://github.com/midhunkrishna/product_watch/blob/master/app/services/product_details_change_collection_service.rb) and if changes are present (detected using ActiveModel dirty tracking), these changes are stored in ProductChange model. These records are pulled according to its created_at field to be shown as changes at http://product-watch.herokuapp.com/product_changes?date=mm-dd-yyyy
- ProductDetailsChangeCollectionService inturn uses [ProductDetailCollectionService](https://github.com/midhunkrishna/product_watch/blob/master/app/services/product_detail_collection_service.rb). Internally the service relies on [ruby mechanize](https://github.com/sparklemotion/mechanize) library for retrieving all data related to the product except inventory. 
- Inventory is collected using [Watir](https://github.com/watir/watir) with chrome-webdriver since this process involves javascript interaction. 
