require 'spec_helper'

describe Periscope do
  let(:model) do
    klass = mock
    klass.extend(Periscope)
    klass.stub(:periscope_default_scope => klass)
    klass
  end

  def expect_scopes(hash)
    hash.each do |scope, value|
      model.should_receive(scope).once.with(value).and_return(model)
    end
  end

  it 'uses the default scope for no params' do
    scoped = mock
    model.should_receive(:periscope_default_scope).once.and_return(scoped)
    model.periscope.should == scoped
  end

  it 'uses the default scope for empty params' do
    scoped = mock
    model.should_receive(:periscope_default_scope).once.and_return(scoped)
    model.periscope({}).should == scoped
  end

  it 'ignores protected scopes' do
    model.should_not_receive(:foo)
    model.periscope(:foo => 'bar')
  end

  it 'calls accessible scopes with values' do
    expect_scopes(:foo => 'bar')
    model.scope_accessible(:foo)
    model.periscope(:foo => 'bar')
  end

  it 'recognizes accessible scopes, whether string or symbol' do
    expect_scopes(:foo => 'baz', :bar => 'mitzvah')
    model.scope_accessible(:foo, 'bar')
    model.periscope('foo' => 'baz', :bar => 'mitzvah')
  end
end