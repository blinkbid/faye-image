require 'bundler/setup'
require 'faye'

# Faye extension
class FayeExtension
  def incoming(message, callback)
    return handle_eror(message, callback) unless message_authenticated?(message)

    if batch_publish?(message)
      batch_incoming(message, callback)
    else
      single_incoming(message, callback)
    end
  end

  def batch_incoming(message, callback)
    message['data'].each { |data| incoming(data, callback) }
  end

  def single_incoming(message, callback)
    callback.call(message)
  end

  def batch_publish?(message)
    message['channel'] == '/batch_publish'
  end

  # IMPORTANT: clear out the auth token so it is not leaked to the client
  def outgoing(message, callback)
    message['ext'] = {} if message['ext'] && message['ext']['auth_token']
    callback.call(message)
  end

  def handle_eror(message, callback)
    message['error'] = 'Invalid authentication token'
    callback.call(message)
  end

  def message_authenticated?(message)
    !(message['channel'] !~ %r{^/meta/} &&
        message['ext']['auth_token'] != ENV['FAYE_SECRET'])
  end
end

Faye::WebSocket.load_adapter('thin')
faye = Faye::RackAdapter.new(mount: '/faye', timeout: 25)
faye.add_extension(FayeExtension.new)
run faye
