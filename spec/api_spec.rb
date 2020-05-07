require "json"
RSpec.describe Todoable::API do
  before(:each) do
    @valid_token = "valid_token"
    @authorization_headers = {
      "Accept" => "*/*",
      "Authorization" => "Token token=\"#{@valid_token}\"",
    }
    @username = "valid_user"
    @password = "valid_pass"
    stub_request(:post, "https://todoable.teachable.tech/api/authenticate").
      with(
      basic_auth: [@username, @password],
      headers: {
        "Accept" => "*/*",
      },
    ).
      to_return(status: 200, body: { token: @valid_token }.to_json, headers: {})

    stub_request(:get, "https://todoable.teachable.tech/api/lists").
      with(
      headers: @authorization_headers,
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
  it "gets the show response" do
    list_id = 12343
    stub_request(:get, "https://todoable.teachable.tech/api/lists/#{list_id}").
      with(
      headers: {
        "Accept" => "*/*",
        "Authorization" => "Token token=\"#{@valid_token}\"",
      },
    ).
      to_return(status: 200, body: {
                  "list" => {
                    "name" => "Urgent Things",
                    "items" => [
                      {
                        "name" => "Feed the cat",
                        "finished_at" => nil,
                        "src" => "https://todoable.teachable.tech/api/lists/#{list_id}/items/1",
                        "id" => "1",
                      }, {
                        "name" => "Get cat food",
                        "finished_at" => nil,
                        "src" => "https://todoable.teachable.tech/api/lists/#{list_id}/items/1",
                        "id" => "2",
                      },
                    ],
                  },
                }.to_json)
    expect(Todoable::API.show(list_id)).to eq(
      {
        "list" => {
          "name" => "Urgent Things",
          "items" => [
            {
              "name" => "Feed the cat",
              "finished_at" => nil,
              "src" => "https://todoable.teachable.tech/api/lists/#{list_id}/items/1",
              "id" => "1",
            }, {
              "name" => "Get cat food",
              "finished_at" => nil,
              "src" => "https://todoable.teachable.tech/api/lists/#{list_id}/items/1",
              "id" => "2",
            },
          ],
        },
      }
    )
  end

  it "does a post" do
    name = "A LIST NAME"
    data = { "list" => { "name" => name } }.to_json
    stub = stub_request(:post, "https://todoable.teachable.tech/api/lists").
      with(
      body: data,
      headers: @authorization_headers,
    ).
      to_return(status: 201, body: "", headers: {})
    Todoable::API.create(name)
    expect(stub).to have_been_requested.once
  end
end
