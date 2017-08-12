class InventoryRetrievalService

  MAX_ITEM_CART_QUANTITY = '999'

  def initialize(url, asin)
    @product_page = url
    @asin = asin
  end

  def process
    return "999+" if Rails.env.test?
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
      rescue Mechanize::ResponseCodeError => ex
         if ex.response_code == '503'
           retry
         end
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
    "#{inventory_information}".strip[/\d+/].presence || "999+"
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
    browser.span(css: "div[data-asin='#{@asin}'] span[data-action='a-dropdown-button']").click
  end

  def confirm_product_addition_to_cart
    browser.input(id: "hlb-view-cart-announce").click
  end

  def add_item_to_cart
    if size_selection_exists?
      select_size
    end
    browser.input(id: "add-to-cart-button").when_present.click
  end

  def size_selection_exists?
    browser.select(id: "native_dropdown_selected_size_name").exists?
  end

  def select_size
    browser.execute_script("jQuery('#add-to-cart-button').remove()")

    element = browser.select(id: "native_dropdown_selected_size_name")
    option_of_asin = element.options.detect{|op| op.value.include?(@asin)}
    element.click

    element.select_value(option_of_asin.value)
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
