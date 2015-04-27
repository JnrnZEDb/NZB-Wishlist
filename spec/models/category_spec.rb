RSpec.describe Category do
    subject { FactoryGirl.create(:category) }

    it { is_expected.to validate_presence_of :name           }
    it { is_expected.to validate_presence_of :canonical_name }

    it { is_expected.to belong_to :parent   }
    it { is_expected.to have_many :children }
end