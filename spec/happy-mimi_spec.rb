require "spec_helper"

FakeMadMimiAPI = proc do |env|
  [200, {"Content-Type"  => "text/html",
         "X-Test-Method" => env["REQUEST_METHOD"],
         "X-Test-Input"  => env["rack.input"].read,
         "X-Test-Scheme" => env["rack.url_scheme"],
         "X-Test-Host"   => env["HTTP_HOST"] || env["SERVER_NAME"],
         "X-Test-Port"   => env["SERVER_PORT"],
         "X-Test-Path"   => env["PATH_INFO"],
         "X-Test-QueryString" => env["QUERY_STRING"]
         },
    ["Hello world"]
  ]
end

describe HappyMimi do
  context "with parameters to be used as default for every request" do
    describe "when setting" do
      it "persists the parameters" do
        HappyMimi.default_parameters = {:foo => 1}
        HappyMimi.default_parameters.should == {:foo => 1}
      end
      
      it "mergs new parameters but keeps old ones" do
        HappyMimi.default_parameters = {:foo => 2}
        HappyMimi.default_parameters = {:bar => 3}
        HappyMimi.default_parameters.should == {:foo => 2, :bar => 3}
      end
    end
    
    describe "when clearing" do
      it "empties out the parameters" do
        HappyMimi.default_parameters = {:foo => 4}
        HappyMimi.clear_default_parameters!
        HappyMimi.default_parameters.should be_empty
      end
    end
  end
  
  context "when calling an API method" do
    around(:each) do |example|
      Artifice.activate_with(FakeMadMimiAPI) do
        example.run
      end
    end
    
    it "calls the MadMimi API at api.madmimi.com by default" do
      response = HappyMimi.call_api("/mailer")
      response["X-Test-Host"].should == "api.madmimi.com:443"
    end
    
    it "calls the MadMimi API with the overriden base URI" do
      response = HappyMimi.call_api("http://google.com/mailer")
      response["X-Test-Host"].should == "google.com:80"
    end
    
    it "calls the MadMimi API with the specified endpoint" do
      response = HappyMimi.call_api("/mailer")
      response["X-Test-Path"].should == "/mailer"
    end
    
    it "calls the MadMimi API as a GET request by default" do
      response = HappyMimi.call_api("/mailer")
      response["X-Test-Method"].should == "GET"
    end
    
    it "calls the MadMimi API with the specified HTTP method" do
      response = HappyMimi.call_api("/mailer", :post)
      response["X-Test-Method"].should == "POST"
    end
    
    it "calls the MadMimi API with the default parameters via GET" do
      HappyMimi.clear_default_parameters!
      HappyMimi.default_parameters = {:foo => "bar"}
      response = HappyMimi.call_api("/mailer")
      response["X-Test-Path"].should == "/mailer"
      response["X-Test-QueryString"].should == "foo=bar"
      HappyMimi.clear_default_parameters!
    end
    
    it "calls the MadMimi API with specified parameters merged with default parameters via GET" do
      HappyMimi.clear_default_parameters!
      HappyMimi.default_parameters = {:foo => "bar"}
      response = HappyMimi.call_api("/mailer", :baz => "buz")
      response["X-Test-Path"].should == "/mailer"
      response["X-Test-QueryString"].should =~ /foo=bar/
      response["X-Test-QueryString"].should =~ /baz=buz/
      HappyMimi.clear_default_parameters!
    end
    
    it "calls the MadMimi API with the default parameters via POST" do
      HappyMimi.clear_default_parameters!
      HappyMimi.default_parameters = {:foo => "bar"}
      response = HappyMimi.call_api("/mailer", :post)
      response["X-Test-Path"].should == "/mailer"
      response["X-Test-Input"].should =~ /foo=bar/
      HappyMimi.clear_default_parameters!
    end
    
    it "calls the MadMimi API with specified parameters merged with default parameters via POST" do
      HappyMimi.clear_default_parameters!
      HappyMimi.default_parameters = {:foo => "bar"}
      response = HappyMimi.call_api("/mailer", :post, :baz => "buz")
      response["X-Test-Path"].should == "/mailer"
      response["X-Test-Input"].should =~ /foo=bar/
      response["X-Test-Input"].should =~ /baz=buz/
      HappyMimi.clear_default_parameters!
    end
  end
end