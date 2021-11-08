# MyBatis (10개)
MyBatis는 Java Object와 SQL문 사이의 자동 Mapping 기능을 지원하는 ORM Framerwork. 쉬운 접근성과 코드의 간결함, SQL 문과 프로그래밍 코드의 분리, 다양한 프로그래밍 언어로 구현이 가능하다.

## 객체와 메서드
MyBatis를 Standalone 형태로 사용하는 경우 SqlSessionFactory 객체를 직접 사용

Spring을 사용하는 경우: 
1. 스프링컨테이너에 MyBtais 관련 빈을 등록하여 사용, 트랜젝션 처리 쉬움, Spring 연동 라이브러리 필요
2. 환경설정파일(application-context.xml)에 DataSource 저장 + 트랜잭션 설정(transactionManage) -> @Transactional 선언으로 사용
3. SqlSessionFactoryBean 등록 시 데이터소스와 mybatis설정 정보가 필요
4. mapper 빈 등록 : Mapper 인터페이스를 사용하기 위해 MapperScannerConfigurer와 mapperfactorybean을 사용
6. 데이터 접근 객체 구현 
`@Repository` : 데이터 접근 객체를 빈으로 등록하기 위해 사용
`@Autowired`  : 사용하려는 Mapper 인터페이스를 데이터 접근 객체와 의존관계설정

## 구성 파일

5. MyBatis Configuration 파일 : 
* 스프링을 사용하면, DB 접속 정보 및 Mapper 관련 설정은 스프링 빈으로 등록하여 관리
* `typeAlias`, `typeHandler` 등 마이바티스 환경설정 파일에는 스프링에서 관리하지 않는 일부 정보만 설정한다.
`typeAlias` : 각 **객체에 대한 별칭 설정**


##  태그들과 태그 속성 (sql, selectkey 포함)
1. sql, include 태그 : 반복되는 속성을 묶는다.
```sql
<sql id = "a">
    select * from table1
</sql>
<select id = "getBoardList" resultType = "boardDto">
    <include refif = "a"/>
</select>
```

2. selectkey 엘리먼트 속성
selectkey : 키 생성 태그로 insert 태그 안에서 사용된다.
* keyProperty : selectkey 구문의 결과가 setting 될 대상 프로퍼티
* resultType : 결과 타입
* parameterType : 파라미터 타입
* order : before 나 after를 설정하여 쿼리 수행 전/후에 selectKey가 동작하도록 설정한다
* statementType : statement, preparedStatement, Callable 중 선택 가능. 디폴트 값은 preparedstatement이다.


##  동적 쿼리 태그
마이바티스의 가장 강력한 기능 중 하나는, SQL을 처리하는 방식이다. 간혹 콤마나 공백때문에 한참 디버깅 해본 경험이 있겠지만, 마이바티스는 동적 SQL 언어로 이 상황을 해결했다.<br>
`if`, `choose`(when,otherwise), `trim`(where,set), `foreach`

>### if
동적 SQL에서 가장 많이 사용됨. where의 일부로 포함될 수 있음
```sql
<select id = "methodName" resultType = "MemberDto">
    SELECT * FROM Member
    WHERE last_name = 'Park'
    <if test = "job != null">
    AND job like #{job}
    </if>
</select>

<select id = "methodName2" resultType = "MemberDto">
    SELECT * FROM Member WHERE last_name = 'Park'
    <if test = "job !=null">
    AND job like #{job}
    </if>
    <if test = "department != null and department.name !=null">
    AND department_name like #{department.name}
    </if>
</select>
```

> ### Choose
Choose를 사용하여, jstl의 choose, otherwise처럼 if else if 처럼 사용할 수 있다. 

> ### trim, where, set
 콤마를 제거하거나 prefix나 suffix를 구할 때 사용한다

> ### foreach
루프를 돌릴 떄 사용한다. 

# 테이블 제약 조건
> PK, FK 설정 이유 : 데이터의 무결성 때문<br>
제약 사항 종류

## 제약 조건 
1. 테이블 단위에서 데이터의 무결성을 보장하는 규칙
2. Pk, FK를 설정 : 
3. 테이블 간 제약 조건이 있어서 `종속성`이 있는 경우 테이블 삭제를 방지한다
4. 테이블 수정 작업의 경우 잘못된 트랜젝션을 방지한다

### PK(Primary Key) - 식별자 키
```sql
CREATE TABLE USER(
    id int not null,
    last_name varchar(30) not null,
    first_name varchar(30) not null,
    age int,
    Primary key (id)
);
```
* 테이블의 모든 데이터를 식별한다
* 중복 불가
* Not Null
* 함수적 종속 관계

### FK(Foreign Key) - 참조 키
``` sql
# User 테이블의 id 를 참조한다.
CREATE TABLE ORDER (
    orderId int NOT NULL PRIMARY KEY,
    totalAmount int NOT NULL,
    id int FOREIGN KEY REFERENCES TEST(id)
);
```
* 외부 식별자키로 테이블간의 관계 정의
* 두 테이블 간의 종속이 필요한 관계면, **접점이 되는 컬럼을 FK 로 지정**하여 **서로 참조할 수 있도록** 관계를 맺어줌
* **테이블 간 잘못된 매핑 방지**

이 외에도, `Unique`, `Not Null`, `Check` [ex : Check(age>=18) ], `Default` 가 있다.

# Index 특징
인덱스를 사용하면, CRUD 성능은 저하되지만, 읽기 검색(select) 성능은 향상된다. 따라서, 한 테이블에서 너무나 많은 컬럼에 인덱스를 생성하면 데이터 저장 성능이 떨어진다.

* Primary Key : 테이블이 하나의 레코드를 대표하는 컬럼값으로 만들어진 인덱스
* Secondary Key : Primary key를 제외한 모든 인덱스

# Select
1. 실행 순서
2. 연산자 (like, in, not in ,is null 등)

### 실행 순서
#### 문법 작성 순서 
1. select 컬럼명
2. from 테이블명
3. where 조건식
4. group by 컬럼명
5. having 조건식
6. order by 컬럼명

#### 실행 작동 순서
1. from
2. on
3. join
4. where
5. group by
6. having
7. select
8. distinct
9. order by

> ### SQL 쿼리문
> INSERT, UDPATE, DELETE, SELECT - DML (테이블 변경/행입력/검색)
CREATE, ALTER,DROP, RENAME - DDL (데이터 구조 생성, 변경 ,제거) 
COMMIT, ROLLBACK - DML 명령문으로 수행한 변경 관리
GRAN, REVOKE - DCL (접근 권한 제공 제거)

### INSERT 쿼리
```sql
INSERT INTO MEMBER (id, name, pswd, email)
VALUES ('kwwaj22','George Laymond', 'fajslfksjk~' , 'kkwaj22@gmail.com');
```
### UPDATE 쿼리 
#### **WHERE 절을 생략하면 모든 데이터가 바뀐다**
```SQL
UPDATE MEMBER
# SET 키워드를 사용하여, 바꾸려는 정보 set
SET pswd = '2342', name = 'George Laymonds'
# WHERE 로 조건을 준다
WHERE id = 'kwwaj22';
```

### DELETE FROM 쿼리 
#### **WHERE 절을 생략하게되면 모든 데이터가 삭제된다**
```sql
DELETE FROM MEMBER
WHERE id = 'kwwaj22';
```

### SELECT 쿼리 
#### ALL(*) , DISTINCT - 중복행 제거, COLUMN - from절에 나열된 테이블에서 지정된 열, EXPRESSION, ALIAS
```sql
SELECT id as 아이디, pswd as 비밀번호 FROM MEMBER;


# CASE : if, else if 같은 조건
SELECT id, name,
        CASE WHEN salary>15000 then 'senior',
             WHEN salary > 8000 then 'junior',
             ELSE 'starting'
             END 'position'
FROM EMPLOYEES;

# IN : 부서 번호가 50,60,70 인 사원 선택
SELECT id from EMPLOYEES 
WHERE department_id in (50,60,70);

#LIKE : %x : x로 시작, %x% : x 포함, %x ~~x 로 끝남
```

# JOIN
둘 이상의 테이블에서 데이터가 필요한 경우 테이블 조인이 필요.
조인 조건은 일반적으로 각 테이블의 pk 및 fk 로 구성된다.
JOIN의 종류 : inner join, outer join, cross join, natural join

[JOIN 시 주의] 어느 테이블을 먼저 읽을지 결정하는 것이 중요함<br>
* INNER JOIN - 어느 테이블을 읽어도 결과가 달라지지 않아 mySQL 옵티마이저가 조인의 순서 조절
* OUTER JOIN - 읽는 순서에 따라 결과가 달라지기 때문에 직접 순서를 결정해야 한다.

### INNER JOIN
가장 일반적인 JOIN, 교집합
```sql
# SYNTAX
SELECT COL1, COL2, COL3 FROM TABLE1 INNER JOIN TABLE2
#ON 을 사용하여 JOIN의 조건을 지정할 수 있다.
ON TABLE1.COLUMN = TABLE2.COLUMN
WHERE CONDITION;
```
EXAMPLE :
```SQL
SELECT e.employee_id, e.department_id, d.department_name
from employees e inner join  department d
on e.department_id = d.department_id
where e.employee_id = 100;
```

### OUTER JOIN : LEFT OUTER JOIN 과 RIGHT OUTER JOIN
어느 한쪽 테이블에는 해당 데이터가 존재하는데 다른 테이블에 없는 경우의 문제점을 해결하기 위해 사용한다
1. LEFT OUTER JOIN 
왼쪽 테이블을 기준으로 JOIN 조건에 일치하지 않는 데이터까지 출력
```SQL
SELECT COL1, COL2, ... COLN
FROM TABLE1 LEFT OUTER JOIN TABLE2
ON OR USING;
```
2. RIGHT OUTER JOIN
오른쪽 테이블을 기준으로 JOIN 조건에 일치하지 않는 데이터까지 출력
3. FULL OUTER JOIN
양쪽 테이블을 기준으로 JOIN 조건에 일치하지 않는 데이터까지 출력
### NATURAL JOIN
```sql
SELECT CO1, COL2, FROM TABLE1 NATURALJOIN TABLE2;
```
### SELF JOIN
같은 테이블끼리 JOIN

### SUBQUERY
```SQL
SELECT ID, NAME, DEPT_ID
FROM EMPLOYEES
WHERE DEPT_ID = (
    SELECT DEPT_ID 
    FROM EMPLOYEES
    WHERE NAME = 'EVE'
);
```


# 트랜젝션 2개
Transaction : 데이터베이스의 상태를 변화시키는 일종의 작업 단위
Commit 과 Rollback<br>
* `start transaction` : commit, rollback 이 나올때 까지 실행되는 모든 sql
* `commit` : 모든 코드를 실행
* `rollback` : start transaction 실행 전 상태로 되돌림

# 집계함수, 그룹 함수
### 집계 함수
> ### sum, avg, count
```sql
    select sum(salary) from employees;
    select avg(salary) from employees;
    select count(*) from employees;
```

### 그룹함수
> ### GROUP BY 와 HAVING
그룹화하여 데이터를 조회
** where은 그룹화 하기전, having은 그룹화 한 후 조건임
```sql
# Syntax
SELECT columnNames FROM tablename
WHERE condition
GROUP BY columnNames
HAVING condition
```
1. GROUP BY : 컬럼의 unique값에 따라 데이터를 그룹짓고 중복된 열을 제거
| id  | job  | name  |
|:-:|---|---|
| 1  | clerk  | Jasmine  |
| 2  | infotech  | Chris  |
| 3  | clerk  | Henry  |
| 4  | pm  | David  |

위와 같은 테이블이 있을 떄, 
```sql
SELECT job , count(*) from employees
GROUP BY job;
```
위 sql 쿼리를 실행하면 job의 개수를 job에 따라 카운트한다
| job  | count  |
|:-:|---|
| clerk  | 2  |
| infotech  | 1  |
| pm  | 1  | 

2.Having
Having은 group by 에 조건을 붙이고 싶을 때 where 처럼 사용한다
```sql
SELECT job , count(*) from employees
GROUP BY job
HAVING count(*)>1;
```
위 sql 쿼리를 실행하면 job이 1개보다 큰 직종만 프린트 된다.
| job  | count  |
|:-:|---|
| clerk  | 2  |
