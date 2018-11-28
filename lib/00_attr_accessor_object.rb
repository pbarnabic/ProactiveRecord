class AttrAccessorObject
  def self.my_attr_accessor(*names)
    
    names.each do |name|
      define_method("#{name}="){|val| instance_variable_set("@#{name}",val)}
      define_method("#{name}"){instance_variable_get("@#{name}")}
    end
  end
end
