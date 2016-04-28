ActiveAdmin.register Medium do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
permit_params do
  permitted = [:permitted, :title, :url, :thumbnail, :category]
  permitted
end

action_item :view_site do
  link_to "Categories", "/"
end

filter :title
filter :category, as: :select

end
