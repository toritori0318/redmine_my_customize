class MywikiController < ApplicationController
  def edit
    @mywiki = self.find
    if @mywiki
      @text = @mywiki.text
    end
  end

  def text_update
    @mywiki = self.find
    content = params[:content]

    if !@mywiki
      Mywiki.create!(:assigned_to_id => User.current,
                     :text => content[:text])
    else
      @mywiki.text = content[:text]
      @mywiki.save
    end

    redirect_to :controller => 'my', :action => "page"
  end

  def find
    @mywiki = Mywiki.find(:all,
                          :conditions => ["assigned_to_id=?", User.current])
    @mywiki.first
  end
end
