require "json"
RSpec.describe Todoable::API do
  before(:all) do
    valid_token = "valid_token"
    @username = "valid_user"
    @password = "valid_pass"
    stub_request(:post, "https://todoable.teachable.tech/api/authenticate").
      with(
      basic_auth: [@username, @password],
      headers: {
        "Accept" => "*/*",
      },
    ).
      to_return(status: 200, body: { token: valid_token }.to_json, headers: {})

    stub_request(:get, "https://todoable.teachable.tech/api/lists").
      with(
      headers: {
        "Accept" => "*/*",
        "Authorization" => "Token token=\"#{valid_token}\"",
      },
    ).
      to_return(status: 200, body: {
                  "lists" => [
                    {
                      "name" => "Urgent Things",
                      "src" => "https://todoable.teachable.tech/api/lists/1",
                      "id" => "1",
                    }, {
                      "name" => "Shopping List",
                      "src" => "https://todoable.teachable.tech/api/lists/2",
                      "id" => "2",
                    },
                  ],
                }.to_json, headers: {})
  end

  before(:each) do
    Todoable.init(@username, @password)
  end

  after do
    Todoable.reset_configuration()
  end

  it "gets the index page" do
    expect(Todoable::API.index()).to eq(
      {
        "lists" => [
          {
            "name" => "Urgent Things",
            "src" => "https://todoable.teachable.tech/api/lists/1",
            "id" => "1",
          }, {
            "name" => "Shopping List",
            "src" => "https://todoable.teachable.tech/api/lists/2",
            "id" => "2",
          },
        ],
      }
    )
  end
end
