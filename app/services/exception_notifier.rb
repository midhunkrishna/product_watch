class ExceptionNotifier
  def self.notify(exception)
    logger = Rails.logger
    logger.warn(exception.message)
    exception.backtrace.each { |line| logger.error line }
  end
end
