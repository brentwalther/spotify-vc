module HomeHelper
  def owner_name(owners, playlist)
    owners[playlist.owner.id].display_name || owners[playlist.owner.id].id
  end
end
