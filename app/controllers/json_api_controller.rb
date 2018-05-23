class JsonApiController < ApplicationController
  include JSONAPI::Utils
  include AdminAuthorizable
end