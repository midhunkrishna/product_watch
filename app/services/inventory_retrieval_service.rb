class InventoryRetrievalService

  MAX_ITEM_CART_QUANTITY = '999'

  def initialize(url, asin)
    @product_page = url
    @asin = asin
  end

  def process
    Headless.ly do
      go_to_product_page

      begin
        add_item_to_cart
        confirm_product_addition_to_cart
        click_on_quantity_drop_down
        select_10_plus_option
        enter_predefined_quantity_to_quantity_field
        update_item_quantity
        scrape_inventory_information
       rescue Watir::Exception::UnknownObjectException => ex
         ExceptionNotifier.notify(ex)
      ensure
        close_browser; nil
      end
    end
  end

  private

  def scrape_inventory_information
    inventory_information = browser.div(css: "div[data-asin='#{@asin}'] .sc-quantity-update-message .a-alert-content").when_present.text()
    "#{inventory_information}".strip[/\d+/].to_i
  end

  def update_item_quantity
    browser.link(css: "div[data-asin='#{@asin}'] a[data-action='update']").click
  end

  def enter_predefined_quantity_to_quantity_field
    field = browser.text_field(css: "div[data-asin='#{@asin}'] input[name='quantityBox']")
    field.send_keys(:backspace)
    field.send_keys(MAX_ITEM_CART_QUANTITY)
  end

  def select_10_plus_option
    browser.link(id: 'dropdown1_9').click
  end

  def click_on_quantity_drop_down
    browser.span(css: "div[data-asin='#{@asin}'] .sc-action-links span[data-action='a-dropdown-button']").click
  end

  def confirm_product_addition_to_cart
    browser.input(id: "hlb-view-cart-announce").click
  end

  def add_item_to_cart
    browser.input(id: "add-to-cart-button").click
  end

  def go_to_product_page
    browser.goto @product_page
  end

  def browser
    @_browser ||= Watir::Browser.new :chrome
  end

  def close_browser
    browser.close
  end
end
