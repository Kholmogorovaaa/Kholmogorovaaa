select 
 n.hash
	,n.article
	,n.brand brand_sku
	,n.title
	,n.is_homeland
	,n.is_foreign
	,n.product_status
	,n.article_origin
	,n.brand_origin
	,n.product_code
	,n.catalog_code
	,bhl.source
	,hi.brands brand_search
	,hi.count_products_analogs
	,hi.count_products_exact
	,hi.type_search
	,hsu.search_string
	,hsu.count search_count_stock
	,EXTRACT(YEAR FROM hsu.created_at) yyyy_search
	,EXTRACT(MONTH FROM hsu.created_at) mm_search
	,EXTRACT(DAY FROM hsu.created_at) dd_search
	,EXTRACT(HOUR FROM hsu.created_at) hh_search
	,hsu.request_time
	,oi.invoice_number
	,oi.order_id
	,oi.count
	,oi.price
	,oi.shipment_is_express
	,o.user_login_guid
	,o.total_sum
	,os.id
	,os.name
	,EXTRACT(YEAR FROM to_timestamp(o.created_at)+ interval '5 hour') yyyy_order
	,EXTRACT(MONTH FROM to_timestamp(o.created_at)+ interval '5 hour') mm_order
	,EXTRACT(DAY FROM to_timestamp(o.created_at)+ interval '5 hour') dd_order
	,DATE_PART('hour', (to_timestamp(basket_created_at)+ interval '5 hour' - hsu.created_at)) * 60 +
	DATE_PART('minute', (to_timestamp(basket_created_at)+ interval '5 hour' - hsu.created_at)) * 60 +
	DATE_PART('second', (to_timestamp(basket_created_at)+ interval '5 hour' - hsu.created_at)) difference_second_search_basket
	,DATE_PART('hour', (to_timestamp(o.created_at) - to_timestamp(basket_created_at))) * 60 +
	DATE_PART('minute', (to_timestamp(o.created_at) - to_timestamp(basket_created_at))) * 60 +
	DATE_PART('second', (to_timestamp(o.created_at) - to_timestamp(basket_created_at))) difference_second_basket_order

from basket_history_log bhl
left join history_search_user_item hi on hi.id = bhl.history_search_user_item_id
left join history_search_user hsu on hsu.id = hi.id_history
left join order_items oi on oi.id = bhl.order_item_id
left join nomenclature n on n.hash = oi.nomenclature_hash
left join public.orders o on o.id = oi.order_id 
left join order_statuses os on os.id = o.status_id

where  request_time > '100'