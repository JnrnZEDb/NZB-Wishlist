class Nzb < ActiveRecord::Base
  belongs_to :wish_result

  def filename
    "#{wish_result.title}.nzb"
  end
end
