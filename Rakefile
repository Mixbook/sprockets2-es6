require "bundler/gem_tasks"

module Bundler
  # Override the gem helper to push to S3 instead of RubyGems
  class GemHelper
    def rubygem_push(path)
      raise("Run './release' instead in your terminal.")
    end

    protected

    # Overryde build_gem to output the gem to the pkg/gems directory
    def build_gem
      file_name = nil

      sh([*gem_command, "build", "-V", spec_path]) do
        file_name = File.basename(built_gem_path)
        SharedHelpers.filesystem_access(File.join(base, "pkg", "gems")) {|p| FileUtils.mkdir_p(p) }
        FileUtils.mv(built_gem_path, "pkg/gems")
        Bundler.ui.confirm "#{name} #{version} built to pkg/gems/#{file_name}."
      end

      File.join(base, "pkg", "gems", file_name)
    end

    def gem_command
      ENV["GEM_COMMAND"]&.shellsplit || ["gem"]
    end

    def sh(cmd, &block)
      out, status = sh_with_status(cmd, &block)
      unless status.success?
        cmd = cmd.shelljoin if cmd.respond_to?(:shelljoin)
        raise(out.empty? ? "Running `#{cmd}` failed. Run this command directly for more detailed output." : out)
      end
      out
    end

    def sh_with_status(cmd, &block)
      Bundler.ui.debug(cmd)
      SharedHelpers.chdir(base) do
        outbuf = IO.popen(cmd, :err => [:child, :out], &:read)
        status = $?
        block.call(outbuf) if status.success? && block
        [outbuf, status]
      end
    end
  end
end
