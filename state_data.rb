require 'active_support/all'

class StateData
  attr_reader :state,
    :year, 
    :month, 
    :min_temp_rcp45,
    :max_temp_rcp45,
    :precipitation_rcp45,
    :min_temp_rcp85,
    :max_temp_rcp85,
    :precipitation_rcp85

  def initialize(
    state, year, month, 
    min_temp_rcp45, max_temp_rcp45, precipitation_rcp45,
    min_temp_rcp85, max_temp_rcp85, precipitation_rcp85)

    @state = state
    @year = year
    @month = month
    @min_temp_rcp45 = min_temp_rcp45
    @max_temp_rcp45 = max_temp_rcp45
    @precipitation_rcp45 = precipitation_rcp45
    @min_temp_rcp85 = min_temp_rcp85
    @max_temp_rcp85 = min_temp_rcp85
    @precipitation_rcp85 = precipitation_rcp85
  end
end
