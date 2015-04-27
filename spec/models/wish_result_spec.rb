RSpec.describe WishResult do
    subject { FactoryGirl.create(:wish_result) }

    it { is_expected.to validate_presence_of :title       }
    it { is_expected.to validate_presence_of :wish_id     }
    it { is_expected.to validate_presence_of :nzb_id      }
    it { is_expected.to validate_presence_of :category_id }
    it { is_expected.to validate_presence_of :pub_date    }
    it { is_expected.to validate_presence_of :size        }
    it { is_expected.to validate_presence_of :details_url }

    it { is_expected.to belong_to :wish     }
    it { is_expected.to belong_to :category }
    it { is_expected.to have_one  :nzb      }

    it { is_expected.to respond_to :human_readable_size }
    it { is_expected.to respond_to :publish_age         }
    it { is_expected.to respond_to :has_nzb?            }
end