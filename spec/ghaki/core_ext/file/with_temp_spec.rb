require 'ghaki/core_ext/file/with_temp'

describe Ghaki::CoreExt::File::WithTemp do

  context 'using extended File' do
    subject { File }
    it { should respond_to :with_named_temp }
    it { should respond_to :with_opened_temp }
    it { should respond_to :dump_via_temp }
  end

end
