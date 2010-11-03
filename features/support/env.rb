Bundler.require

require "aruba"

Before do
  schemes_origin_dir = File.join(%w(features fixtures schemes))
  schemes_dir = File.join(dirs.first, schemes_origin_dir)
  FileUtils.mkdir_p(schemes_dir)
  FileUtils.cp(Dir.glob(File.join(schemes_origin_dir, "*")), schemes_dir)
end
