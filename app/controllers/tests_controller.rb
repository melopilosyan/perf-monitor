class TestsController < ApplicationController

  def index
    render_resource TestResult.by_url(params[:url])
  end

  def create
    criterium = TestCriterium.new test_params
    if criterium.save
      render_resource criterium.results.last, include_criteria: false
    else
      render json: { error: criterium.errors.full_messages.join('. ') }
    end
  end

  def last
    render_resource TestResult.by_url(params[:url]).last
  end

  private

  def test_params
    params.permit :url, :max_ttfb, :max_tti, :max_speed_index, :max_ttfp
  end

  def render_resource(resours, include_criteria: true)
    render json: resours, scope: include_criteria,
      scope_name: :include_criteria
  end
end
