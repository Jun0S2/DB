use scott;
select * from emp;
select * from dept; -- 안에 5개밖에 없음

#1.  emp 와 dept table을 조인하여 이름 급여 부서명 검색
select 
		e.ename 이름, 
        e.sal 급여, 
        d.dname 부서명 -- 이름 급여 부서명(dname in dept table)
from emp e-- original
inner join dept d USING(deptno); -- equals operators can be replaced by tableB using (common var)

#2. 이름이 King 인 사원의 부서명을 검색하시오
select 
		e.ename 이름,
		d.dname 부서명
from emp e
inner join dept d on e.ename='KING';

#3. dept table에 있는 모든 부서 출력 & emp table 에 있는 data와 join하여 모든 사원이름부서번호부서명급여 출력
-- print all dept table -> left join with emp table
select 
		d.dname 부서명,
        e.ename 사언이름,
        e.deptno 부서번호,
        e.sal 급여
from dept d  -- using left join from dept d: all the departments will be printed out + along with the other info that was requested
left join emp e USING(deptno);

#4.emp table에 있는 empno와 mgr이용하여 서로 관계를 'Scott의 메니저는 Jones이다' 와같이 출력
-- so... Scott is employee, and Jones is manager
-- self-join question: reference with empno
select 
-- 		e.empno 사원번호, --확인용 
		e.ename 사원,
 --        m.empno 메니저번호, --확인용
        m.ename 매니저
from emp e -- 기준 테이블 
left join emp m USING(mgr)
order by m.empno;

#5. 'scott'의 직무와 같은 사람의 이름 부서명 급여 직무를 검색하세요
-- same position?? job 이 같은거 ...?? -> analyst 찾기..?
select
		e.ename 이름,
        d.dname 부서명,
        e.sal 급여,
        e.job 직무  
from emp e
-- join the table
inner join dept d using(deptno)
-- Find Scott's job title:
where e.job = (
		select job -- scope: job
		from emp   -- table: emp
		where ename='scott'-- condition
);

#6. 'scott'이 속해있는 부서의 모든 사람의 사원번호이름입사일급여
select 
-- 	  e.deptno 확인용, : dept no -> 20 
	  e.empno 사원번호,
      e.ename 이름,
      e.hiredate 입사일,
      e.sal 급여
from emp e
inner join dept d using (deptno)
-- deptno are the comman val
where e.deptno = (
		select deptno -- scope: department no.
        from emp -- table: emp
        where ename='scott' -- condition: name with Scott-> has to have matching deptno val with him 
);


#7. 전체 사원의 평균급여보다 급여 많은 사람 번호/이름/부서명/입사일/region/급여
select
		e.empno `사원 번호`,
        e.ename 이름,
        d.dname 부서이름,
        e.hiredate 입사일,
        d.loc 지역,
        e.sal 급여
from emp e -- main table
inner join dept d using(deptno)
where e.sal > ( -- condition : greater
		select avg(sal) -- avg sal
        from emp
);

#8. 30번 부서와 같은 일을 하는 사람 사원번호/이름/부서명/지역/급여 -> 급여highest순
select
-- 		e.deptno 확인용, : all 30
		e.empno 사원번호,
        e.ename 이름,
		d.dname 부서명,
        d.loc 지역,
		e.sal 급여
from emp e
inner join dept d using(deptno)
where e.deptno=30
order by sal desc;

#9. 10번 부서 중에서 30번 부서에 없는 업무를 하는 사원의 사원번호 이름 부서명 입사일 지역 
-- diff job: not in?
select
-- 		e.job 확인용,
		e.empno 사원번호,
        e.ename 이름,
        d.dname 부서명,
        e.hiredate 입사일
from emp e
inner join dept d using(deptno)
where e.job not in (
		select job
        from emp 
        where deptno=30
);

#10. king or james 의 급여와 같은 사원의 사원번호이름급여 
-- join not needed 
-- king 과 james밖에 없다...
select 
		e.empno 사원번호,
        e.ename 사원이름,
        e.sal 급여
from emp e
where e.sal in (
		select sal
        from emp
        where ename in('king','james')
	);

#11. 급여가 30번 부서의 최고 급여보다 높으 사원번호 이름 급여
select
		e.empno 사원번호,
        e.ename 이름,
        e.sal   급여
from emp e
where e.sal > (
		select max(sal)
        from emp
        where deptno=30
);

#12. 이름 검색을 보다 빠르게 수행하기 위해 emp 테이블에 ename 인덱스를 생성하시오
-- index problemo
-- create index idx_emp_ename on emp(ename);

#13. 이름 'Allen'인 사원과 입사연도가 같은 사원 이름과 급여를 출력
select
		e.hiredate 입사연도,
        e.ename 이름,
        e.sal 급여
from emp e
where year(e.hiredate)=(       -- Allen's hire year
		select year(hiredate)  -- compare hire year
        from emp
        where ename='Allen'
);

#14. 부서별 급여의 합계를 출력하는 view 작성
create or replace view empDeptSalSumView
as
select 
		deptno 부서번호,
        sum(sal) `부서별 급여의 합계`
from emp
group by deptno;

select * from empDeptSalSumView; -- 출력

#15. 14번에서 작성된 view를 이용하여 부서별 급여의 합계가 큰 1-3순위 출력
select  *
from empDeptSalSumView
order by `부서별 급여의 합계` desc;









 
  