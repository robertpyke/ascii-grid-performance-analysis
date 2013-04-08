require 'test/unit'
require 'test_helper.rb'

require 'ruby_mapscript'

require 'tempfile'
require 'zlib'

require 'gdal-ruby/ogr'

# OGR: OpenGIS Simple Features Reference Implementation

class TestGDALRuby < Test::Unit::TestCase

  def test_gdal_ogr_basic_can_create_point
    act_res = Gdal::Ogr.create_geometry_from_wkt('POINT (30 10)').export_to_json
    exp_res = %<{ "type": "Point", "coordinates": [ 30.0, 10.0 ] }>
   
    assert_equal(exp_res,act_res, "GDAL OGR should be able to create a point from wkt")
  end
end

