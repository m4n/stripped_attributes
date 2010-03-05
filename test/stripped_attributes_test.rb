require 'test_helper'

class StrippedAttributesTest < ActiveSupport::TestCase
  def setup
    @attrs    = { :a => "",  :b => "\n ", :c => "\n hello", :d => "world\t ", :e => " foo " }
    @stripped = { :a => nil, :b => nil,   :c => 'hello',    :d => 'world',    :e => 'foo' }
  end
  
  test "defines a class level #version method" do
    assert_respond_to StrippedAttributes, :version
  end
  
  test "class level #version method returns a valid version" do
    assert_match /^\d+\.\d+\.\w+$/, StrippedAttributes.version
  end
  
  test "defines a class level strip_attributes method" do
    assert Object.const_defined?(:StrippedAttributes)
    assert ActiveRecord::Base.respond_to?(:strip_attributes)
  end
  
  test "defines a class level stripped_attributes method" do
    assert !StripNone.respond_to?(:stripped_attributes)
    
    assert StripAll.respond_to?(:stripped_attributes)
    assert :all, StripAll.stripped_attributes
    
    assert StripSome.respond_to?(:stripped_attributes)
    assert [:b, :c, :e], StripAll.stripped_attributes
  end
  
  test "defines a class level strip_attribute? method" do
    assert !StripNone.respond_to?(:strip_attribute?)
    
    assert StripAll.respond_to?(:strip_attribute?)    
    StripAll.column_names.each { |attr| assert true, StripAll.strip_attribute?(attr) }
    
    assert StripSome.respond_to?(:strip_attribute?)
    
    assert_equal false, StripSome.strip_attribute?(:a)
    assert_equal true,  StripSome.strip_attribute?(:b)
    assert_equal true,  StripSome.strip_attribute?(:c)
    assert_equal false, StripSome.strip_attribute?(:d)
    assert_equal true,  StripSome.strip_attribute?(:e)
  end
  
  test "should strip none" do
    record = StripNone.new(@attrs)
    
    assert_equal @attrs[:a], record.a
    assert_equal @attrs[:b], record.b
    assert_equal @attrs[:c], record.c
    assert_equal @attrs[:d], record.d
    assert_equal @attrs[:e], record.e
  end
 
  test "should strip all" do
    record = StripAll.new(@attrs)
    
    assert_equal @stripped[:a], record.a
    assert_equal @stripped[:b], record.b
    assert_equal @stripped[:c], record.c
    assert_equal @stripped[:d], record.d
    assert_equal @stripped[:e], record.e
  end
 
  test "should strip some" do
    record = StripSome.new(@attrs)
    
    assert_equal @attrs[:a],    record.a
    assert_equal @stripped[:b], record.b
    assert_equal @stripped[:c], record.c
    assert_equal @attrs[:d],    record.d
    assert_equal @stripped[:e], record.e
  end
 
  test "should strip some on derived record" do
    record = StripSomeDerived.new(@attrs)
    
    assert_equal @attrs[:a],    record.a
    assert_equal @stripped[:b], record.b
    assert_equal @stripped[:c], record.c
    assert_equal @attrs[:d],    record.d
    assert_equal @stripped[:e], record.e
  end
end

