class Part < ActiveRecord::Base
 self.inheritance_column=:_type_disabled
 validates :nr,presence:true,uniqueness:{message:'零件号必须唯一'}
 validates :unit,presence:{message:'单位不可空'}
 validates :type,presence:{message:'类型不可空'}

end
