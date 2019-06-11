#!/usr/bin/env rackup

require_relative 'config/environment'

require 'rack/freeze'

if RACK_ENV == :production
	# Handle exceptions in production with a error page and send an email notification:
	use Utopia::Exceptions::Handler
	use Utopia::Exceptions::Mailer
else
	# We want to propate exceptions up when running tests:
	use Rack::ShowExceptions unless RACK_ENV == :test
end

use Utopia::Static, root: 'public'

use Utopia::Redirection::Rewrite,
	'/' => '/welcome/index'

use Utopia::Redirection::DirectoryIndex

use Utopia::Redirection::Errors,
	404 => '/errors/file-not-found'

use Utopia::Controller

use Utopia::Static

# Serve dynamic content
use Utopia::Content

run lambda { |env| [404, {}, []] }
