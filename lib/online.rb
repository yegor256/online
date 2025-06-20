# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2024-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'net/http'
require 'timeout'
require 'uri'

# Checks whether we are online now.
#
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2024-2025 Yegor Bugayenko
# License:: MIT
module Kernel
  # Checks whether this URI is alive (HTTP status is 200).
  def online?(uri = 'http://www.google.com')
    Timeout.timeout(10) do
      Net::HTTP.get_response(URI(uri)).is_a?(Net::HTTPSuccess)
      true
    rescue \
      Timeout::Error, Timeout::ExitException, Socket::ResolutionError,
      Errno::EHOSTUNREACH, Errno::EINVAL, Errno::EADDRNOTAVAIL
      false
    end
  end
end
