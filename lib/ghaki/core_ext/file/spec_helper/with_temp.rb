module Ghaki      #:nodoc:
module CoreExt    #:nodoc:
module File       #:nodoc:
module SpecHelper #:nodoc:

module FakeTemp

  def setup_fake_tempfile
    @fake_tempfile = stub_everything()
    File.stubs(:with_opened_temp).yields(@fake_tempfile)
    File.stubs(:with_named_temp).yields(@fake_tempfile)
  end

end
end end end end
