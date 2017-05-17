create database bbs;

use bbs;

create table article(
	id int primary key auto_increment,
	parentId int,
	rootId int,
	title varchar(255),
	content text,
	publishDate datetime,
	isLeaf boolean
);

insert into article values (null, 0, 1, '蚂蚁大战大象', '蚂蚁大战大象', now(), false);
insert into article values (null, 1, 1, '大象被打趴下了', '大象被打趴下了',now(), false);
insert into article values (null, 2, 1, '蚂蚁也不好过','蚂蚁也不好过', now(), true);
insert into article values (null, 2, 1, '瞎说', '瞎说', now(), false);
insert into article values (null, 4, 1, '没有瞎说', '没有瞎说', now(), true);
insert into article values (null, 1, 1, '怎么可能', '怎么可能', now(), false);
insert into article values (null, 6, 1, '怎么没有可能', '怎么没有可能', now(), true);
insert into article values (null, 6, 1, '可能性是很大的', '可能性是很大的', now(), true);
insert into article values (null, 2, 1, '大象进医院了', '大象进医院了', now(), false);
insert into article values (null, 9, 1, '护士是蚂蚁', '护士是蚂蚁', now(), true);