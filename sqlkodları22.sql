select * from employee_demographics;
select * from employee_salary;
# inner join ile iki farklı tablı birleştirilir aşağıda employee_demographics ile employee_salary tablosu ile listelenir on sonrasında ikisinin ortak verileri eşitlenir.
select * from employee_demographics as dem
INNER JOIN employee_salary as sal
ON dem.employee_id = sal.employee_id ;

# inner join ile iki farklı tablı birleştirilir aşağıda employee_demographics ile employee_salary tablosu ile listelenir select sonrası ortak olan veri hangi tablodan çekilecekse yazılır(dem.employee_id)
select dem.employee_id ,age,occupation 
from employee_demographics as dem
INNER JOIN employee_salary as sal
ON dem.employee_id = sal.employee_id ;

-- Outer joins left ile right joing vardır bunlardan left joinde solda bulunan veri ile sağdakiler ile uyuşan eslenir sağdaki fazla veri listelenmez
select * from employee_demographics as dem
left JOIN employee_salary as sal
ON dem.employee_id = sal.employee_id ;

-- Outer joins left ile right joing vardır bunlardan right joinde sağda bulunan veri ile soldakiler ile uyuşan eslenir sodlaki fazla veri listelenmez
select * from employee_demographics as dem
right JOIN employee_salary as sal
ON dem.employee_id = sal.employee_id ;

-- self join
select emp1.employee_id  as emp_santa ,
emp1.first_name as first_name_santa,
emp1.last_name as last_name_santa,
emp2.employee_id  as emp_name ,
emp2.first_name as first_name_emp,
emp2.last_name as last_name_emp
from employee_salary emp1
join employee_salary emp2
on emp1.employee_id + 1= emp2.employee_id ;

-- joining multiple table together ikiden fazla tablolarda listelenebilir ilk iki tablodan ortak veriler eşleştirilir sonrasında gelen tablo eski iki tablodan bir veri ile uuyşmalı ve eşleştirilmeli
select * from employee_demographics as dem
INNER JOIN employee_salary as sal
ON dem.employee_id = sal.employee_id 
INNER JOIN parks_departments pd
on sal.dept_id= pd.department_id ;

# union ile istenilen verilerde tekil olarak lsitenelir iki defa aynı veri avrsa bir kere yazılır eğer union all yazılırsa bütün tablo listelenir
select first_name,last_name from employee_demographics
union
select first_name,last_name from employee_salary;

select first_name,last_name from employee_demographics
union all
select first_name,last_name from employee_salary;

# where ile sorgulanan tablolar bir araya union ile getirilir
select first_name,last_name, 'OLD Man' as label from employee_demographics
where age >40 and gender = 'Male'
union
select first_name,last_name, 'OLD Lady' as label from employee_demographics
where age >40 and gender ='female'
union
select first_name,last_name, 'higly paid employee' as label from employee_salary
where salary > 70000
order by first_name,last_name;

-- string functions 
#length yazılan karakterin uzunluğunu yazar
select length('skyfall');
select first_name , length(first_name) from employee_demographics
order by 2;

# upper yazılan yazıyı veya istenilen tablo listesinin tüm karakterini büyütür
select upper('sky');

# lower yazılan yazıyı veya istenilen tablo listesinin tüm karakterini küçültür
select lower('SKY');

# employee_demographics bulunan first_name listenelir ayrıca upperlı hali de listelenelir
select first_name, upper(first_name) from employee_demographics;

# ltrim ile soldaki boşluklar silinir
SELECT ltrim('            SKY          ');

# rtrim ile sağdaki boşluklar silinir
SELECT rtrim('            SKY          ');

# first_name left ile first_name den solundan başlayıp 4 karekter yazılır right ile sondan başlayıp 4 karakteri listeler substring ile içine yazılan verinin ile yazılan sayı karakter sonrasından ikinci yazılan sayı kadar karakter listelenir
select first_name, left(first_name , 4) as first4,
right(first_name , 4) as last4,
substring(first_name,3,2) as sub,
substring(birth_date,6,2) as month2
from employee_demographics;

select first_name , replace(first_name, 'a' , 'z') from employee_demographics;

#locate ile x ikinci kelimede hangi yerde onu yazdırır 
select locate('x','Alexander');

#first_name de an kaç kere varsa onu listeler 
select first_name , locate('an',first_name) from employee_demographics;

# comcat ile iki farklı veri birleştirilip ayrı listelenir
select first_name , last_name ,
concat(first_name ,' ', last_name ) as full_name
from employee_demographics;

# case ile selectten seçilen verileri sorgular ve ona uyanlara göre işlem yapar aşağıda yaşı 30dan küçük eşit olanlara young 31 ile 50 arası old 50 ve üstü olanlar ölmüm kapıda yazar
select first_name, last_name, age,
case
	when age <= 30 then  'young'
    when age between 31 and 50 then 'old'
    when age >= 50 then 'ölüm kapıda'
end as age_etiketi
from employee_demographics;

-- pay increase and bonus 
-- < 50000 = %5
-- >50000 = %7
-- finance = %10 bonus
select first_name ,last_name, salary ,
case
	when salary < 50000 then salary + (salary * 0.05)
    when salary > 50000 then salary + (salary * 0.07)
end as new_salary,
case
	when dept_id = 6 then salary * .10
end
from employee_salary;

select * from employee_salary;
select * from parks_departments;

#Subqueries alt sorgu ile başka tablodaki veriler ile sorgu yapılabilir aşağıda employee_demographics tablosundan employee_salary deki dept_id=1 ile eşlensenleri listeler
select * from employee_demographics
where employee_id IN 
		(select employee_id 
			from employee_salary
            where dept_id=1);
            
#employee_salary tablodasundan first_name salary ve ortalama salary listelenir eğer yanına as ile farklı isim verirsek tabloda o isim ile listelenir
select first_name, salary ,
(select avg(salary) from employee_salary ) as ortalama
from employee_salary ;

# asağıdaki sorguda group by ile female ve male listelenir bunların ortalama yaşı en yükske yaşı en az yaşı ve kişi sayısını listeler
select gender , avg(age) ,max(age),min(age),count(age) 
from employee_demographics group by gender;

# backtick altgr + , ile yapılır `
# select avg içine fromda alt sorgu ile isimlendirrdiğimiz sorguların isimlerni yazarak istelinen veriyi listeler
select avg(age1)
from (select gender , avg(age) as age1 ,
max(age) as age2
,min(age) as age3
,count(age) 
from employee_demographics group by gender)as age_tabel;

#aşağıdaki sorguda iki tablonun birleştirilip cinsiyete göre ortalama satış listelenir
select gender , avg(salary) as avg_salary
from employee_demographics dem
join employee_salary sal
	on dem.employee_id=sal.employee_id
group by gender;

#aşağıdaki sorguda iki tablodan farklı veriler alıp ortalama satışı cinsiyete göre sıralayarak listelenir
select dem.first_name, dem.last_name ,gender , avg(salary) over(partition by gender)
from employee_demographics dem
join employee_salary sal
	on dem.employee_id=sal.employee_id;
    
#aşağıdaki sorguda iki tablodan farklı veriler alıp cinsiyete göre satışlarını yazar ve diğer veri tablosunda kızların  ayrı erkeklerin ayrı toplar
    select dem.first_name, dem.last_name ,gender ,salary , sum(salary) over(partition by gender order by dem.employee_id) as rol
from employee_demographics dem
join employee_salary sal
	on dem.employee_id=sal.employee_id;
    
 # aşağıdaki sorguda iki tablodan farklı veriler alıp cinsiyete göre satışları sıraların ayrıca order by ile desc yazıldığı için en yüksek maaşı alan kadın erkek ayrı şekilde numaralandırır ayrıca row_numm,rank_nume
 # dense_rank_num ile aralarındaki fark ise row num aynı parayı akzansalar bile isme göre numara verir ve devam eder rank_num aynı veri olunca aynı sayıyı verip numara atlar dense_rank_num numara atlamaz
select dem.employee_id,dem.first_name, dem.last_name ,gender ,salary , 
row_number() over(partition by gender order by salary desc)as row_num,
rank() over(partition by gender order by salary desc) as rank_num,
dense_rank() over(partition by gender order by salary desc) as dense_rank_num
from employee_demographics dem
join employee_salary sal
	on dem.employee_id=sal.employee_id;