require 'spec_helper'

RSpec.describe ApplicationHelper do
    context 'when a javascript controller exists' do
        before { allow(helper).to receive(:params).and_return(action: 'index', controller: 'settings') }

        describe "#has_javascript_controller?" do
            it { expect(helper.has_javascript_controller?).to eq true }
        end

        describe "#body_tag" do
            it 'should include data attributes for the controller and action' do
                result = helper.body_tag{}
                expect(result).to match /data-controller/
                expect(result).to match /data-action/
            end
        end
    end

    context 'when a javascript controller does not exist' do
        before { allow(helper).to receive(:params).and_return(action: 'wow', controller: 'not_real') }

        describe '#has_javascript_controller?' do
            it { expect(helper.has_javascript_controller?).to eq false }
        end

        describe "#body_tag" do
            it 'should not have controller or action data attributes' do
                result = helper.body_tag{}
                expect(result).not_to match /data-(controller|action)/
            end
        end
    end
end