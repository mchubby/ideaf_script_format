require 'singleton'

class SingletonHelper
  include Singleton

  def set(val)
    @val = val
  end
 
  def get
    @val
  end
end
