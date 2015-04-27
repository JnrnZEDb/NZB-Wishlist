require 'rails_helper'

RSpec.describe Wish do
    subject { FactoryGirl.create(:wish) }

    it { is_expected.to validate_presence_of(:name).with_message /.*/        }
    it { is_expected.to validate_presence_of(:query).with_message /.*/       }
    it { is_expected.to validate_presence_of(:category_id).with_message /.*/ }

    it { is_expected.to belong_to :category         }
    it { is_expected.to have_many :results          }

    it { is_expected.to respond_to :age_in_days     }
    it { is_expected.to respond_to :last_search_age }
    it { is_expected.to respond_to :has_results?    }

    it { expect(subject.start_search_date).not_to be_nil }

    it 'should include its category when serialized to json' do
        category = subject.category.as_json.to_s

        expect(subject.as_json.to_s).to include(category)
    end
end