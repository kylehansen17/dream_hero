RubyLLM.configure do |config|
  config.openai_api_key = ENV["OPENAI_API_KEY"]
  config.gemini_api_key = ENV['GEMINI_API_KEY']
  config.default_image_model = "imagen-4.0-generate-preview-06-06"
  #config.openai_api_base = "https://models.github.ai/inference"
end
