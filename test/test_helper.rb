require 'logger'

module TestHelper

  @@logger = Logger.new(STDOUT)
  @@logger.level = Logger::INFO

  def TestHelper::path_to_test_dir
    path_to_test_dir = File.dirname(__FILE__)
  end

  def TestHelper::logger
    @@logger
  end

  def TestHelper::fixture_path(fixture_name)
    File.join(path_to_test_dir, 'fixtures', fixture_name)
  end

  def TestHelper::convert_ascii_to_geotiff(ascii_path)
    dest_file = Tempfile.new('geotiff')
    dest_file.close()

    `gdal_translate -of GTiff #{ascii_path} #{dest_file.path}`


    dest_file
  end

end
