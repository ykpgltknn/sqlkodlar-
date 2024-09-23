#select veritabanımızda bulunan tablodan istediklerimizi getirir * işareti tüm tabloyu getirir eğer sol tarafta şemalardan veritabanı seçili değilse veritabanı_ismi.tablo_ismi olarak yazılmalı
select * from Parks_and_Recreation2.employee_demographics;
select * from Parks_and_Recreation2.employee_salary;

# alttaki sorgunun çalışması için soldan semalardan Parks_and_Recreation2 datebase çift tıklayıp siyah yazılması gerekir.
select * from employee_demographics;

# burada employee_demographics tablosundan ad ve soyad bilgileri çekilir.
select first_name , last_name from employee_demographics;

# burada calsiandemografisi tablosundan ad soyad ve yaş bilgileri çekilir ve yaşın üstüne matemetik işlerimleri yapılabilir
select first_name , last_name , age , age+10 from employee_demographics;

# pemdas matematik işlemleri önceliği
select first_name , last_name , age , (age+10) * 10 + 10 from employee_demographics;

# DISTINCT tekil yapmaya yarar
select DISTINCT gender
from employee_demographics;

# where komutu ile koşulu sağlayanları listeler aşağıda ismi Leslie olan listelenir
select *
from employee_salary
where first_name = "Leslie" ;

# where komutu ile koşulu sağlayanları listeler aşağıda maaşı 50000den yüksek ve eşitler listelenir
select *
from employee_salary
where salary >= 50000;

# where komutu ile koşulu sağlayanları listeler aşağıda maaşı 50000den düşük ve eşitler listelenir
select *
from employee_salary
where salary <= 50000;

# ! tam tersi listelenir yani female yazıldığı halde male listelenir
select *
from employee_demographics
where gender != 'Female';

#and ve işlemi görür iki koşul veya fazlası için kullanılır aşağıda belli tarihten daha yukarda olanlar ve bu kurala uyan male listelenir
select *
from employee_demographics
where birth_date > '1985-01-01' and gender = 'male';

#or ya da işlemi görür aşağıda o tarihten yüksek olanlar ya da male olanlar listelenir
select *
from employee_demographics
where birth_date > '1985-01-01' or gender = 'male';

# or not ile sonradan yazılanın tam tersi olur yani o tarihten yüksek olanlar ya da kadınlar listelenir
select *
from employee_demographics
where birth_date > '1985-01-01' or not gender = 'male';

# where ile parantez kullanımı olursa önce içerdeki kural uygulanır sonrasında dışardaki kural uygulanır aşagıda adı Leslie ve yaşı 44 olan ya da yasi 55ten büyük olanlar listelenir
select *
from employee_demographics
where (first_name = 'Leslie' and age = 44)or age > 55;

# like benzer % yazının neresine yazıldıysa ondan sonrası ne olursa olsun anlamı katar aşağıda başı ve sonu ne olursa olsun içinde er olanlar listelenir
select *
from employee_demographics
where first_name like '%er%';

# _başta yazanın sonrasında kaç tane varsa o kadar karekteri vardır aşağıda başı a olsun ve sadece sonrasında 2 karakter daha olanlar listelenir
select *
from employee_demographics
where first_name like 'a__';

# _başta yazanın sonrasında kaç tane varsa o kadar karekteri vardır aşağıda başı a olsun sonrasında kesin 3 tane daha karekteri olan veya daha fazla olanalr listelenir
select *
from employee_demographics
where first_name like 'a___%';

# group by order by group by yapabilmek için sayılabilir ortalamsı olanlar yapılır isim yapılmaz ağaşıda cinsiyete göre yaş ortalaması max yaş min yaş ve cinsiyete göre kişi sayısı listelenir
select gender , avg(age) , max(age) , min(age) , count(age)
from employee_demographics
group by gender;

# aşağıda sadece meslekler listelenir
select occupation 
from employee_salary
group by occupation ;

# aşağıda meslekler ve maasları listelenir
select occupation , salary
from employee_salary
group by occupation , salary;

# order by sıralama yapar aşağıda isme göre a dan başlayıp z ye kadar listeler
select *
from employee_demographics
order by first_name ;

#ASC sıralı DESC tam tersi aşağıda z den başlayıp a ya kadar listeler
select *
from employee_demographics
order by first_name DESC;

# order by da ilk yazdığımız kurala göre diğer yazılanı uygular aşağıda önce kadınların yaşı büyükten küçğe sonra erkeklerin yaşı büyükten küçüge göre sıralanır
select *
from employee_demographics
order by gender ,age desc;

# having where yerine kullanılır group by da öncesinde where sonrasında having kullanılır
select gender ,avg(age)
from employee_demographics
group by gender
having avg(age) > 40 ;

# aşağıda hem where ile meslek isminde manager geçen ve having ile ortalama maaşı 75000 den yüksek meslekler ve maaşı listelenir
select occupation, avg(salary)
from employee_salary
where occupation like '%manager%'
group by occupation 
having avg(salary) > 75000;

# limit istediğimiz sayıda baştan sayarak sıralar
select * from employee_demographics
limit 3 ;
select * from employee_demographics
order by age DESC
limit 3;
select * from employee_demographics
order by age DESC
limit 3, 1;
# as ile isim değiştirerek kodlama o ismi kullanabiliriz örn uzun isimlerde örnekte avg(age) avg_age olarak değiştirildi
select gender, avg(age) as avg_age
from employee_demographics
group by gender
having avg_age > 38;