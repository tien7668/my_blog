GrapeSwaggerRails.options.app_name = 'CMS'
GrapeSwaggerRails.options.api_auth     = 'bearer'
GrapeSwaggerRails.options.api_key_name = 'Authorization'
GrapeSwaggerRails.options.api_key_type = 'header'
GrapeSwaggerRails.options.url      = '/api/v1/swagger_doc'
GrapeSwaggerRails.options.before_action do
  GrapeSwaggerRails.options.app_url = request.protocol + request.host_with_port
end