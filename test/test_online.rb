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
  def test_when_online
    WebMock.disable_net_connect!
    stub_request(:get, 'http://www.google.com/').to_return(body: '')
    assert_predicate(self, :online?)
  end

  def test_when_offline
    WebMock.disable_net_connect!
    stub_request(:get, 'http://www.google.com/').to_raise(Socket::ResolutionError, 'failure')
    refute_predicate(self, :online?)
  end
end
