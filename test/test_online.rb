# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2024-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require_relative 'test__helper'
require_relative '../lib/online'

# Test.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2024-2025 Yegor Bugayenko
# License:: MIT
class TestOnline < Minitest::Test
  def setup
    Kernel::OnlineOrOffline.cache = {}
  end

  def test_pings_live
    WebMock.enable_net_connect!
    assert(online? || !online?)
  end

  def test_pings_live_bad_address
    WebMock.enable_net_connect!
    uri = 'https://www.very-bad-domain-name-should-not-work-or-exist.bad'
    assert(online?(uri:) || !online?(uri:))
  end

  def test_pings_incorrect_uri
    WebMock.enable_net_connect!
    uri = 'this is not a valid URI'
    assert_raises(URI::InvalidURIError) { online?(uri:) }
  end

  def test_when_online
    WebMock.disable_net_connect!
    stub_request(:get, 'https://www.google.com/generate_204').to_return(body: '')
    assert_predicate(self, :online?)
  end

  def test_when_offline
    WebMock.disable_net_connect!
    stub_request(:get, 'https://www.google.com/generate_204').to_raise(Socket::ResolutionError, 'failure')
    refute_predicate(self, :online?)
  end

  def test_cache_returns_same_result
    WebMock.disable_net_connect!
    stub_request(:get, 'https://www.google.com/generate_204').to_return(body: '')
    assert_predicate(self, :online?)
    WebMock.reset!
    stub_request(:get, 'https://www.google.com/generate_204').to_raise(Socket::ResolutionError, 'failure')
    assert_predicate(self, :online?)
  end

  def test_cache_expires_after_ttl
    WebMock.disable_net_connect!
    stub_request(:get, 'https://www.google.com/generate_204').to_return(body: '')
    assert online?(ttl: 0)
    WebMock.reset!
    stub_request(:get, 'https://www.google.com/generate_204').to_raise(Socket::ResolutionError, 'failure')
    refute online?(ttl: 0)
  end

  def test_different_uris_cached_separately
    WebMock.disable_net_connect!
    stub_request(:get, 'http://www.google.com/').to_return(body: '')
    stub_request(:get, 'http://example.com/').to_raise(Socket::ResolutionError, 'failure')
    assert online?(uri: 'http://www.google.com')
    refute online?(uri: 'http://example.com')
  end

  def test_when_timeout
    WebMock.disable_net_connect!
    stub_request(:get, 'https://www.google.com/generate_204').to_timeout
    refute online?(timeout: 5)
  end
end
