# -*- coding: utf-8 -*-
font_directory = "#{SPREE_ROOT}/public/images/fonts"
pdf.font_families.update(
                         "Arial" => { :bold => "#{font_directory}/arialbd.ttf",
                           :italic      => "#{font_directory}/ariali.ttf",
                           :bold_italic => "#{font_directory}/arialbi.ttf",
                           :normal      => "#{font_directory}/arial.ttf" })
pdf.font "Arial"

ship_address = @order.ship_address
invoice_config = RUSSIAN_CONFIG['invoice'].symbolize_keys

###################################
# Шапка
###################################
pdf.image "#{SPREE_ROOT}/public/#{invoice_config[:logo]}", :at => [10,720], :scale => 0.65
pdf.move_down 20
pdf.text "#{I18n::t('invoice')} №#{@order.number}",
:align => :center,
:style => :bold,
:size => 16

# pdf.text_box "#{Date.today}",
# :width    => 50,
# :height => pdf.font.height * 2,
# :overflow => :ellipses, 
# :at       => [pdf.bounds.right-100,pdf.bounds.top-10],
# :align => :right

pdf.move_down 20
# pdf.text "#{Date.today}"
# pdf.move_down 5
pdf.text "От кого: #{invoice_config[:company_name]}"
pdf.move_down 5
pdf.text "Получатель: #{ship_address.firstname} #{ship_address.lastname}"
pdf.move_down 15

###################################
# Таблица товаров
###################################
order_items = [[]]
i = 0
@order.line_items.each do |item|
  order_items[i] = [item.variant.product.name, # + (item.variant.option_values.empty? ? '' : ("(" + variant_options(item.variant) + ")")),
                    number_to_currency(item.price).gsub('&nbsp;', ' '),
                    item.quantity,
                    number_to_currency(item.price * item.quantity).gsub('&nbsp;', ' ') 
                   ]
  i += 1
end

@order.adjustments.each do |adjustment| 
  order_items[i] = [adjustment.description,
                    '',
                    '',
                    number_to_currency(adjustment.amount).gsub('&nbsp;', ' ')
                   ]
  i += 1
end 

pdf.table order_items,
:headers  => [I18n::t('item_description'), I18n::t('price'), I18n::t('qty'), I18n::t('total')],
:position           => :center,
:border_width => 1,
# :vertical_padding   => 2,
# :horizontal_padding => 6,
:font_size => 11,
:column_widths => { 0 => 350, 1 => 50, 2 => 50, 3 => 50 }
# :widths => { 0 => 200, 1 => 50, 2 => 50, 3 => 50 }

# :border_style => :underline_header

###################################
# Подвал
###################################
pdf.move_down 10
pdf.text "#{I18n::t('total')}: #{number_to_currency(@order.total).gsub('&nbsp;', ' ')}          ",
:size => 13,
:style => :bold,
:align => :right





# fill_color "005D99"
# text "Customer Invoice", :at => [200,698], :style => :bold, :size => 22
# fill_color "000000"

# move_down 55

# font "Helvetica", :style => :bold, :size => 14
# text "Order Number: #{@order.number}"

# font "Helvetica", :size => 8
# text @order.created_at.to_s(:long)

# # Address Stuff
# bounding_box [0,600], :width => 540 do
#   move_down 2
#   data = [[Prawn::Table::Cell.new( :text =>"Shipping Address", :font_style => :bold )]]

#   table data,
#     :position           => :center,
#     :border_width => 0.5,
#     :vertical_padding   => 2,
#     :horizontal_padding => 6,
#     :font_size => 9,
#     :border_style => :underline_header,
#     :column_widths => { 0 => 270, 1 => 270 }

#   move_down 2
#   horizontal_rule

#   bounding_box [0,0], :width => 540 do
#     move_down 2
#     data2 = [["#{ship_address.firstname} #{ship_address.lastname}",
#             ship_address.address1]]
#     data2 << [[ship_address.address2]] unless ship_address.address2.blank?
#     data2 << [["#{@order.ship_address.city}, #{(@order.ship_address.state ? @order.ship_address.state.abbr : "")} #{@order.ship_address.zipcode}"]]
#     data2 << [[ship_address.country.name]]
#     data2 << [[ship_address.phone]]

#     table data2,
#       :position           => :center,
#       :border_width => 0.0,
#       :vertical_padding   => 0,
#       :horizontal_padding => 6,
#       :font_size => 9,
#       :column_widths => { 0 => 270, 1 => 270 }
#   end

#   move_down 2

#   stroke do
#     line_width 0.5
#     line bounds.top_left, bounds.top_right
#     line bounds.top_left, bounds.bottom_left
#     line bounds.top_right, bounds.bottom_right
#     line bounds.bottom_left, bounds.bottom_right
#   end

# end

# move_down 30

# # Line Items
# bounding_box [0,cursor], :width => 540, :height => 450 do
#   move_down 2
#   data =  [[Prawn::Table::Cell.new( :text => "SKU", :font_style => :bold),
#                 Prawn::Table::Cell.new( :text =>"Item Description", :font_style => :bold ),
#                Prawn::Table::Cell.new( :text =>"Price", :font_style => :bold ),
#                Prawn::Table::Cell.new( :text =>"Qty", :font_style => :bold, :align => 1 ),
#                Prawn::Table::Cell.new( :text =>"Total", :font_style => :bold )]]

#   table data,
#     :position           => :center,
#     :border_width => 0,
#     :vertical_padding   => 2,
#     :horizontal_padding => 6,
#     :font_size => 9,
#     :column_widths => { 0 => 75, 1 => 290, 2 => 75, 3 => 50, 4 => 50 } ,
#     :align => { 0 => :left, 1 => :left, 2 => :right, 3 => :right, 4 => :right }

#   move_down 4
#   horizontal_rule
#   move_down 2

#   bounding_box [0,cursor], :width => 540 do
#     move_down 2
#     data2 = []
#     @order.line_items.each do |item|
#       data2 << [item.variant.product.sku,
#                 item.variant.product.name,
#                 number_to_currency(item.price),
#                 item.quantity,
#                 number_to_currency(item.price * item.quantity)]
#     end


#     table data2,
#       :position           => :center,
#       :border_width => 0,
#       :vertical_padding   => 5,
#       :horizontal_padding => 6,
#       :font_size => 9,
#       :column_widths => { 0 => 75, 1 => 290, 2 => 75, 3 => 50, 4 => 50 },
#       :align => { 0 => :left, 1 => :left, 2 => :right, 3 => :right, 4 => :right }
#   end

#   font "Helvetica", :size => 9

#   totals = []

#   totals << [Prawn::Table::Cell.new( :text => "Subtotal:", :font_style => :bold), number_to_currency(@order.item_total)]

#   @order.charges.each do |charge|
#     totals << [Prawn::Table::Cell.new( :text => charge.description + ":", :font_style => :bold), number_to_currency(charge.amount)]
#   end
#   @order.credits.each do |credit|
#     totals << [Prawn::Table::Cell.new( :text => credit.description + ":", :font_style => :bold), number_to_currency(credit.amount)]
#   end

#   totals << [Prawn::Table::Cell.new( :text => "Order Total:", :font_style => :bold), number_to_currency(@order.total)]

#   bounding_box [bounds.right - 500, bounds.bottom + (totals.length * 15)], :width => 500 do
#     table totals,
#       :position => :right,
#       :border_width => 0,
#       :vertical_padding   => 2,
#       :horizontal_padding => 6,
#       :font_size => 9,
#       :column_widths => { 0 => 425, 1 => 75 } ,
#       :align => { 0 => :right, 1 => :right }

#   end

#   move_down 2

#   stroke do
#     line_width 0.5
#     line bounds.top_left, bounds.top_right
#     line bounds.top_left, bounds.bottom_left
#     line bounds.top_right, bounds.bottom_right
#     line bounds.bottom_left, bounds.bottom_right
#   end

# end

# footer [margin_box.left, margin_box.bottom + 30] do
#   font "Helvetica", :size => 8

#   text "Shipping is not refundable. | Special orders are non-refundable."
#   text "In order to return a product prior authorization with a RMA number is mandatory"
#   text "All returned items must be in original un-opened packaging with seal intact."
# end
