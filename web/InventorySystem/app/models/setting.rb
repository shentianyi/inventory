class Setting < ActiveRecord::Base
  validates :code, :value, presence: true

  def self.method_missing(method_name, *args, &block)
    if method_name.match(/\?$/)
      if setting=Setting.where(code: method_name.to_s.sub(/\?$/, '')).first
        return setting.value=='1'
      end
    elsif setting=Setting.where(code: method_name).first
      return setting.value
    else
      super
    end
  end


  def self.random_percent_value
    self.random_percent.to_f/100
  end

end
