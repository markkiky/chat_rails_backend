# frozen_string_literal: true

Rails.application.routes.draw do
  mount ActionCable.server => "/cable"
  scope :api, defaults: { format: :json } do
    devise_for :users, controllers: { sessions: :sessions },
                       path_names: { sign_in: :login }
    resource :user, only: [:show, :update]
  end
end
