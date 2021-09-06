drop Database if exists homework;
 create database homework;
 use homework;


#1. Create product info table
create table `product_info`(
	`product_code` varchar(20) primary key,	-- 상품 코드
    `product_name` varchar(20),				-- 상품명
    `product_price` int(10)					-- 상품가격
);

#2. Insert 5+ product data (tv, laptop ...)
insert into product_info (product_code, product_name, product_price) values
	('HA_DG_TV_S1','삼성TV', 2000),
    ('HA_DG_TV_So1','Sony TV', 1500),
    ('PA_DG_LT_AC1','Acer노트북',800),
    ('PA_DG_LT_LV1', 'Lenovo 노트북' ,450),
    ('PA_DG_GM_PS5', 'PlayStation 5', 500),
    ('PA_DG_GM_NS2', 'Nintendo Switch', 400);
    
#3. 15% 세일
select product_code, product_name, product_price*0.85 할인가
from product_info;

set sql_safe_updates=0;
#4. TV 관련 상품 20% 에일
update product_info
set product_price=product_price*0.8
where product_name like '%TV';
select *			-- 위 결과 출력
from product_info; 

#5. 저장된 상품 가격의 총 금액 출력
select sum(product_price) '총 금액($)'
from product_info;
