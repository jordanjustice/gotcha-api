require "request_helper"

RSpec.describe "POST /api/matches/:id/capture" do
  let(:arena) { create :arena }
  let(:match) { create :match, arena: arena, seeker: player }
  let(:player) { create :player, :authorized, arenas: [arena] }
  let(:url) { "/api/matches/#{match.id}/capture" }

  context "with a valid request" do
    before do
      allow_any_instance_of(ConfirmCaptureNotifier).to receive(:notify_player!)
    end

    it "returns an ok status" do
      post url, headers: valid_authed_headers

      expect(response).to be_ok
    end

    it "marks the match as pending" do
      post url, headers: valid_authed_headers

      expect(match.reload).to be_pending
    end

    it "generates a confirmation code for the match" do
      post url, headers: valid_authed_headers

      expect(match.reload.confirmation_code.length).to eq 4
    end

    it "returns the json representation of the match" do
      post url, headers: valid_authed_headers

      expect(json_response[:data][:type]).to eq "match"
      expect(json_response[:data][:id]).to eq match.id.to_s
      expect(json_response[:data][:attributes][:confirmation_code]).to \
        eq match.reload.confirmation_code
    end

    it "sends a confirm capture push notification to the opponent" do
      expect(ConfirmCaptureNotifier).to \
          receive(:new).with(match).and_call_original
      expect_any_instance_of(ConfirmCaptureNotifier).to \
        receive(:notify_player!).with(match.opponent)

      post url, headers: valid_authed_headers
    end
  end

  context "with a match that does not exist" do
    it "returns a not found status" do
      post "/api/matches/-1/capture", headers: valid_authed_headers

      expect(response).to be_not_found
      expect(json_response[:errors].first[:detail]).to \
        eq "Match with id -1 not found"
    end
  end

  context "with a match that is not open" do
    let(:match) { create :match, :ignored, arena: arena, seeker: player }

    it "returns an unprocessable entity status" do
      post url, headers: valid_authed_headers

      expect(response.status).to eq 422
      expect(json_response[:errors].map { |error| error[:detail] }).to \
        include "Match is not open"
    end
  end

  context "with an arena that the player is not playing in" do
    let(:match) { create :match }

    it "returns a not authorized status" do
      post url, headers: valid_authed_headers

      expect(response).to be_unauthorized
      expect(json_response[:errors].first[:detail]).to \
        eq "Not authorized to play in that Match"
    end
  end

  it_behaves_like "an authenticated request" do
    let(:make_request) do
      -> (headers) do
        post url, headers: valid_headers.merge(headers)
      end
    end
  end

  it_behaves_like "a request responding to correct headers" do
    let(:make_request) do
      -> (headers) do
        post url, headers: valid_headers.merge(headers)
      end
    end
  end
end
