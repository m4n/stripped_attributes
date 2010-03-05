require 'stripped_attributes'

config.after_initialize do
  ::ActiveRecord::Base.send :include, StrippedAttributes::ActiveRecordExt
end

