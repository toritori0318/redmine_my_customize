class MywikiController < ApplicationController
  def edit
    @mywiki = self.find
  end

  def text_update
    @mywiki = self.find
    content = params[:content]

    if @mywiki.id.nil?
      Mywiki.create!(:assigned_to_id => User.current.id,
                     :text => content[:text])
    else
      @mywiki.text = content[:text]
      @mywiki.save
    end

    redirect_to :controller => 'my', :action => "page"
  end

  def find
    @mywiki = Mywiki.where(:assigned_to_id => User.current.id).first
    @mywiki = Mywiki.new unless @mywiki
    @mywiki
  end
end
