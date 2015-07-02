require 'json'

module LicenseFinder
  class GoWorkspace < PackageManager
    def current_packages
      go_output.map do |package|
        package_name = package['ImportPath'].gsub(project_path.to_s, '')[1..-1]
        GoPackage.new(package, logger: logger, package_name: package_name, workspace_root: project_path)
      end
    end

    def package_path
      project_path.join('.envrc')
    end

    private

    def go_output
      cmd_text = `cd #{project_path}; go list -f "{{.ImportPath}} " ./...`
      paths = cmd_text.gsub(/\s{2,}/, ",").split(",")
      paths.map do |path|
        {
          'ImportPath' => path[1..-1],
          'Rev' => 'unknown'
        }
      end
    end
  end
end
