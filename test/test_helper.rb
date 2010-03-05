$:.unshift File.dirname(__FILE__) + '/../../lib'

require 'rubygems'
require 'test/unit'
require 'active_record'
require 'stripped_attributes'

begin
  require 'ruby-debug'
  Debugger.start
rescue LoadError
end

module MockedAttributes
  def self.included(base)
    base.column :a, :string
    base.column :b, :string
    base.column :c, :string
    base.column :d, :string
    base.column :e, :string
  end
end

class ActiveRecord::Base  
  class << self
    def columns
      @columns ||= []
    end
   
    def column(name, sql_type = nil, default = nil, null = true)
      columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type, null)
    end
  end
  
  include StrippedAttributes::ActiveRecordExt
end

class StripNone < ::ActiveRecord::Base
  include MockedAttributes
end

class StripAll < ::ActiveRecord::Base
  include MockedAttributes
  strip_attributes
end

class StripSome < ::ActiveRecord::Base
  include MockedAttributes
  strip_attributes :b, :c, :e
end

class StripSomeDerived < StripSome
end

