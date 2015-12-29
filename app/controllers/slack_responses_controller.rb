class SlackResponsesController < ApplicationController

  skip_before_filter :verify_authenticity_token
  before_filter :verify_slack_token

  def create
    #render nothing: true, status: :ok and return unless responder.respond?

    # Respond differently to Slash Command vs Webhook POSTs
    # See `Responding` sections above for the require difference.

    if text.empty? || text.length > 2
      text = params[:text].split #render text: responder.response.to_s
      render json: { text: "[Error] Syntax: /plae_start Task Project" }
    else
      #render json: { text: responder.response.to_s }
      t = create_entry(text)
      render json: { text: "TimeEntry #{t.name} was created" }
    end
  end

  private

  #def responder
   # @responder ||= Slack::Responder.new(params[:text])
  #end

  def verify_slack_token
    render nothing: true, status: :forbidden and return unless Slack::TOKENS.include?(params[:token])
  end

  def create_entry(text)
    if text.length == 1
      t = TimeEntry.create(name: params[:text], start_time: Time.now);
    elsif text.length == 2
      t = TimeEntry.create(name: params[:text], start_time: Time.now, end_time: Time.now + 5);
    end
    return t
  end

end
