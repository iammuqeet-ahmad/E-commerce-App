module Api
  module V1
    class ApiController < ActionController::Base
      def exception_handler
        yield
        rescue ActiveRecord::RecordNotFound
        render json: { message: 'Record not found' }, status: 404
      end
    end
  end
end
