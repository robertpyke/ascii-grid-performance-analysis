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
      file.write(gz.read)
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
    mapimage.save(File.join(TestHelper.path_to_test_dir, 'outputs', 'test.png'))
    end_save_file_t = Time.now
    logger.info("250m save file end")
    logger.info("250m save file took: #{end_save_file_t - start_save_file_t}s")

    end_t = Time.now
    logger.info("250m test end")
    logger.info("250m test took: #{end_t - start_t}s")

    asc_file.unlink
  end

end
