require 'babel/transpiler'
require 'sprockets'
require 'sprockets2/es6/version'
require 'tilt'

module Sprockets2
  module ES6
    class Processor < Tilt::Template
      self.default_mime_type = 'application/javascript'

      # Configuration options that are passed to the Babel transpiler. See
      # https://developit.github.io/babel-legacy-docs//docs/usage/options/
      # for possible options that can be set.
      #
      # Since Sprockets 2 expects a class reference when adding the engine,
      # you'll need to create a subclass to override the configuration.
      def configuration
        {}
      end

      def prepare
        # Noop. Tilt expects this to be overridden, even if it doesn't do anything.
      end

      def evaluate(context, locals, &block)
        opts = transformation_options(context)
        result = transform(data, opts)
        "#{result['code']}\n\n"
      end

      def transform(data, opts)
        Babel::Transpiler.transform(data, opts)
      end

      def transformation_options(context)
        opts = configuration.merge({
          'filename' => file,
          'filenameRelative' => split_subpath(context.root_path, file),
          'sourceRoot' => context.root_path
        })

        if opts['moduleIds'] && opts['moduleRoot']
          opts['moduleId'] ||= File.join(opts['moduleRoot'], context.logical_path)
        elsif opts['moduleIds']
          opts['moduleId'] ||= context.logical_path
        end

        opts
      end

      private

      def load_path(logical_path, pathname)
        pathname.to_s.replace(logical_path)
      end

      def split_subpath(path, subpath)
        return "" if path == subpath
        path = File.join(path, '')
        if subpath.start_with?(path)
          subpath[path.length..-1]
        else
          nil
        end
      end
    end
  end
end
