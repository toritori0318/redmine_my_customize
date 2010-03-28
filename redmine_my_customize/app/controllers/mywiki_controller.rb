class MywikiController < ApplicationController
  def edit
    @mywiki = Mywiki.find(:all,
                          :conditions => ["assigned_to_id=?", User.current])
    @mywiki = @mywiki.first
  end

  def text_update
    @mywiki = Mywiki.find(:all,
                          :conditions => ["assigned_to_id=?", User.current])
    @mywiki = @mywiki.first
    paramwiki = params[:mywiki]

    if !@mywiki
      Mywiki.create!(:assigned_to_id => User.current,
                     :text => paramwiki[:text])
    else
      @mywiki.text = paramwiki[:text]
      @mywiki.save
    end

    redirect_to :controller => 'my', :action => "page"
  end

end
