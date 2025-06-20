# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2024-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'webmock/minitest'
require_relative 'test__helper'
require_relative '../lib/online'

# Test.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2024-2025 Yegor Bugayenko
# License:: MIT
class TestOnline < Minitest::Test
  def test_basic_check
    WebMock.enable_net_connect!
    assert(online?)
  end
end
