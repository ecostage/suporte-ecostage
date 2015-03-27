module Notifiable
  extend ActiveSupport::Concern

  included do
    @recipient_blocks = HashWithIndifferentAccess.new
    @context_blocks = HashWithIndifferentAccess.new

    class << self
      attr_reader :recipient_blocks
      attr_reader :context_blocks

      def recipients_for(action, callback=nil, &block)
        unless callback
          @recipient_blocks[action] = block
        else
          @recipient_blocks[action] = callback
        end
      end

      def context_for(action, callback=nil, &block)
        unless callback
          @context_blocks[action] = block
        else
          @context_blocks[action] = callback
        end
      end
    end
  end

  def recipients_for(action)
    callback = self.class.recipient_blocks[action]
      
    case callback
    when Symbol, String
      self.send(callback)
    else
      instance_eval(&callback)
    end.to_a.compact
  end

  def context_for(action)
    callback = self.class.context_blocks[action]
    case callback
    when Symbol, String
      self.send(callback)
    else
      instance_eval(&callback)
    end
  end
end
