RSpec.describe Nzb do
    subject { FactoryGirl.create(:nzb) }

    it { is_expected.to belong_to :wish_result }

    it { is_expected.to respond_to :filename }

    it 'should use the wish result title as the filename' do
        expect(subject.filename).to start_with subject.wish_result.title
    end

    it 'should include the .nzb extension' do
        expect(subject.filename).to end_with '.nzb'
    end
end