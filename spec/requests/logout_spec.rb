require "request_helper"

RSpec.describe "DELETE /api/sessions" do
  let!(:player) { create :player, :authorized }

  context "with a valid request" do
    it "returns a no content status" do
      delete "/api/sessions", headers: valid_authed_headers

      expect(response).to be_no_content
    end

    it "removes the api key for the player" do
      delete "/api/sessions", headers: valid_authed_headers

      expect(player.reload.api_key).to be_nil
    end
  end

  it_behaves_like "an authenticated request" do
    let(:make_request) do
      -> (headers) do
        delete "/api/sessions", headers: valid_authed_headers.merge(headers)
      end
    end
  end
end
