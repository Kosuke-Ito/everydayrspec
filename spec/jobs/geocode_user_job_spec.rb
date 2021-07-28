require 'rails_helper'

RSpec.describe GeocodeUserJob, type: :job do
  # userのgeocodeを呼ぶこと
  it "calls geocode on the user" do
    user = instance_doble("User") # モックの作成
    expect(user).to receive(:geocode)
    GeocodeUserJob.perform_now(user) # perform_nowでバックグラウンドジョブの呼び出し
  end
end
