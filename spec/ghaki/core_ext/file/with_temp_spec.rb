require 'ghaki/core_ext/file/with_temp'
require 'stringio'

describe Ghaki::CoreExt::File::WithTemp do

  context 'using extended File' do
    subject { File }
    it { should be_kind_of(Ghaki::CoreExt::File::WithTemp) }
  end

  let(:final_name) { File.join(File.dirname(__FILE__), 'my-fake-file' ) }
  let(:temp_name)  { File.join(File.dirname(__FILE__), 'my-fake-temp' ) }

  describe '#make_temp_name' do
    subject { File.make_temp_name(final_name) }

    it 'uses same dirname' do
      File.dirname(subject).should == File.dirname(final_name)
    end
    it 'uses different basename' do
      File.basename(subject).should_not == File.basename(final_name)
    end
  end

  describe '#with_named_temp' do

    before(:each) do
      File.expects(:make_temp_name).returns(temp_name).once
    end

    it 'renames temp to final when successful' do
      File.expects(:exists?).with(temp_name).returns(true,false).twice
      File.expects(:rename).with(temp_name,final_name).once
      File.expects(:unlink).never
      File.with_named_temp final_name do
        # do nothing
      end
    end

    it 'calls unlink on temp after failure' do
      File.expects(:exists?).with(temp_name).
        returns(true).once
      File.expects(:unlink).with(temp_name).once
      File.expects(:rename).never
      lambda do
        File.with_named_temp final_name do
          raise RuntimeError, 'testing'
        end
      end.should raise_error(RuntimeError)
    end
  end


  describe '#with_opened_temp' do

    before(:each) do
      File.expects(:make_temp_name).returns(temp_name).once
    end

    it 'renames temp to final when successful' do
      File.expects(:exists?).with(temp_name).returns(true,false).at_most(2)
      File.expects(:rename).with(temp_name,final_name).once
      File.expects(:open).with(temp_name,'w').once
      File.with_opened_temp final_name do
        # doing nothing
      end
    end

    it 'opens temp file for writing' do
      File.expects(:exists?).with(temp_name).returns(false).at_most(2)
      File.expects(:open).with(temp_name,'w').once
      File.with_opened_temp final_name do
        # doing nothing
      end
    end

  end

  describe '#dump_via_temp' do

    let(:dump_data) { 'data-to-dump' }

    before(:each) do
      File.expects(:make_temp_name).returns(temp_name).once
      @tmp_file = StringIO.new
      @tmp_file.expects(:puts).with(dump_data).once
      File.expects(:open).with(temp_name,'w').yields(@tmp_file).once
    end

    it 'renames temp to final when successful' do
      File.expects(:exists?).with(temp_name).returns(true,false).at_most(2)
      File.expects(:rename).with(temp_name,final_name).once
      File.dump_via_temp dump_data, final_name
    end
    
    it 'dumps data to opened temp file' do
      File.expects(:exists?).with(temp_name).returns(false).at_most(2)
      File.dump_via_temp dump_data, final_name
    end

  end

end
