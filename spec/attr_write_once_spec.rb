require 'attr_write_once'

describe AttrWriteOnce do
  describe '#attr_write_once' do
    let(:klass) do
      Class.new do
        extend AttrWriteOnce
        attr_write_once :field
      end
    end

    subject { klass.new }

    it 'is private' do
      expect(klass).to_not respond_to(:attr_write_once)
    end

    it 'allows writing to an attribute once' do
      expect(subject.field).to be_nil
      subject.field = 7
      expect(subject.field).to eq(7)
    end

    it 'raises an exception when trying to write to an attribute a 2nd time' do
      subject.field = 1
      expect {
        subject.field = 2
      }.to raise_error(AttrWriteOnce::WriteLimitExceeded)
    end
  end
end
