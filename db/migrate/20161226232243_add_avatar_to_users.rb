class AddAvatarToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :avatar, :string, default: "https://photos-1.dropbox.com/t/2/AACfz2VlPE2mYpEL2orGPzd7_8PO978F8dI7AZL9pKC_vA/12/50969969/png/32x32/1/_/1/2/default.png/ENPomycYquUEIAcoBw/ZCuGjxBeUJiCVlXECpRVxvsE-Ta8NAVrfo2C9vUCPis?size=1600x1200&size_mode=3"
  end
end
