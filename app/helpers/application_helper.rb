module ApplicationHelper
  def edit_and_destroy_buttons(item)
    unless current_user.nil?
      if item.is_a? User
        unless item.password_digest.nil?
          edit = link_to('Edit', url_for([:edit, item]), class: "btn btn-primary")
        end
      else
        edit = link_to('Edit', url_for([:edit, item]), class: "btn btn-primary")
      end
      if item.is_a? Brewery or item.is_a? Beer or item.is_a? BeerClub or item.is_a? Style
        if current_user.admin
          edit_and_destroy(edit, item)
        else
          raw("#{edit}")
        end
      else
        edit_and_destroy(edit, item)
      end
    end
  end

  def edit_and_destroy(edit, item)
    del = link_to('Destroy', item, method: :delete,
                  data: {confirm: 'Are you sure?'}, class: "btn btn-danger")
    raw("#{edit} #{del}")
  end

  def round(number)
    number_with_precision(number, precision: 1)
  end
end
