create database Library_Management;
use Library_Management;
#####图书信息；

create table users (
uid int primary key auto_increment,
username varchar(20) not null,
password varchar(20) default 'niit1234' ,
stu_id int 
);

create table books(
	book_id int primary key auto_increment,		
    book_name varchar(50) not null,
    book_author varchar(50) not null, 
    book_pub varchar(100) not null,  			/*出版社*/
    book_num int not null,   					/*是否在书架上 1为在书架上 0为不在  */ 
    book_sort varchar(30) not null, 			/*书籍分类*/
    book_record datetime, 						/*登记日期*/
    book_introduction varchar(200) not null 	/*简介*/
);


create table book_sort(
sort_id int primary key,						
sort_name varchar(20) not null					/*类型名*/
);

alter table books add sort_id int ;
alter table books add foreign key(sort_id) references book_sort(sort_id);
create table student(
	stu_id int primary key,
    stu_name varchar(20) not null,
    stu_sex varchar(10) not null,
    stu_age int not null,
    stu_mobile varchar(15),
    stu_email varchar(30),
    stu_pro varchar(50) not null, 					/*专业*/
    stu_grade varchar(20) not null,					/*年级*/
    stu_borrowed int not null,    					/*已借书的数量*/
    stu_integrity int not null default'1'		/* 诚信级 默认为1*/
);
alter table users add foreign key(stu_id) references student(stu_id) on delete cascade on update cascade;
create table manager(
	uid int,
 	manager_id int primary key,
    manager_name varchar(20) not null,
    manager_sex varchar(10),
    manager_mobile varchar(15) not null,
    manager_address varchar(50)
);
create table borrow(                  		/*存储学生的借书信息*/
	student_id int ,
    book_id int ,
    borrow_date datetime ,					/*借书日期*/
    expect_return_date datetime			/*预计归还日期*/
    ##foreign key(student_id) references student(stu_id) ,
    ##foreign key(book_id) references books(book_id) 
);
create table return_table(
	student_id int,
    book_id int,
    borrow_date datetime,
    if_back char(20) not null,
    return_date datetime
	##foreign key(student_id) references student(stu_id),
    ##foreign key(book_id) references books(book_id)
);
create table ticket(
	student_id int,
    book_id int,
    over_date int,
    ticket_fee float 
    ##foreign key(student_id) references student(stu_id),
    ##foreign key(book_id) references books(book_id)
);
create table image(
book_name varchar(50),
path varchar(100)
);

/*student*/
/*为stu_id创建索引，升序排序*/
create index index_id on student(stu_id asc);
/*为stu_name创建索引，并且降序排序*/
alter table student add index index_name(stu_name desc); 


/*books*/
/*为book_id创建索引，升序排列*/
create index index_bid on books(book_id);
/*为book_record创建索引，以便方便查询图书的登记日期信息，升序：*/
create index index_brecord on books(book_record);

/*book_sort*/
/*为sort_id创建索引，升序*/
create index index_sortid on book_sort(sort_id);



/*borrow*/
/*为student_id和book_id创建多列索引*/
create index index_sid_bid on borrow(student_id asc, book_id asc);

/*return_table*/
/*为student_id和book_id创建多列索引：*/
create index index_sid_bid on return_table(student_id asc, book_id asc);


/*ticket*/
/*为student_id和book_id创建多列索引*/
create index index_sid_bid on ticket(student_id asc, book_id asc);

/*manager*/
/*为manager_id创建索引*/
create index index_mid on manager(manager_id);


#在表student, borrow和book上创建借书者的全面信息视图stu_borrow：
create view stu_borrow as
select student.stu_id, books.book_id, student.stu_name, books.book_name, borrow_date,adddate(borrow_date,30) expect_return_date
from student, books, borrow
where student.stu_id = borrow.student_id and books.book_id = borrow.book_id;

#创建个人所有借书归还纪录视图stu_borrow_return
create view stu_borrow_return as
select student.stu_id, student.stu_name, books.book_id, books.book_name,return_table.borrow_date,return_table.return_date
from student, books, return_table
where student.stu_id = return_table.student_id and books.book_id = return_table.book_id;

create view borrowed as
select student.stu_id, books.book_id, books.book_name,borrow.borrow_date,borrow.expect_return_date 
from books,borrow,student
where student.stu_id = borrow.student_id and books.book_id=borrow.book_id;


insert into book_sort values (1,'科技'),(2,'科幻'),(3,'散文'),(4,'小说'),(5,'诗集'),(6,'青春文学');
insert into books values (10001,'海蒂','约翰娜·斯比丽','人民文学出版社',1,'小说','2019-05-06','全书分为两部，《海蒂的学习和漫游岁月》讲述的是小海蒂童年时期的成长历程。《海蒂学以致用》讲述成长起来的海蒂帮助瘫痪姑娘克拉拉重新站立起来的故事。',4);
insert into books values (10002,'人间食粮','安德烈·纪德','中国友谊出版公司',1,'散文集','2019-05-06','这些断想大都从东方传说、圣经故事、尼采著作中获取灵感。通过假想的导师梅纳尔克对其弟子纳塔纳埃尔进行教诲的方式，纪德要人们摒弃一切道德规范和思想习惯，摆脱一切伦理的和精神的引导，任随本能去尽情地享受生活，更好地认识自我和世界。',3),
 (10003,'人间失格','太宰治','现代出版社',1,'小说','2019-05-06','作品中太宰治巧妙地将自己的人生与思想，隐藏于主角叶藏的人生遭遇，藉由叶藏的独白，窥探太宰治的内心世界——“充满了可耻的一生”。在发表该作品的同年，太宰治自杀身亡。',4),
 (10004,'乖，摸摸头','大冰','湖南文艺出版社',1,'青春文学','2019-05-06','《乖，摸摸头》一书记录了大冰十余年的江湖游历，以及他和他朋友们的爱与温暖的传奇故事。这些故事与风花雪月无关，与鸡汤小清新无关，有的是无畏的奋斗和孤身的寻找，有的是疯狂的爱情和极致的浪漫……',6),
 (10005,'阿弥陀佛么么哒','大冰','湖南文艺出版社',1,'青春文学','2019-05-06','《阿弥陀佛么么哒》一书记录了大冰十余年的江湖游历，以及他和他朋友们的爱与温暖的传奇故事。这些故事与风花雪月无关，与鸡汤小清新无关，有的是无畏的奋斗和孤身的寻找，有的是疯狂的爱情和极致的浪漫……',6),
 (10006,'好吗，好的','大冰','湖南文艺出版社',1,'青春文学','2019-05-06','“在最冷的地方，写最暖心的、真实的、善意的、舍不得读完的江湖故事”。',6),
 (10007,'时间简史','史蒂芬-霍金','湖南科学技术出版社',1,'科技','2019-05-06','霍金探究了已有宇宙理论中存在的未解决的冲突，并指出了把量子力学、热动力学和广义相对论统一起来存在的问题，该书的定位是让那些对宇宙学有兴趣的普通读者了解他的理论和其中的数学原理。',1),
 (10008,'三体','刘慈欣','重庆出版社',1,'科幻','2019-05-06','作品讲述了地球人类文明和三体文明的信息交流、生死搏杀及两个文明在宇宙中的兴衰历程。其第一部经过刘宇昆翻译后获得了第73届雨果奖最佳长篇小说奖。',2),
 (10009,'观音','安意如','人民文学出版社',1,'散文','2019-05-06','戏写世道人心，人生百态。戏也是音。观音，观世间疾苦繁华，声声入耳，二在心。古典与时尚的融汇，传统与先锋的结合。',3),
 (10010,'飞鸟集','泰戈尔','上海译文出版社',1,'诗集','2019-05-06','由于诗人忠实于自己的思想，具有敏锐洞察自然、社会的能力和一支善于表达心曲的妙笔，这些形似只言片语的小诗就蕴涵了丰富的思想、深奥的哲理，表现出一种清新明快、优美隽永的风格。',5);
 insert into books values(10011,'小王子','圣埃克苏佩里','浙江人民美术出版社',1,'小说','2019-05-16','本书的主人公是来自外星球的小王子。书中以一位飞行员作为故事叙述者，讲述了小王子从自己星球出发前往地球的过程中，所经历的各种历险。作者以小王子的孩子式的眼光，透视出成人的空虚、盲目，愚妄和死板教条，用浅显天真的语言写出了人类的孤独寂寞、没有根基随风流浪的命运。同时，也表达出作者对金钱关系的批判，对真善美的讴歌。',4),
 (10012,'冰与火之歌-权力的游戏','乔治·R·R·马丁','重庆出版社',1,'小说','2019-05-16','《冰与火之歌：权力的游戏》是乔治·R·R·马丁所著的一部当代奇幻文学小说。讲述了在一片虚构的中世纪大陆上所发生的一系列相互联系的宫廷斗争、疆场厮杀、游历冒险和魔法抗衡的故事，全书七卷（包括未出的各卷）浑然一体，共同组成了一幅壮丽而完整的画卷。',4),
 (10013,'傲慢与偏见','简-奥斯汀','上海译文出版社',1,'小说','2019-05-16','这部作品以日常生活为素材，以反当时社会上流行的感伤小说的内容和矫揉造作的写作方法，生动地反映了18世纪末到19世纪初处于保守和闭塞状态下的英国乡镇生活和世态人情。并多次被改编成电影和电视剧',4),
 (10014,'午夜之子','萨曼·鲁西迪','北京燕山出版社',1,'小说','2019-05-16','此书题材独特，场面恢宏，想象力丰富，情节曲折多变，是二十世纪为数不多的与马尔克斯的《百年孤独》齐名的魔幻现实主义巨作。因诸多原因，中文版直至今日才正式引进出版，可谓姗姗来迟，也难怪问世后业内为之欢呼与兴奋。',4),
 (10015,'平凡的世界','路遥','北京十月文艺出版社',1,'小说','2019-05-16','该书以中国70年代中期到80年代中期十年间为背景，通过复杂的矛盾纠葛，以孙少安和孙少平两兄弟为中心，刻画了当时社会各阶层众多普通人的形象；劳动与爱情、挫折与追求、痛苦与欢乐、日常生活与巨大社会冲突纷繁地交织在一起，深刻地展示了普通人在大时代历史进程中所走过的艰难曲折的道路。1991年3月，《平凡的世界》获中国第三届茅盾文学奖。',4),
 (10016,'流浪地球','刘慈欣','中国科学技术出版社',1,'科幻','2019-05-16','太阳即将毁灭，过去无数岁月中做为人类精神支柱的存在，变成了死亡和恐怖的象征。比起坐以待毙，人类选择挣扎到底。',2),
 (10017,'人性中的善良天使','斯蒂芬·平克','中信出版社',1,'小说','2019-05-16','享誉世界的心理学家、科普作家斯蒂芬·平克关于人性和文明的程碑式巨著；他以暴力的尺度，度量人性的进化，告诉我们过去的世界更加糟糕，事实上，我们正生活在人类历史上最和平的时代。在恐怖主义的阴影还时时闪现、戾气暴虐在身边积聚的今天，这样的作品可以令人视野更加开阔，少些怀疑人生，多些正能量。',4),
 (10018,'深渊上的火','弗洛·文奇','四川科学技术出版社',1,'科幻','2019-05-16','冲突、逃亡、阴谋、复仇，构成波澜壮阔的银河英雄史诗，美国著名科幻编辑多佐伊斯将这类小说称为“大场景科幻壮剧”。正是由于弗诺·文奇的创作，这一类型的作品才能在林林总总的科幻作品中占据一席之地。',4);
 

insert into image values('海蒂','C:\\Users\\钟雷\\Desktop\\book cover\\海蒂.jpg');
insert into image values('好吗，好的','C:\\Users\\钟雷\\Desktop\\book cover\\好吗，好的.jpg');
insert into image values('人间食粮','C:\\Users\\钟雷\\Desktop\\book cover\\人间食粮.jpg');
insert into image values('人间失格','C:\\Users\\钟雷\\Desktop\\book cover\\人间失格.jpg');
insert into image values('乖，摸摸头','C:\\Users\\钟雷\\Desktop\\book cover\\乖，摸摸头.jpg');
insert into image values('阿弥陀佛么么哒','C:\\Users\\钟雷\\Desktop\\book cover\\阿弥陀佛么么哒.jpg');
insert into image values('时间简史','C:\\Users\\钟雷\\Desktop\\book cover\\时间简史.jpg');
insert into image values('三体','C:\\Users\\钟雷\\Desktop\\book cover\\三体.jpg');
insert into image values('飞鸟集','C:\\Users\\钟雷\\Desktop\\book cover\\飞鸟集.jpg');
insert into image values('观音','C:\\Users\\钟雷\\Desktop\\book cover\\暂无图片.jpg');

insert into image values('小王子','C:\\Users\\钟雷\\Desktop\\book cover\\小王子.jpg');
insert into image values('冰与火之歌-权力的游戏','C:\\Users\\钟雷\\Desktop\\book cover\\冰与火之歌.jpg');
insert into image values('傲慢与偏见','C:\\Users\\钟雷\\Desktop\\book cover\\傲慢与偏见.jpg');
insert into image values('午夜之子','C:\\Users\\钟雷\\Desktop\\book cover\\午夜之子.jpg');
insert into image values('平凡的世界','C:\\Users\\钟雷\\Desktop\\book cover\\平凡的世界.jpg');
insert into image values('流浪地球','C:\\Users\\钟雷\\Desktop\\book cover\\流浪地球.jpg');
insert into image values('流人性中的善良天使','C:\\Users\\钟雷\\Desktop\\book cover\\人性中的善良天使.jpg');
 
delimiter //
create procedure newuser(a int,b varchar(20),c varchar(10), d int ,e varchar(15), f varchar(30) ,g varchar(50),h varchar(20),i varchar(20))
begin
insert into student(stu_id,stu_name,stu_sex,stu_age,stu_mobile,stu_email,stu_pro,stu_grade,stu_borrowed) values (a,b,c,d,e,f,g,h,0);
insert into users(username,stu_id) values(i,a);
end
// delimiter ;

call newuser(001,'zhong','male',18,'13886621536','163@163.com','niit','2018','zhong');
insert into manager values(001,001,'zhong','male','13886621536','HaiNan University');
insert into manager values(002,002,'admin','male','13886621536','HaiNan University');


delimiter //
create procedure borrow (a int(11),b int(11),c datetime,d datetime)
begin
insert into borrow values(a,b,c,d);
insert into return_table values(a,b,c,'NO',null);
update student set stu_borrowed = stu_borrowed +1 where stu_id = a;
update books set book_num= 0 where book_id=b;
end
// delimiter ;

delimiter //
create procedure add_book(a varchar(50), b varchar(50), c varchar(100),d varchar(30), e datetime, f varchar(200),g int)
begin
insert into books(book_name,book_author,book_pub,book_num,book_sort,book_record,book_introduction,sort_id) values(a,b,c,1,d,e,f,g);
end
// delimiter ;




