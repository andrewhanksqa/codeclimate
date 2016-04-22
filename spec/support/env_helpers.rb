module EnvHelpers
  def with_env(key, value)
    begin
      original = ENV[key]
      ENV[key] = value
      yield
    ensure
      ENV[key] = original
    end
  end
end
