require 'stringio'
require 'ghaki/core_ext/file/with_temp'

module Ghaki      #:nodoc:
module CoreExt    #:nodoc:
module File       #:nodoc:
module SpecHelper #:nodoc:

module FakeTemp

  def setup_fake_tempfile
    @fake_tempfile = StringIO.new()
    ::File.stubs(:with_opened_temp).yields(@fake_tempfile)
  end

end
end end end end
