class AnyFieldFillValidator < ActiveModel::Validator
  def validate(record)
    fill_in = false
    if options[:fields].any?{|field| record.send(field).present?}
      fill_in = true
    end

    unless fill_in
      record.errors[:base] << "Fill in which one field"
    end
  end
end
