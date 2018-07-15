class ApplicationController < ActionController::API
  rescue_from ActionController::ParameterMissing do |error|
    render(
      json: { error: 'bad request', status: 400, message: error.message },
      status: :bad_request
    )
  end
end
