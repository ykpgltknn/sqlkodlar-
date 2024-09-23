#ileri seviye sql
# alt sorgular yerine cte ile isimlendirip görsel olarak daha iyi olmasını sağlayabiliriz gerçek bir tabloda yyer almaz sadece sorgu içinde kullanılır
WITH cte_example(Gender , Avgsal , Maxsal,Minsal,Countsal) as 
(
select gender , avg(salary) avgsal, max(salary)maxsal,min(salary)minsal,count(salary)countsal
from employee_demographics dem
join employee_salary sal
	on dem.employee_id = sal.employee_id
    group by gender
)   
select * from cte_example;


select avg(avgsal)
from
(
select gender , avg(salary) avgsal, max(salary)maxsal,min(salary)minsal,count(salary)countsal
from employee_demographics dem
join employee_salary sal
	on dem.employee_id = sal.employee_id
    group by gender
)   ex_subq ;

# iki tane ayrı alt sorguyu cte ile birleştirip sonrasında çıkan bu sorguları bir tabloda görmek için join ile birleştirilir aşağıda '1985-01-01' tarihinden yukarıda ve 50000 den fazla maaşı olanlar listelenir
WITH cte_example as 
(
select employee_id , gender , birth_date
from employee_demographics 
where birth_date > '1985-01-01'

) ,
cte_example2 as(
select employee_id , salary from employee_salary
where salary > 50000
) 
select * from cte_example
join cte_example2
	on cte_example.employee_id = cte_example2.employee_id ;
    
# temporary tables ile geçici tablo oluşturulur ilk örnek popüler olmayan
#aşağıda geçici bir tablo oluştulup içerisine insert into ile veri eklenmiştir eğer sql workbenchi kapatıp geçici tabloyu tekrar oluşturmadan sadece select ile çalıştırılırsa hata verir
create temporary table tamp_table 
(
first_name varchar(50),
last_name varchar(50),
fav_movie varchar(50)

);
select * from tamp_table;
insert into tamp_table 
values('yakup','gültekin','the mentalist');
select * from tamp_table;

# geçici tabloyu sadece yeni tablo oluşturarak yapılmaz ayrıca olan tabloda istediğimiz sekilde sorgu yaparak uyanları geçici tabloya aktarır aşağıda employee_salary tablosundan maaşı 50k üstü ve eşit olanlar listelenir
select * from employee_salary;
create temporary table salary_over_50k
select * from employee_salary
where salary >= 50000;
select * from salary_over_50k;

select * from employee_salary
where salary >= 50000;

# procedureler sql workbench kapatılsa bile sorguyu çalıştırdığımızda sonucu getirir select yerine call komutu kullanılır aşağıda yine 50k üstü ve eşit olanları call ile çağırdığımızda listeler
create procedure large_salary()
select * from employee_salary
where salary >= 50000;
call large_salary ();

# DELIMITER  ile verilerimiiz ayırdıktan sonra procedure oluşturulmuştur ve DELIMITER kullandığımız için begin end komutları içine sorgular yazılarak çalışır aşağıda hem 10k üstü ve eşitler , 50 k ve eşitler listelenirr
DELIMITER $$
create procedure large_salary3()
begin
	select * 
    from employee_salary
	where salary >= 50000;
	select * 
    from employee_salary
    where salary >= 10000;
END $$
DELIMITER ;

call large_salary3();



DELIMITER $$
create procedure large_salary4(huggy INT)
begin
	select salary
    from employee_salary
    where employee_id = huggy;
	
	
END $$
DELIMITER ;
call large_salary4(1);

# triggers and events triggerlar ile bir işlemden sonra yapılması gereken işlemeleri önceden belirleyebiliriz ya da bir bir işlem yapılmadan önce yapılması gereken işleri tetikleriz
select * from employee_demographics;
select * from employee_salary;

# aşağıda employee_salary veri eklendikten sonra employee_demographics ne yeni ekelen id firstname ve lastname i ekler
DELIMITER $$
CREATE TRIGGER employee_insert
	AFTER INSERT ON employee_salary
    FOR EACH ROW
BEGIN
	INSERT INTO employee_demographics (employee_id, first_name,last_name)
    VALUES (NEW.employee_id,NEW.first_name,NEW.last_name);
END $$
DELIMITER ;
INSERT INTO employee_salary (employee_id, first_name,last_name,occupation,salary,dept_id)
values (13,'yakup','gülltekin','veri analisti',1000000,null);

#events yapılması gerekn işlemleri belli bir süre içinde yapmasını söyleriz aşağıda her 30 saniyede bir yaşı 60 dan büyük olanları siler
select * from employee_demographics;
DELIMITER $$
create event delete_retirees
on schedule every 30 second 
do 
begin
	DELETE from employee_demographics
    Where age >= 60;
end $$
DELIMITER ;

# aşağıdaki kodda ise eventin aktif olup olmadığını kontrol ederiz
SHOW VARIABLES LIKE 'event%';



