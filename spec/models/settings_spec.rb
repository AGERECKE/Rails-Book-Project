require "spec_helper"

describe Settings do
  describe ".read_configuration" do
    before(:all) do
      Settings.source_file = "tmp/settings.yml"
      settings = <<-SETTINGS
      default: &default
         application_name: "Beispielprojekt"
         title: "Beispielprojekt zum Buch"
      test:
         <<: *default
         application_name: "Test-Beispielprojekt"
    SETTINGS
    File.open("tmp/settings.yml", "w") {|f| f.write(settings) }
  end
  
after(:all) do
    File.delete("tmp/settings.yml")
  end
  
  it "reads the default settings" do
    Settings.read_configuration
    Settings.title.should eql("Beispielprojekt zum Buch")
  end
  
  it "reads settings from the current environment" do
     Settings.read_configuration
     Settings.application_name.should eql("Test-Beispielprojekt")
  end
 end
end