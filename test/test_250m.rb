require 'test/unit'
require 'test_helper.rb'

require 'ruby_mapscript'


class Test250mResolution < Test::Unit::TestCase

  include Mapscript

  def get_asc_file
    TestHelper.fixture_path('sample_ascii_grid.asc')
  end

  def get_map_obj
    map_file_path = TestHelper.fixture_path('test.map')
    map = MapObj.new(map_file_path)
  end

  def test_true_is_true
    assert_equal true, true, "true should be true"
  end

  def test_render_time_for_250m
    map = get_map_obj
    map.setExtent(115, -50, 160, -10)
    map.setSize(1024,1024)

    layer = map.layers.first
    layer.data = get_asc_file
    mapimage = map.draw

    FileUtils.mkdir_p(File.join(TestHelper.path_to_test_dir, 'outputs'))
    mapimage.save(File.join(TestHelper.path_to_test_dir, 'outputs', 'test.png'))
  end

end

=begin
    layer_hash = {
      name: "test file",
      renderable_file: get_asc_file
    }
    layer_x = Layer.new(layer_hash)
    assert layer_x.save

    map_file_path = File.join(Rails.root, 'lib', 'assets', 'test.map')
    map = Mapscript::MapObj.new(map_file_path)
    map.setExtent(115, -50, 160, -10)
    map.setSize(1024,1024)

    layer = map.layers.first
    layer.data = layer_x.renderable_file.path
    mapimage = map.draw

    FileUtils.mkdir_p(File.join(Rails.root, 'test', 'outputs'))
    mapimage.save(File.join(Rails.root, 'test', 'outputs', 'test.png'))
  end

  test "Should be able to generate layer image from renderable_file attachment with wms request params" do
    layer_hash = {
      name: "test file",
      renderable_file: get_asc_file
    }
    layer_x = Layer.new(layer_hash)
    assert layer_x.save

    #map = Mapscript::MapObj.new('test.map')
    map_file_path = File.join(Rails.root, 'lib', 'assets', 'test.map')
    map = Mapscript::MapObj.new(map_file_path)

    wms_request = Mapscript::OWSRequest.new()
    wms_request.setParameter("MODE", "map")
    wms_request.setParameter("SRS", "EPSG:4326")
    wms_request.setParameter("FORMAT", "image/png")
    wms_request.setParameter("SERVICE", "WMS")
    wms_request.setParameter("REQUEST", "GetMap")
    wms_request.setParameter("WIDTH", "100")
    wms_request.setParameter("HEIGHT", "100")
    wms_request.setParameter("BBOX", "115,-50,160,-10")
    wms_request.setParameter("LAYERS", "DEFAULT")
    map.loadOWSParameters(wms_request)

    layer = map.layers.first
    layer.data = layer_x.renderable_file.path
    mapimage = map.draw

    FileUtils.mkdir_p(File.join(Rails.root, 'test', 'outputs'))
    mapimage.save(File.join(Rails.root, 'test', 'outputs', 'test_with_wms_req_params.png'))
  end
=end
