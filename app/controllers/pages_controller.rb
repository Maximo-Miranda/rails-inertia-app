class PagesController < ApplicationController
  def vuetify_test
    render inertia: 'VuetifyTest'
  end
end
