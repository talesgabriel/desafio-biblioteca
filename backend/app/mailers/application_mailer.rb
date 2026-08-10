class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("MAILER_FROM", "biblioteca-ney-pontes@mossoro.rn.gov.br")
  layout "mailer"
end
