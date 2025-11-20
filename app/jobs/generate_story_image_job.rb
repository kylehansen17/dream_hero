# app/jobs/generate_story_image_job.rb
class GenerateStoryImageJob < ApplicationJob
  queue_as :default

  def perform(story_id)
    story = Story.find_by(id: story_id)
    return unless story

    begin
      image = RubyLLM.paint(
        "Illustration for the story titled #{story.name} about #{story.theme} featuring #{story.character.name}, in an engaging style suitable for ages #{story.age}.",
        model: "imagen-4.0-generate-preview-06-06"
      )

      filename = "#{story.name.parameterize}-illustration.png"
      image_io = StringIO.new(image.to_blob)

      story.image.attach(
        io: image_io,
        filename: filename,
        content_type: image.mime_type || 'image/png'
      )

    rescue => e
      Rails.logger.error("Image generation failed for story #{story_id}: #{e.message}")
    end
  end
end
