module Ranger
  class Client
      
    def initialize(ranger_api_url, ranger_app_id, ranger_api_key)
      @ranger_api_url = ranger_api_url || "https://rangerapp.com/api/v1"
      @ranger_app_id = ranger_app_id
      @ranger_api_key = ranger_api_key
      @ranger_api_resource = RestClient::Resource.new("#{@ranger_api_url}")
    end

    def get_status
      http_get("/status/#{@ranger_app_id}?api_key=#{@ranger_api_key}")
    end

    def get_dependencies
      http_get("/apps/#{@ranger_app_id}/dependencies.json?api_key=#{@ranger_api_key}")
    end
    
    def create_dependency(params)
      http_post("/apps/#{@ranger_app_id}/dependencies.json", params)
    end

    def delete_dependency_from_url(url)
      dependency_id = nil
      get_dependencies.each do |record|
        if record[:dependency][:url] == url
          id = record[:dependency][:id] 
          http_delete("/apps/#{@ranger_app_id}/dependencies/#{id}.json?api_key=#{@ranger_api_key}")
        end
      end
    end

    def delete_dependency(id)
      http_delete("/apps/#{@ranger_app_id}/dependencies/#{id}.json?api_key=#{@ranger_api_key}")
    end

    def clear_all_dependencies
      get_dependencies.each do |record|
        delete_dependency(record[:dependency][:id])
      end
    end

    def get_watchers
      http_get("apps/#{@ranger_app_id}/watchers.json?api_key=#{@ranger_api_key}")
    end

    def create_watcher(params)
      http_post("/apps/#{@ranger_app_id}/watchers.json", params)
    end

    def delete_watcher_from_email(email)
      watcher_id = nil
      get_watchers.each do |record|
        if record[:watcher][:email] == email
          id = record[:watcher][:id]
          http_delete("/apps/#{@ranger_app_id}/watchers/#{id}.json?api_key=#{@ranger_api_key}")
        end
      end
    end

    def delete_watcher(id)
      http_delete("/apps/#{@ranger_app_id}/watchers/#{id}.json?api_key=#{@ranger_api_key}")
    end

    def clear_all_watchers
      get_watchers.each do |record|
        delete_watcher(record[:watcher][:id])
      end
    end
    
    protected

    def sym_keys(c)
      if c.is_a?(Array)
        c.map { |e| sym_keys(e) }
      else
        c.inject({}) do |h, (k, v)|
          h[k.to_sym] = v; h
        end
      end
    end

    def http_get(path)
      sym_keys(JSON.parse(@ranger_api_resource[path].get.to_s))
    end

    def http_post(path, payload = {})
      sym_keys(JSON.parse(@ranger_api_resource[path].post(payload.to_json).to_s))
    end

    def http_put(path, payload = {})
      sym_keys(JSON.parse(@ranger_api_resource[path].put(payload.to_json).to_s))
    end
    
    def http_delete(path)
      sym_keys(JSON.parse(@ranger_api_resource[path].delete.to_s))
    end
  end
end
