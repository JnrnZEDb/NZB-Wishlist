RSpec.describe Setting do
    subject  { FactoryGirl.create(:setting) }

    it { is_expected.to validate_presence_of(:newsnab_url).with_message /.*/    }
    it { is_expected.to allow_value('http://localhost').for(:newsnab_url).with_message /.*/ }
    it { is_expected.not_to allow_value('localhost').for(:newsnab_url).with_message /.*/    }
    it { is_expected.to validate_presence_of(:newsnab_apikey).with_message /.*/ }
    it { is_expected.to validate_presence_of(:sabnzbd_url).with_message /.*/    }
    it { is_expected.to allow_value('http://localhost').for(:sabnzbd_url).with_message /.*/ }
    it { is_expected.not_to allow_value('localhost').for(:sabnzbd_url).with_message /.*/    }
    it { is_expected.to validate_presence_of(:sabnzbd_apikey).with_message /.*/ }

    it { is_expected.to validate_numericality_of(:result_limit)
            .is_greater_than_or_equal_to(1)
            .is_less_than_or_equal_to(100)
            .only_integer
            .with_message /.*/ }

    it { is_expected.to validate_numericality_of(:search_interval)
            .is_greater_than_or_equal_to(1)
            .is_less_than_or_equal_to(24)
            .only_integer
            .with_message /.*/ }

    context 'if notify?' do
        before { allow(subject).to receive(:notify?).and_return(true) }
        it { is_expected.to validate_presence_of(:pushover_apikey).with_message /.*/ }
    end

    context 'if not notify?' do
        before { allow(subject).to receive(:notify?).and_return(false) }
        it { is_expected.not_to validate_presence_of(:pushover_apikey) }
    end

    context 'if search interval was updated' do
        before do
            subject.search_interval += 1
            subject.save
        end
        it { expect(subject.update_schedule?).to be true }
    end

    context 'if search interval was not updated' do
        before do
            subject.search_interval = subject.search_interval
            subject.save
        end
        it { expect(subject.update_schedule?).to be false }
    end
end