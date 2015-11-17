require 'base/base_class'

class Message < CZ::BaseClass
  attr_accessor :result, :object, :content ,:contents

  def default
    {result: false}
  end

  def set_false msg=nil
    self.result=false
    self.content = msg if msg
    self
  end

  def set_true msg=nil
    self.result=true
    self.content = msg if msg
    self
  end
end