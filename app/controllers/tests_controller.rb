class TestsController < ApplicationController
  def index
    render_result TestResult.by_url params[:url]
  end

  def create
    result = TestCriterium.run_test test_params

    if result.error.present?
      render json: { error: result.error }
    else
      render_result result, include_criteria: false
    end
  end

  def last
    render_result TestResult.by_url(params[:url]).last
  end

  private

  def test_params
    params.permit :url, :max_ttfb, :max_tti, :max_speed_index,
      :max_ttfp, :rerun_in_mins
  end

  def render_result(result, include_criteria: true)
    render json: result, scope: include_criteria, scope_name: :include_criteria
  end
end
