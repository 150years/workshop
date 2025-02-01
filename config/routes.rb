# frozen_string_literal: true
Rails.application.routes.draw do
  get 'up' => 'rails/health#show', as: :rails_health_check

  root 'dashboard#index'

  devise_for :users



  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end

# == Route Map
#
#                            Prefix Verb   URI Pattern                                                                                       Controller#Action
#                                          /assets                                                                                           Propshaft::Server
#                rails_health_check GET    /up(.:format)                                                                                     rails/health#show
#                              root GET    /                                                                                                 dashboard#index
#                  new_user_session GET    /users/sign_in(.:format)                                                                          devise/sessions#new
#                      user_session POST   /users/sign_in(.:format)                                                                          devise/sessions#create
#              destroy_user_session DELETE /users/sign_out(.:format)                                                                         devise/sessions#destroy
#                 new_user_password GET    /users/password/new(.:format)                                                                     devise/passwords#new
#                edit_user_password GET    /users/password/edit(.:format)                                                                    devise/passwords#edit
#                     user_password PATCH  /users/password(.:format)                                                                         devise/passwords#update
#                                   PUT    /users/password(.:format)                                                                         devise/passwords#update
#                                   POST   /users/password(.:format)                                                                         devise/passwords#create
#  turbo_recede_historical_location GET    /recede_historical_location(.:format)                                                             turbo/native/navigation#recede
#  turbo_resume_historical_location GET    /resume_historical_location(.:format)                                                             turbo/native/navigation#resume
# turbo_refresh_historical_location GET    /refresh_historical_location(.:format)                                                            turbo/native/navigation#refresh
#                rails_service_blob GET    /rails/active_storage/blobs/redirect/:signed_id/*filename(.:format)                               active_storage/blobs/redirect#show
#          rails_service_blob_proxy GET    /rails/active_storage/blobs/proxy/:signed_id/*filename(.:format)                                  active_storage/blobs/proxy#show
#                                   GET    /rails/active_storage/blobs/:signed_id/*filename(.:format)                                        active_storage/blobs/redirect#show
#         rails_blob_representation GET    /rails/active_storage/representations/redirect/:signed_blob_id/:variation_key/*filename(.:format) active_storage/representations/redirect#show
#   rails_blob_representation_proxy GET    /rails/active_storage/representations/proxy/:signed_blob_id/:variation_key/*filename(.:format)    active_storage/representations/proxy#show
#                                   GET    /rails/active_storage/representations/:signed_blob_id/:variation_key/*filename(.:format)          active_storage/representations/redirect#show
#                rails_disk_service GET    /rails/active_storage/disk/:encoded_key/*filename(.:format)                                       active_storage/disk#show
#         update_rails_disk_service PUT    /rails/active_storage/disk/:encoded_token(.:format)                                               active_storage/disk#update
#              rails_direct_uploads POST   /rails/active_storage/direct_uploads(.:format)                                                    active_storage/direct_uploads#create
