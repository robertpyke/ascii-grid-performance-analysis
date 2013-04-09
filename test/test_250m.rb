require 'test/unit'
require 'test_helper.rb'

require 'ruby_mapscript'

require 'tempfile'
require 'zlib'

class Test250mResolution < Test::Unit::TestCase

  include Mapscript

  def get_asc_file
    logger = TestHelper.logger

    gz_ascii_path = TestHelper.fixture_path('sample_250m_ascii_grid.asc.gz')
    file = Tempfile.new('sample_250m_ascii_grid')

    logger.info("gunzip starting")
    start_t = Time.now
    Zlib::GzipReader.open(gz_ascii_path) do |gz|
      IO.copy_stream(gz, file)
    end
    end_t = Time.now
    logger.info("gunzip ended")
    logger.info("gunzip took: #{end_t - start_t}s")

    file.close

    file

  end

  def get_map_obj
    map_file_path = TestHelper.fixture_path('test.map')
    map = MapObj.new(map_file_path)
  end

  def test_true_is_true
    assert_equal true, true, "true should be true"
  end

  def test_render_time_for_250m_via_geotiff_conversion
    logger = TestHelper.logger
    logger.info("250m geotiff test start")
    start_t = Time.now

    map = get_map_obj
    map.setExtent(115, -50, 160, -10)
    map.setSize(1024,1024)

    layer = map.layers.first
    asc_file = get_asc_file

    logger.info("250m ascii to geotiff conversion start")
    start_conv_t = Time.now
    geotiff_file = TestHelper::convert_ascii_to_geotiff(asc_file.path)
    end_conv_t = Time.now
    layer.data = geotiff_file.path
    logger.info("250m ascii to geotiff conversion end")
    logger.info("250m ascii to geotiff conversion took: #{end_conv_t - start_conv_t}s")

    logger.info("250m geotiff rendering start")
    start_render_t = Time.now
    mapimage = map.draw
    end_render_t = Time.now
    logger.info("250m geotiff rendering end")
    logger.info("250m geotiff rendering took: #{end_render_t - start_render_t}s")

    FileUtils.mkdir_p(File.join(TestHelper.path_to_test_dir, 'outputs'))
    logger.info("250m geotiff save file start")
    start_save_file_t = Time.now
    mapimage.save(File.join(TestHelper.path_to_test_dir, 'outputs', 'test_250m_geotiff_out.png'))
    end_save_file_t = Time.now
    logger.info("250m geotiff save file end")
    logger.info("250m geotiff save file took: #{end_save_file_t - start_save_file_t}s")

    end_t = Time.now
    logger.info("250m geotiff test end")
    logger.info("250m geotiff test took: #{end_t - start_t}s")

    asc_file.unlink
    geotiff_file.unlink
  end

  def test_render_time_for_250m
    logger = TestHelper.logger
    logger.info("250m test start")
    start_t = Time.now

    map = get_map_obj
    map.setExtent(115, -50, 160, -10)
    map.setSize(1024,1024)

    layer = map.layers.first
    asc_file = get_asc_file
    layer.data = asc_file.path
    logger.info("250m rendering start")
    start_render_t = Time.now
    mapimage = map.draw
    end_render_t = Time.now
    logger.info("250m rendering end")
    logger.info("250m rendering took: #{end_render_t - start_render_t}s")

    FileUtils.mkdir_p(File.join(TestHelper.path_to_test_dir, 'outputs'))
    logger.info("250m save file start")
    start_save_file_t = Time.now
    mapimage.save(File.join(TestHelper.path_to_test_dir, 'outputs', 'test_250m_out.png'))
    end_save_file_t = Time.now
    logger.info("250m save file end")
    logger.info("250m save file took: #{end_save_file_t - start_save_file_t}s")

    end_t = Time.now
    logger.info("250m test end")
    logger.info("250m test took: #{end_t - start_t}s")

    asc_file.unlink
  end


end
