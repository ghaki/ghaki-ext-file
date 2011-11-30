module Ghaki   #:nodoc:
module CoreExt #:nodoc:
module File    #:nodoc:

# Helpers dealing with auto-cleaning up temp files.
module WithTemp

  # Calls block with temp filename then overwrites target filename if no exceptions occur.
  def with_named_temp final_name
    tmp_name = ::File.dirname(final_name) +
      ::File::Separator + '_tmp_' + $$.to_s + '.' +
      ::File.basename(final_name)
    yield tmp_name
    ::File.rename tmp_name, final_name
  ensure
    ::File.unlink tmp_name if ::File.exists?(tmp_name)
  end

  # Opens writable temp file, renames to proper name if no exceptions.
  def with_opened_temp final_name, mode='w', perm=nil
    with_named_temp final_name do |tmp_name|
      ::File.open(tmp_name,mode) do |tmp_file|
        yield tmp_file
      end
    end
  end

  # Simple helper for dumping a string to an output file using a temp.
  def dump_via_temp data_str, final_name, mode='w', perm=nil
    with_opened_temp final_name, mode, perm do |tmp_file|
      tmp_file.puts data_str
    end
  end

  ::File.extend Ghaki::CoreExt::File::WithTemp

end
end end end
