class MetadataMailer < ActionMailer::Base

    def email_metadata(metadata)
      
       @metadata= metadata
       mail(:to=>"aclanthology@gmail.com", :subject=>"[ACL Anthology metadata edits]", :from=>"no-reply@example.com")

    end

end
