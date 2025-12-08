# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2024-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'net/http'
require 'socket'
require 'timeout'
require 'uri'

# Checks whether we are online now.
#
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2024-2025 Yegor Bugayenko
# License:: MIT
module Kernel
  # Cache for online connectivity checks
  module OnlineOrOffline
    class << self
      attr_accessor :cache, :mutex
    end
    @cache = {}
    @mutex = Mutex.new
  end

  # Checks whether the system has an active internet connection by attempting
  # to connect to a specified URI.
  #
  # This method performs an HTTP GET request to verify connectivity. It's useful
  # for checking internet availability before performing network-dependent operations
  # or for implementing offline-mode functionality in applications.
  #
  # @param uri [String] the URI to check connectivity against (default: 'https://www.google.com/generate_204')
  # @param ttl [Integer] time-to-live for cached results in seconds (default: 300 seconds = 5 minutes)
  # @return [Boolean] true if the URI is reachable and returns HTTP success, false otherwise
  #
  # @example Basic usage - check internet connectivity
  #   if online?
  #     puts "Connected to the internet!"
  #   else
  #     puts "No internet connection available"
  #   end
  #
  # @example Check connectivity to a specific service
  #   if online?('https://api.github.com')
  #     # Proceed with GitHub API calls
  #   else
  #     # Use cached data or show offline message
  #   end
  #
  # @example Check with custom cache TTL (10 minutes)
  #   if online?(ttl: 600)
  #     # Will use cached result for 10 minutes
  #   end
  #
  # @example Use in Minitest tests
  #   require 'minitest/autorun'
  #   require 'online'
  #
  #   class MyServiceTest < Minitest::Test
  #     def test_api_call_when_online
  #       skip("No internet connection") unless online?
  #       # Test code that requires internet
  #     end
  #
  #     def test_offline_fallback
  #       unless online?
  #         assert_equal cached_data, service.fetch_data
  #       end
  #     end
  #   end
  #
  # @example Conditional feature loading
  #   class WeatherWidget
  #     def display
  #       if online?('https://api.weather.com')
  #         show_live_weather
  #       else
  #         show_cached_weather
  #       end
  #     end
  #   end
  #
  # @note The method has a 10-second timeout to prevent hanging on slow connections
  # @note Returns false for any network-related errors including timeouts, DNS failures,
  #   and unreachable hosts
  # @note Results are cached with a default TTL of 5 minutes to reduce network requests
  def online?(uri: 'https://www.google.com/generate_204', ttl: 300)
    raise 'The URI is nil' if uri.nil?
    raise 'The TTL is nil' if ttl.nil?
    key = uri.to_s
    OnlineOrOffline.mutex.synchronize do
      entry = OnlineOrOffline.cache[key]
      return entry[:status] if entry && (Time.now - entry[:time]) < ttl
      status =
        Timeout.timeout(10) do
          Net::HTTP.get_response(URI(uri)).is_a?(Net::HTTPSuccess)
        rescue \
          Timeout::Error, Timeout::ExitException, Socket::ResolutionError,
          Errno::EHOSTUNREACH, Errno::EINVAL, Errno::EADDRNOTAVAIL, Errno::EBADF
          false
        end
      OnlineOrOffline.cache[key] = { status: status, time: Time.now }
      status
    end
  end
end
