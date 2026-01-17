# frozen_string_literal: true

RSpec.describe HTB do
  it "has a version number" do
    expect(HTB::VERSION).not_to be_nil
  end

  it "has the correct base URI" do
    expect(HTB::BASE_URI).to eq("https://labs.hackthebox.com")
  end

  describe ".configure" do
    it "allows setting the api_token" do
      HTB.configure do |config|
        config.api_token = "test_token"
      end
      expect(HTB.api_token).to eq("test_token")
    end
  end
end

RSpec.describe HTB::Client do
  let(:client) { described_class.new(api_token: "test_token") }

  describe "#initialize" do
    it "requires an api_token" do
      HTB.api_token = nil
      expect { described_class.new }.to raise_error(HTB::AuthenticationError)
    end

    it "accepts an api_token parameter" do
      expect(client.api_token).to eq("test_token")
    end
  end

  describe "#machines" do
    it "returns a Machines instance" do
      expect(client.machines).to be_a(HTB::Machines)
    end
  end

  describe "#users" do
    it "returns a Users instance" do
      expect(client.users).to be_a(HTB::Users)
    end
  end

  describe "#vm" do
    it "returns a VM instance" do
      expect(client.vm).to be_a(HTB::VM)
    end
  end

  describe "#challenges" do
    it "returns a Challenges instance" do
      expect(client.challenges).to be_a(HTB::Challenges)
    end
  end

  describe "#vpn" do
    it "returns a VPN instance" do
      expect(client.vpn).to be_a(HTB::VPN)
    end
  end
end

RSpec.describe HTB::VM do
  let(:client) { HTB::Client.new(api_token: "test_token") }
  let(:vm) { client.vm }

  describe "#spawn" do
    it "posts to the correct endpoint" do
      stub_request(:post, "https://labs.hackthebox.com/api/v4/vm/spawn")
        .with(body: { machine_id: 811 }.to_json)
        .to_return(status: 200, body: { success: "1" }.to_json, headers: { "Content-Type" => "application/json" })

      result = vm.spawn(811)
      expect(result).to eq({ "success" => "1" })
    end
  end

  describe "#terminate" do
    it "posts to the correct endpoint" do
      stub_request(:post, "https://labs.hackthebox.com/api/v4/vm/terminate")
        .with(body: { machine_id: 811 }.to_json)
        .to_return(status: 200, body: { success: "1" }.to_json, headers: { "Content-Type" => "application/json" })

      result = vm.terminate(811)
      expect(result).to eq({ "success" => "1" })
    end
  end
end

RSpec.describe HTB::Machines do
  let(:client) { HTB::Client.new(api_token: "test_token") }
  let(:machines) { client.machines }

  describe "#list" do
    it "gets the machine list" do
      stub_request(:get, "https://labs.hackthebox.com/api/v4/machine/list")
        .to_return(status: 200, body: { info: [] }.to_json, headers: { "Content-Type" => "application/json" })

      result = machines.list
      expect(result).to eq({ "info" => [] })
    end
  end

  describe "#profile" do
    it "gets machine profile by ID" do
      stub_request(:get, "https://labs.hackthebox.com/api/v4/machine/profile/811")
        .to_return(status: 200, body: { info: { name: "Gavel" } }.to_json, headers: { "Content-Type" => "application/json" })

      result = machines.profile(811)
      expect(result).to eq({ "info" => { "name" => "Gavel" } })
    end

    it "gets machine profile by name" do
      stub_request(:get, "https://labs.hackthebox.com/api/v4/machine/profile/Gavel")
        .to_return(status: 200, body: { info: { id: 811 } }.to_json, headers: { "Content-Type" => "application/json" })

      result = machines.profile("Gavel")
      expect(result).to eq({ "info" => { "id" => 811 } })
    end
  end
end
