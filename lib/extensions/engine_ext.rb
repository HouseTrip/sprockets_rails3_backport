module Rails
  class Engine < Railtie
    class Configuration < ::Rails::Railtie::Configuration
      def paths_with_assets
        @paths ||= begin
          paths = paths_without_assets
          paths.app.assets          "app/assets",          :glob => "*"
          paths.lib.assets          "lib/assets",          :glob => "*"
          paths.vendor              "vendor",              :load_path => true
          paths.vendor.assets       "vendor/assets",       :glob => "*"
          paths
        end
      end

      alias_method_chain :paths, :assets
    end

    initializer :append_assets_path, :group => :all do |app|
      app.config.assets.paths.unshift(*paths.vendor.assets.paths)
      asset_paths = paths.app.assets.paths.reject { |x| x.to_s.scan(/stylesheets/).size > 0 }
      asset_paths << Rails.root.join("public", "assets")
      app.config.assets.paths.unshift(*asset_paths)
    end
  end
end
