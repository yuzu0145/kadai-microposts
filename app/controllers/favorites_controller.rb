class FavoritesController < ApplicationController
  def create
      micropost = Micropost.find(params[:micropost_id])
      current_user.addlike(micropost)
      flash[:success] = '投稿をお気に入りしました'
     redirect_back(fallback_location: root_path)
  end

  def destroy
      micropost = Micropost.find(params[:micropost_id])
      current_user.unlike(micropost)
      flash[:success] = 'お気に入り解除しました'
      redirect_back(fallback_location: root_path)
  end
end
