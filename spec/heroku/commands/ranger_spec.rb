require 'spec_helper'

module Heroku::Command
  describe Ranger do
    before do
      @cli = prepare_command(Ranger)
      @cli.stubs(:config_vars).returns({
        "RANGER_API_KEY" => "12345abcde",
        "RANGER_API_URL" => "https://rangerapp.com/api",
        "RANGER_APP_ID"  => "1"
      })
      @cli.heroku.stubs(:info).returns({})
    end

    context "ranger" do
      it "shows the current app status"
    end

    context "ranger:domains" do
      it "lists the domains being monitored"
    end

    context "ranger:domains add" do
      it "starts monitoring a domain"
    end

    context "ranger:domains remove" do
      it "stops monitoring a domain"
    end

    context "ranger:domains clear" do
      it "stops monitoring all domains"
    end

    context "ranger:watchers" do
      it "shows the current app watchers"
    end

    context "ranger:watchers add" do
      it "adds an app watcher"
    end

    context "ranger:watchers remove" do
      it "removes an app watcher"
    end

    context "ranger:watchers clear" do
      it "removes all app watchers"
    end
  end
end

