require 'grape-swagger'
module API
  module V1
    class Base < Grape::API
      version 'v1', :using => :path
      formatter :json, Grape::Formatter::Jbuilder
      helpers API::Auth, ApplicationHelper
      rescue_from TT::Error do |e|
        error!({ error: true, code: TT::Error::CODE_MAP[e.name.to_sym], message: e.message }, 400)
      end

      before do
        header['Access-Control-Allow-Origin'] = '*'
        header['Access-Control-Request-Method'] = 'OPTIONS, GET, POST'
        header['Access-Control-Allow-Headers'] = 'Content-Type, Authorization'
        header['Access-Control-Expose-Headers'] = 'x-total-pages, x-total, x-page, x-per-page, x-next-page, x-prev-page, x-offset'
        # doorkeeper_authorize!
      end
      helpers do
        def locale_message(msg, hash = {})
          language = request.headers["X-Language"].present? ? request.headers["X-Language"] : "en"
          hash = hash.merge({locale: language})
          ActionController::Base.helpers.t(msg, hash)
        end

        def success data=nil, message=nil
          { error: false, message: message ? message : locale_message('api.common.successful'), data: data }
        end
      end

      mount API::V1::User
      mount API::V1::Post
      mount API::V1::Category

      add_swagger_documentation base_path: "/api",
                                api_version: 'v1',
                                hide_documentation_path: true,
                                info: {
                                    title: "cms Api",
                                }
    end
  end
end