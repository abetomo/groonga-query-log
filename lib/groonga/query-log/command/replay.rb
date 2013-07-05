# -*- coding: utf-8 -*-
#
# Copyright (C) 2013  Kouhei Sutou <kou@clear-code.com>
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

require "optparse"

require "groonga/query-log/replayer"

module Groonga
  module QueryLog
    module Command
      class Replay
        def initialize
          @options = Replayer::Options.new
        end

        def parse_command_line_options(arguments)
          create_parser.parse!(arguments)
        end

        def run(input)
          replayer = Replayer.new(@options)
          replayer.replay(input)
        end

        private
        def create_parser
          parser = OptionParser.new
          parser.banner += " QUERY_LOG"

          parser.separator("")
          parser.separator("Options:")

          parser.on("--host=HOST",
                    "Host name or IP address of groonga server",
                    "[#{@options.host}]") do |host|
            @options.host = host
          end

          parser.on("--port=PORT", Integer,
                    "Port number of groonga server",
                    "[#{@options.port}]") do |port|
            @options.port = port
          end

          available_protocols = [:gqtp, :http]
          available_protocols_label = "[#{available_protocols.join(', ')}]"
          parser.on("--protocol=PROTOCOL", available_protocols,
                    "Protocol of groonga server",
                    available_protocols_label) do |protocol|
            @options.protocol = protocol
          end

          parser.on("--n-clients=N", Integer,
                    "The max number of concurrency",
                    "[#{@options.n_clients}]") do |n_clients|
            @options.n_cilents = n_clients
          end

          parser.on("--disable-cache",
                    "Add 'cache=no' parameter to request",
                    "[#{@options.disable_cache?}]") do
            @options.disable_cache = true
          end

          parser.on("--output-requests=PATH",
                    "Output requests to PATH",
                    "[not output]") do |path|
            @options.requests_path = path
          end

          parser.on("--output-responses=PATH",
                    "Output responses to PATH",
                    "[not output]") do |path|
            @options.responses_path = path
          end
        end
      end
    end
  end
end
