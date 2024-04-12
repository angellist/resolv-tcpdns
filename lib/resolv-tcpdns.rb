# frozen_string_literal: true

require 'resolv'

class Resolv::TcpDNS < Resolv::DNS
  # NOTE (k1): This is a version of the fetch_resource method found in https://github.com/ruby/ruby/blob/master/lib/resolv.rb without UDP request logic.
  def fetch_resource(name, typeclass)
    lazy_initialize
    senders = {}
    requester = nil
    begin
      @config.resolv(name) {|candidate, tout, nameserver, port|
        requester ||= make_tcp_requester(nameserver, port)
        msg = Message.new
        msg.rd = 1
        msg.add_question(candidate, typeclass)
        unless sender = senders[[candidate, nameserver, port]]
          sender = requester.sender(msg, candidate, nameserver, port)
          next if !sender
          senders[[candidate, nameserver, port]] = sender
        end
        reply, reply_name = requester.request(sender, tout)
        case reply.rcode
        when RCode::NoError
          if reply.tc == 1 and not Requester::TCP === requester
            requester.close
            # Retry via TCP:
            requester = make_tcp_requester(nameserver, port)
            senders = {}
            # This will use TCP for all remaining candidates (assuming the
            # current candidate does not already respond successfully via
            # TCP).  This makes sense because we already know the full
            # response will not fit in an untruncated UDP packet.
            redo
          else
            yield(reply, reply_name)
          end
          return
        when RCode::NXDomain
          raise Config::NXDomain.new(reply_name.to_s)
        else
          raise Config::OtherResolvError.new(reply_name.to_s)
        end
      }
    ensure
      requester&.close
    end
  end
end
