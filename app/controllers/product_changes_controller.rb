class ProductChangesController < ApplicationController

  def index
    begin
      if params[:date].present?
        date = Date.strptime(params[:date], ::ChangeNotifierService::DATE_FORMAT)
        render 'index', locals: locals_data(changes(date), [])
      else
        date = Time.zone.now.strftime(::ChangeNotifierService::DATE_FORMAT)
        redirect_to product_changes_path(date: date.to_s)
      end

    rescue ArgumentError
      render 'index', locals: locals_data([], "Incorrect date format. Please provide date formated in mm-dd-yyyy")
    end
  end

  private

  def changes(date)
    ProductChange
      .where("created_at >= ? AND created_at < ?", date.beginning_of_day, date.end_of_day)
      .includes(:group, :competitor)
  end

  def locals_data(changes, errors)
    {
      changes: changes,
      errors: Array.wrap(errors)
    }
  end
end
