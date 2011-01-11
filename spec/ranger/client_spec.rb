require 'spec_helper'

describe Ranger::Client do
  context "get_status" do
    it "gets the status of an app"
  end

  context "get_dependencies" do
    it "returns a list of dependencies"
  end

  context "create_dependency" do
    it "creates a new dependency"
  end

  context "delete_dependency_from_url" do
    it "deletes a dependency using the url"
  end

  context "delete_dependency" do
    it "deletes a dependency using the id"
  end

  context "clear_all_dependencies" do
    it "deletes all an app's dependencies"
  end

  context "get_watchers" do
    it "returns a list of watchers"
  end

  context "create_watcher" do
    it "creates a new watcher"
  end

  context "delete_watcher_from_email" do
    it "deletes a watcher using the email"
  end

  context "delete_watcher" do
    it "deletes a watcher using the id"
  end

  context "clear_all_watchers" do
    it "deletes all an app's watchers"
  end
end
