with mp as (SELECT mt_cd
				        ,SUM(placeod_qt) AS safe_stk_qt
				FROM mt_placeod 
				WHERE placeod_reqdt BETWEEN TO_CHAR(add_months(SYSDATE, -1), 'yyyy-mm-dd') AND TO_CHAR(SYSDATE, 'yyyy-mm-dd')
				GROUP BY mt_cd)

SELECT  
        m.mt_cd,
        m.mt_div,
        m.mt_name,
        m.cost,
        m.unit,
        m.exp_dt,
        m.leadtm,
        m.safe_stk_rate,
        m.cli_cd,
        c.cli_name,
        mp.safe_stk_qt
FROM 	mt m 
JOIN    cli c
ON 		m.cli_cd = c.cli_cd
JOIN    mp
ON      m.mt_cd = mp.mt_cd
WHERE 	m.mt_div = '원자재'
ORDER BY mt_cd;

SELECT  *
FROM    mt_send ms
JOIN    mt m
ON      m.mt_cd
WHERE   send_compdt BETWEEN ADD_MONTHS(SYSDATE,-1) AND SYSDATE;
SELECT mp.mt_cd
				        ,SUM(ms.stk_qt) AS sum_stk_qt
				        ,SUM(mp.placeod_qt) AS safe_stk_qt
				        ,SUM(ms.stk_qt) as nn
		                ,SUM(mp.placeod_qt) AS qt_difference
				FROM mt_placeod mp 
				JOIN mt_stk ms
				  ON ms.mt_cd = mp.mt_cd
				WHERE placeod_reqdt BETWEEN TO_CHAR(add_months(SYSDATE, -1), 'yyyy-mm-dd') AND TO_CHAR(SYSDATE, 'yyyy-mm-dd')
				GROUP BY mp.mt_cd;


SELECT *
FROM BOM;
SELECT SUM(b.consum) as mt_qt
		                                                                    
		                                                            FROM    pdt_inst_detail pd
		                                                            JOIN    bom b
		                                                            ON      b.pd_cd = pd.pd_cd
		                                                            WHERE   pdt_inst_no = 121 and unit = 'Box';
		                                                            GROUP BY b.unit

-- 금일 생산지시 현황
		with pd as (SELECT  pd.pd_cd
		                    ,b.mt_cd
		                    ,CASE WHEN b.unit = 'Bag' THEN SUM(b.consum) / 15
		                          WHEN b.unit = 'Box' THEN (SELECT  SUM(mt_qt) * 2
		                                                    FROM    (SELECT SUM(b.consum) as mt_qt
		                                                                    ,b.unit
		                                                            FROM    pdt_inst_detail pd
		                                                            JOIN    bom b
		                                                            ON      b.pd_cd = pd.pd_cd
		                                                            WHERE   pdt_inst_no = (SELECT  DISTINCT pdt_inst_no
		                                                                                     FROM  pdt_inst_detail
		                                                                                    WHERE  TO_CHAR(PDT_STT_TIME, 'yyyy-MM-dd') = TO_CHAR(sysdate, 'yyyy-MM-dd')) AND unit = 'Box'
                                                                                            AND comp_st = 1
		                                                            GROUP BY b.unit))
		                          WHEN b.unit = 'pcs' THEN SUM(b.consum) * 2
		                    END as mt_qt
		                    ,b.unit
		            FROM    pdt_inst_detail pd
		            JOIN    bom b
		            ON      b.pd_cd = pd.pd_cd
		            WHERE   pdt_inst_no = (SELECT  DISTINCT pdt_inst_no
		                                     FROM  pdt_inst_detail
		                                    WHERE  TO_CHAR(PDT_STT_TIME, 'yyyy-MM-dd') = TO_CHAR(sysdate, 'yyyy-MM-dd'))
		                    AND comp_st = 1
		            GROUP BY pd.pd_cd, b.mt_cd, b.unit)
		            ,
		
		-- 자재별 재고 수량 합            
		msq as (SELECT  mt_cd
		                ,SUM(stk_qt) as sum_stk_qt
		        FROM    mt_stk
		        GROUP BY mt_cd)
		
		SELECT  DISTINCT 
		        m.mt_cd
		        ,m.mt_div
		        ,m.mt_name
		        ,pd.mt_qt
		        ,pd.unit
		        ,msq.sum_stk_qt
		        ,msq.sum_stk_qt - pd.mt_qt as re_stk_qt
		FROM    mt m
		JOIN    pd
		ON      m.mt_cd = pd.mt_cd
		JOIN    mt_stk ms
		ON      m.mt_cd = ms.mt_cd
		JOIN    msq
		ON      msq.mt_cd = m.mt_cd
		ORDER BY mt_div DESC;


SELECT  pd.pd_cd
        ,b.mt_cd
        ,CASE WHEN b.unit = 'Bag' THEN SUM(b.consum) / 15
              WHEN b.unit = 'Box' THEN SUM(b.consum)
              WHEN b.unit = 'pcs' THEN SUM(b.consum)
        END as mt_qt
        ,b.unit
FROM    pdt_inst_detail pd
JOIN    bom b
ON      b.pd_cd = pd.pd_cd
WHERE   pdt_inst_no = 87
GROUP BY pd.pd_cd, b.mt_cd, b.unit;

SELECT  *
FROM    pdt_inst_detail
WHERE   TO_CHAR(PDT_STT_TIME, 'yyyy-MM-dd') = TO_CHAR(sysdate, 'yyyy-MM-dd');
select SEQ_MT_SEND_NO.nextval
from dual;

ALTER TABLE mt_send DROP CONSTRAINT FK_GRADE;
select *
from mt_send;

select *
from mt_str;


--분류, 자재코드, 자재명, 입고수량, 단위, 입고일자, 담당자
SELECT  m.mt_div
        ,m.mt_cd
        ,m.mt_name
        ,ms.str_qt
        ,m.unit
        ,ms.str_compdt
        ,ms.str_chg
FROM    mt_str ms
JOIN    mt m
ON      m.mt_cd = ms.mt_cd
ORDER BY str_compdt DESC;

--분류, 자재코드, 자재명, 출고수량, 단위, 출고일자, 자재LOT, 담당자
SELECT  m.mt_div
        ,m.mt_cd
        ,m.mt_name
        ,ms.send_qt
        ,m.unit
        ,ms.mt_lot
        ,ms.send_compdt
        ,ms.send_chg
FROM    mt_send ms
JOIN    mt_stk mk
ON      mk.mt_lot = ms.mt_lot
JOIN    mt m
ON      m.mt_cd = mk.mt_cd
ORDER BY send_compdt DESC;

--분류, 자재코드, 자재명, 반품수량, 단위, 반품일자, 담당자
SELECT  m.mt_div
        ,m.mt_cd
        ,m.mt_name
        ,mr.rtn_qt
        ,m.unit
        ,mr.rtn_compdt
        ,mr.rtn_chg
FROM    mt_rtn mr
JOIN    mt m
ON      m.mt_cd = mr.mt_cd
ORDER BY rtn_compdt DESC;


select *
from mt_rtn;

select *
from pd;

select *
from pdt_inst_detail;

SELECT  mt_lot, stk_qt
    FROM    (SELECT mt_lot, stk_qt
            FROM    (SELECT *
                    FROM mt_stk
                    WHERE stk_qt > 0)
            WHERE mt_cd = mtCd
            ORDER BY exp_dt)
    WHERE ROWNUM = 1;

select *
from bom;

SELECT  pdt_inst_detail_no
FROM    (SELECT  pd.pdt_inst_detail_no, pd.pd_cd, pd.pdt_inst_no, b.mt_cd
        FROM  pdt_inst_detail pd
        JOIN  bom b
        ON    pd.pd_cd = b.pd_cd
        WHERE  TO_CHAR(PDT_STT_TIME, 'yyyy-MM-dd') = TO_CHAR(sysdate, 'yyyy-MM-dd')
        AND pd.comp_st = 1
        AND b.mt_cd = 'MCV02')
WHERE ROWNUM = 1;

SELECT  mt_lot, stk_qt 
    FROM    (SELECT mt_lot, stk_qt
            FROM    (SELECT *
                    FROM mt_stk
                    WHERE stk_qt > 0)
            WHERE mt_cd = 'MCV02'
            ORDER BY exp_dt)
    WHERE ROWNUM = 1;

-- 금일 생산지시 현황
with pd as (SELECT  pd.pd_cd
                    ,b.mt_cd
                    ,CASE WHEN b.unit = 'Bag' THEN SUM(b.consum) / 15
                          WHEN b.unit = 'Box' THEN (SELECT  SUM(mt_qt) * 2
                                                    FROM    (SELECT SUM(b.consum) as mt_qt
                                                                    ,b.unit
                                                            FROM    pdt_inst_detail pd
                                                            JOIN    bom b
                                                            ON      b.pd_cd = pd.pd_cd
                                                            WHERE   pdt_inst_no = (SELECT  DISTINCT pdt_inst_no
                                                                                     FROM  pdt_inst_detail
                                                                                    WHERE  TO_CHAR(PDT_STT_TIME, 'yyyy-MM-dd') = TO_CHAR(sysdate, 'yyyy-MM-dd')) and unit = 'Box'
                                                            GROUP BY b.unit))
                          WHEN b.unit = 'pcs' THEN SUM(b.consum) * 2
                    END as mt_qt
                    ,b.unit
            FROM    pdt_inst_detail pd
            JOIN    bom b
            ON      b.pd_cd = pd.pd_cd
            WHERE   pdt_inst_no = (SELECT  DISTINCT pdt_inst_no
                                     FROM  pdt_inst_detail
                                    WHERE  TO_CHAR(PDT_STT_TIME, 'yyyy-MM-dd') = TO_CHAR(sysdate, 'yyyy-MM-dd'))
                    AND comp_st = 1
            GROUP BY pd.pd_cd, b.mt_cd, b.unit)
            ,

-- 자재별 재고 수량 합            
msq as (SELECT  mt_cd
                ,SUM(stk_qt) as sum_stk_qt
        FROM    mt_stk
        GROUP BY mt_cd)

SELECT  DISTINCT 
        m.mt_cd
        ,m.mt_div
        ,m.mt_name
        ,pd.mt_qt
        ,pd.unit
        ,msq.sum_stk_qt
        ,msq.sum_stk_qt - pd.mt_qt as re_stk_qt
FROM    mt m
JOIN    pd
ON      m.mt_cd = pd.mt_cd
JOIN    mt_stk ms
ON      m.mt_cd = ms.mt_cd
JOIN    msq
ON      msq.mt_cd = m.mt_cd
ORDER BY mt_div DESC;



SELECT  ms.mt_cd
        ,msq.sum_stk_qt

FROM    mt_stk ms
JOIN    (SELECT mt_cd, SUM(stk_qt) as sum_stk_qt
        FROM mt_stk
        GROUP BY mt_cd
        ) msq
ON      msq.mt_cd = ms.mt_cd
ORDER BY exp_dt;

SELECT  mt_cd
        ,SUM(stk_qt)
FROM    mt_stk
GROUP BY mt_cd;

select *
from mt_stk
ORDER BY exp_dt;
select *
from mt_send;
SELECT *
FROM MT_STK;

select *
from mt_placeod
order by mt_placeod_cd desc;

SELECT  SUM(mt_qt)
FROM    (SELECT SUM(b.consum) as mt_qt
                ,b.unit
        FROM    pdt_inst_detail pd
        JOIN    bom b
        ON      b.pd_cd = pd.pd_cd
        WHERE   pdt_inst_no = 87 and unit = 'Box'
        GROUP BY b.unit)
WHERE unit = 'Box';


create sequence seq_mt_send_no;


create or replace PROCEDURE mt_sending
/*
//
// 프로시져명 : 자재 출고 처리
// 작 성 자 : 전상진
// 작 성 일 : 2024-04-16
// 작성 내용 : 자재출고테이블에 인서트 및 자재재고테이블 업데이트

// 최종수정자 : 
// 수 정 일 : 
// 사 용 예 : MAPPER 사용법  
            CALL MT_STORING(
                #{strQt, mode=INOUT, jdbcType=INTEGER},
                #{strChg, mode=IN, jdbcType=VARCHAR},
                #{mtPlaceodCd, mode=IN, jdbcType=VARCHAR},
                #{mtCd, mode=IN, jdbcType=VARCHAR},
                #{expDt, mode=IN, jdbcType=INTEGER})
//
*/
(mtCd IN VARCHAR2
,mtQt IN NUMBER
,sendChg IN VARCHAR2)
IS
    v_mtLot VARCHAR2(100);
    v_mtLotT VARCHAR2(100);
    v_stkQt NUMBER;
    v_stkQtT NUMBER;
    v_reStkQt NUMBER;
    v_reStkQtT NUMBER;
    v_pdtInstNo NUMBER;
BEGIN
    SELECT  DISTINCT pdt_inst_no INTO v_pdtInstNo
      FROM  pdt_inst_detail
     WHERE  TO_CHAR(PDT_STT_TIME, 'yyyy-MM-dd') = TO_CHAR(sysdate, 'yyyy-MM-dd');  

    SELECT  mt_lot, stk_qt INTO v_mtLot, v_stkQt
    FROM    (SELECT mt_lot, stk_qt
            FROM    (SELECT *
                    FROM mt_stk
                    WHERE stk_qt > 0)
            WHERE mt_cd = mtCd
            ORDER BY exp_dt)
    WHERE ROWNUM = 1;

    v_reStkQt := v_stkQt - mtQt;
    
    IF v_reStkQt > 0 THEN 
    
        INSERT INTO mt_send( MT_SEND_NO , SEND_QT , SEND_COMPDT , SEND_CHG , MT_LOT  , PDT_INST_NO )
        VALUES( SEQ_MT_SEND_NO.nextval, mtQt, SYSDATE, sendChg, v_mtLot, v_pdtInstNo );
        
        UPDATE  mt_stk
        SET     stk_qt = v_reStkQt
        WHERE   mt_lot = v_mtLot;
    
    ELSE 
        
        INSERT INTO mt_send( MT_SEND_NO , SEND_QT , SEND_COMPDT , SEND_CHG , MT_LOT  , PDT_INST_NO )
        VALUES( SEQ_MT_SEND_NO.nextval, v_stkQt, SYSDATE, sendChg, v_mtLot, v_pdtInstNo );
        
        UPDATE  mt_stk
        SET     stk_qt = 0
        WHERE   mt_lot = v_mtLot;
    
        SELECT  mt_lot, stk_qt INTO v_mtLotT, v_stkQtT
        FROM    (SELECT mt_lot, stk_qt
                FROM    (SELECT *
                        FROM mt_stk
                        WHERE stk_qt > 0)
                WHERE mt_cd = mtCd
                ORDER BY exp_dt)
        WHERE ROWNUM = 1;
        
        v_reStkQtT := v_stkQtT + v_reStkQt;
        
        INSERT INTO mt_send( MT_SEND_NO , SEND_QT , SEND_COMPDT , SEND_CHG , MT_LOT  , PDT_INST_NO )
        VALUES( SEQ_MT_SEND_NO.nextval, -v_reStkQt, SYSDATE, sendChg, v_mtLotT, v_pdtInstNo );
        
        UPDATE  mt_stk
        SET     stk_qt = v_reStkQtT
        WHERE   mt_lot = v_mtLotT;  
        
    END IF;

END mt_sending;
/

SELECT  mt_lot, stk_qt
FROM    (SELECT mt_lot, stk_qt
        FROM    (SELECT *
                FROM mt_stk
                WHERE stk_qt > 0)
        WHERE mt_cd = 'MCT01'
        ORDER BY exp_dt)
WHERE ROWNUM = 1;

UPDATE  pdt_inst_detail
SET     comp_st = 2
WHERE   pdt_inst_no = (SELECT  DISTINCT pdt_inst_no
                                     FROM  pdt_inst_detail
                                    WHERE  TO_CHAR(PDT_STT_TIME, 'yyyy-MM-dd') = TO_CHAR(sysdate, 'yyyy-MM-dd'));
                                    
SELECT pdt_inst_detail_no
FROM pdt_inst_detail
WHERE   pdt_inst_no = (SELECT  DISTINCT pdt_inst_no
                                     FROM  pdt_inst_detail
                                    WHERE  TO_CHAR(PDT_STT_TIME, 'yyyy-MM-dd') = TO_CHAR(sysdate, 'yyyy-MM-dd'));

SELECT *
FROM pdt_inst_detail
WHERE   pdt_inst_no = (SELECT  DISTINCT pdt_inst_no
                                     FROM  pdt_inst_detail
                                    WHERE  TO_CHAR(PDT_STT_TIME, 'yyyy-MM-dd') = TO_CHAR(sysdate, 'yyyy-MM-dd'));
select *
from mt_stk;
select *
from mt_send;

select *
from mt;
select *
from mt_placeod;

select *
from bom;

SELECT *
FROM mt_send;

select *
from cli;

--분류, 자재코드, 자재명, 단위, 요청수량, 요청일, 요청자
SELECT m.mt_div, mk.mt_cd, m.mt_name, m.unit, ms.send_qt, ms.send_reqdt, ms.send_requester
FROM mt_send ms
JOIN mt_stk mk
ON ms.mt_lot = mk.mt_lot
JOIN mt m
ON m.mt_cd = mk.mt_cd;
SELECT 	c.cli_cd
				,c.cli_name
				,m.mt_cd
				,m.mt_name
				,mp.placeod_compdt
				,mp.placeod_chg
				,mp.mt_placeod_cd
				,FIND_CODE_NAME ('placeod_st', mp.placeod_st) AS st
		FROM 	(SELECT * 
				FROM 	mt_placeod 
				WHERE	placeod_st BETWEEN 2 and 7) mp
		JOIN 	mt m
		ON 		mp.mt_cd = m.mt_cd
		JOIN 	cli c
		ON 		m.cli_cd = c.cli_cd
		ORDER BY placeod_compdt DESC;
select * from mt_placeod;
SELECT *
FROM MT_PLACEOD;
ORDER BY 1;

select *
from pdt_inst;
select *
from pdt_inst_detail;
select *
from pdt_inst_detail
where pdt_inst_no = 1;

select *
from com_cd;

insert into com_cd
values('placeod_st', '발주상태', null);

insert into com_detail_cd (wk_cd_no, detail_cd_no, detail_cd_name )
values( 'placeod_st', 1, '발주요청');
insert into com_detail_cd (wk_cd_no, detail_cd_no, detail_cd_name )
values( 'placeod_st', 2, '발주완료');
insert into com_detail_cd (wk_cd_no, detail_cd_no, detail_cd_name )
values( 'placeod_st', 3, '입고대기');
insert into com_detail_cd (wk_cd_no, detail_cd_no, detail_cd_name )
values( 'placeod_st', 4, '검사요청');
insert into com_detail_cd (wk_cd_no, detail_cd_no, detail_cd_name )
values( 'placeod_st', 5, '검사완료');
insert into com_detail_cd (wk_cd_no, detail_cd_no, detail_cd_name )
values( 'placeod_st', 6, '입고완료');
insert into com_detail_cd (wk_cd_no, detail_cd_no, detail_cd_name )
values( 'placeod_st', 7, '반품처리');

SELECT  detail_cd_no
        ,detail_cd_name
        ,wk_cd_no
FROM    com_detail_cd
WHERE   wk_cd_no = 'placeod_st';

select *
from cli;
자재명
단위
수량
단가
금액;
SELECT 	c.cli_cd
				,c.cli_name
				,m.mt_cd
				,m.mt_name
				,mp.placeod_compdt
				,mp.placeod_chg
				,mp.mt_placeod_cd
				,FIND_CODE_NAME ('placeod_st', mp.placeod_st) AS st
		FROM 	mt_placeod mp
		JOIN 	mt m
		ON 		mp.mt_cd = m.mt_cd
		JOIN 	cli c
		ON 		m.cli_cd = c.cli_cd
		WHERE	mp.placeod_st BETWEEN 2 and 7

		ORDER BY placeod_compdt DESC;
SELECT  cli_name
        ,bussno
        ,addr
        ,cli_chg
        ,tel
        ,mail
        ,       --납기일자 = 발주일자 + 자재테이블 리드타임
        ,

;
SELECT  c.cli_cd
		        ,c.cli_name
		        ,c.bussno
		        ,c.tel
		        ,c.addr
		        ,c.mail
		        ,c.cli_chg
		        ,TO_CHAR(mp.placeod_compdt, 'YYYY-MM-DD') as placeod_compdt
		        ,m.mt_cd
		        ,m.mt_name
		        ,mp.placeod_qt
		        ,m.unit
		        ,m.cost
		        ,(mp.placeod_qt * m.cost) as placeod_cost
		        ,mp.placeod_chg
		        ,mp.placeod_compdt + m.leadtm as dueDt
		FROM    mt_placeod mp
		JOIN    cli c
		ON      mp.cli_cd = c.cli_cd
		JOIN    mt m
		ON      mp.mt_cd = m.mt_cd
		WHERE   mt_placeod_cd = 212;
select mp.placeod_compdt,(mp.placeod_compdt + m.leadtm) as dt
from mt_placeod mp
join mt m
on m.mt_cd = mp.mt_cd;



select *
from mt;
발주일
자재코드
자재명
발주수량
자재단위
자재단가
발주금액
발주 담당자;
SELECT  c.cli_cd
        ,c.cli_name
        ,c.bussno
        ,c.tel
        ,c.addr
        ,c.mail
        ,c.cli_chg
        ,mp.placeod_
        ,mp.placeod_compdt
        ,m.mt_cd
        ,m.mt_name
        ,mp.placeod_qt
        ,m.unit
        ,m.cost
        ,(mp.placeod_qt * m.cost) as placeod_cost
        ,mp.placeod_chg
FROM    mt_placeod mp
JOIN    cli c
ON      mp.cli_cd = c.cli_cd
JOIN    mt m
ON      mp.mt_cd = m.mt_cd
WHERE   mt_placeod_cd = 210;


--거래처명, 자재명, 발주완료일, 담당자, 상태
SELECT c.cli_cd, c.cli_name, m.mt_cd, m.mt_name, mp.placeod_compdt, mp.placeod_chg, CASE mp.placeod_st WHEN 2 THEN '발주완료' 
                                                                                                       WHEN 3 THEN '입고대기' 
                                                                                                       WHEN 4 THEN '검사요청' 
                                                                                                       WHEN 5 THEN '검사완료' 
                                                                                                       WHEN 6 THEN '입고완료' 
                                                                                                       WHEN 7 THEN '반품처리' 
                                                                                    END AS st
FROM mt_placeod mp
JOIN mt m
ON mp.mt_cd = m.mt_cd
JOIN cli c
ON m.cli_cd = c.cli_cd
ORDER BY placeod_compdt DESC;


SELECT  ms.mt_lot,
        ms.stk_qt,
        ms.exp_dt,
        ms.mt_cd,
        ms.mt_str_no;
    
        select *
        from mt_placeod;
FROM    mt_stk ms JOIN mt m
ON      ms.mt_cd = m.mt_cd;
JOIN    ;

-----------------------------------------------------------------
-- 발주진행중인 자재 수량
with p as (SELECT mp.mt_cd, 
                 SUM(mp.placeod_qt) as pqd
            FROM (SELECT mt_cd
                        ,placeod_qt  
                    FROM mt_placeod 
                    WHERE placeod_st BETWEEN 2 AND 5) mp 
            JOIN mt_stk ms
              ON ms.mt_cd = mp.mt_cd
           GROUP BY mp.mt_cd)
            ,
            
-- 자재별 재고현황
 msp as (SELECT mp.mt_cd
		        ,SUM(ms.stk_qt) AS sum_stk_qt
		        ,SUM(mp.placeod_qt) AS safe_stk_qt
		       ,SUM(ms.stk_qt) as nn
               , SUM(mp.placeod_qt) AS qt_difference
		FROM mt_placeod mp 
		JOIN mt_stk ms
		  ON ms.mt_cd = mp.mt_cd
		WHERE placeod_reqdt BETWEEN TO_CHAR(add_months(SYSDATE, -1), 'yyyy-mm-dd') AND SYSDATE
		GROUP BY mp.mt_cd)
        ,
        
-- 자재별 차주 생산계획현황 
 mpp as (SELECT b.mt_cd
                ,ab.pd_cd
                ,ab.pqt
                ,b.unit
                ,b.consum
        FROM bom b 
        JOIN (SELECT pd_cd ,SUM(qt / 24) pqt
             FROM pdt_plan_detail 
             WHERE pdt_plan_cd = 'K240408'
             GROUP BY pd_cd) ab
        ON b.pd_cd = ab.pd_cd)
 
 SELECT DISTINCT m.mt_div
        ,m.mt_cd
        ,m.mt_name
        ,m.unit
        ,CASE WHEN mpp.unit = 'Bag' THEN mpp.pqt
              WHEN mpp.unit = 'Box' THEN (SELECT SUM(mpp.pqt) FROM mpp WHERE mpp.unit = 'Box') * mpp.consum
              WHEN mpp.unit = 'pcs' THEN mpp.pqt * mpp.consum
         END  AS pqtt
        ,msp.sum_stk_qt
        ,NVL(p.pqd, 0) AS sum_placeod_qt
        ,TRUNC(msp.safe_stk_qt * (m.safe_stk_rate / 100)) AS safe_stk_qt
        ,msp.nn + NVL(p.pqd, 0) - TRUNC(msp.safe_stk_qt * m.safe_stk_rate / 100) - (CASE WHEN mpp.unit = 'Bag' THEN mpp.pqt
                                                                                        WHEN mpp.unit = 'Box' THEN (SELECT SUM(mpp.pqt) FROM mpp WHERE mpp.unit = 'Box') * mpp.consum
                                                                                        WHEN mpp.unit = 'pcs' THEN mpp.pqt * mpp.consum
                                                                                   END) AS qt_difference     
FROM msp 
LEFT OUTER JOIN p
  ON msp.mt_cd = p.mt_cd
JOIN mt m
  ON m.mt_cd = msp.mt_cd
JOIN mpp
  ON mpp.mt_cd = msp.mt_cd
ORDER BY qt_difference
;


--=========================================
select *
from mt_ck;
mc_name

select *
from mt_stk;
select *
from mt_str;
select *
from mt_placeod;


SELECT mk.mt_lot
       ,mk.mt_cd
       ,mk.stk_qt
       ,mk.exp_dt
       ,mr.str_compdt
FROM   mt_stk mk
JOIN   mt_str mr
ON     mk.mt_str_no = mr.mt_str_no
WHERE  mk.mt_cd = 'MCT01'
ORDER BY str_compdt;


SELECT m.mt_div, ms.mt_cd, m.mt_name, SUM(ms.stk_qt), m.unit
FROM mt_stk ms
JOIN mt m
ON m.mt_cd = ms.mt_cd
WHERE m.mt_cd LIKE '%MC%'
GROUP BY m.mt_div, ms.mt_cd, m.mt_name, m.unit
ORDER BY mt_div desc;

select * from mt_placeod;
select * from mt_str;
select * from mt_stk;
select *
from pdt_plan_detail
WHERE pdt_plan_cd = 'K240408';
select *
from pdtplan;

SELECT pd_cd, SUM(qt)
FROM pdt_plan_detail
WHERE pdt_plan_cd = 'K240408'
GROUP BY pd_cd;

SELECT *
FROM pdt_plan_detail pd
JOIN pdtplan p
ON p.pdt_plan_cd = pd.pdt_plan_cd
WHERE p.pdt_plan_cd = 'K240408';

SELECT *
FROM bom;
        SELECT b.mt_cd, ab.pd_cd, ab.pqt, b.unit, b.consum
        FROM bom b JOIN
        (SELECT pd_cd ,SUM(qt / 24) pqt
        FROM pdt_plan_detail 
        WHERE pdt_plan_cd = 'K240408'
        GROUP BY pd_cd) ab
        ON b.pd_cd = ab.pd_cd;
        WHERE b.detail_unit = 'kg';

SELECT b.mt_cd, ab.pd_cd, ab.pqt, b.unit
FROM bom b JOIN
(SELECT pd_cd ,SUM(qt / 24) pqt
FROM pdt_plan_detail 
WHERE pdt_plan_cd = 'K240408'
GROUP BY pd_cd) ab
ON b.pd_cd = ab.pd_cd;

SELECT pd.pd_cd, b.unit, b.consum, CASE WHEN b.unit = 'Bag' THEN (SUM(pd.qt / 24))
                                        WHEN b.unit = 'Box' THEN (SUM(pd.qt / 24) * b.consum)
                                        WHEN b.unit = 'pcs' THEN (SUM(pd.qt / 24) * b.consum)
                                   END  AS pqt   
FROM pdt_plan_detail pd JOIN
bom b
ON b.pd_cd = pd.pd_cd
WHERE pd.pdt_plan_cd = 'K240408'
GROUP BY pd.pd_cd, b.unit, b.consum
ORDER BY pd.pd_cd;

SELECT pd.pd_cd, b.unit, b.consum  
FROM pdt_plan_detail pd JOIN
bom b
ON b.pd_cd = pd.pd_cd
WHERE pd.pdt_plan_cd = 'K240408'
GROUP BY pd.pd_cd, b.unit, b.consum
ORDER BY pd.pd_cd;

SELECT pd_cd ,SUM(qt * 30 / 24) pqt
FROM pdt_plan_detail 
WHERE pdt_plan_cd = 'K240408'
GROUP BY pd_cd;

(SELECT pd_cd ,SUM(qt) pqt
        FROM pdt_plan_detail 
        WHERE pdt_plan_cd = 'K240408'
        GROUP BY pd_cd);

SELECT pd_cd, mt_cd
FROM bom
WHERE detail_unit = 'kg';

SELECT pd.pd_cd, SUM(pd.qt * 30 / 24) AS qt;
SELECT *
FROM
(
SELECT pd_cd, SUM(qt)
FROM pdt_plan_detail
WHERE pdt_plan_cd = 'K240408'
GROUP BY pd_cd
) pd
LEFT OUTER JOIN bom
  ON pd.pd_cd = bom.pd_cd
;

(SELECT MIN(pdt_plan_cd) 
		             					 FROM PDTPLAN 
		             					 WHERE wk_plan_stt_dt > (SELECT MAX(wk_plan_stt_dt) 
		             					 						FROM pdtplan 
		             					 						WHERE wk_plan_stt_dt <= SYSDATE));
-- 발주진행중인 자재 수량
		with p as (SELECT mp.mt_cd 
		                  ,SUM(mp.placeod_qt) as pqd
		            FROM (SELECT mt_cd
		                        ,placeod_qt  
		                    FROM mt_placeod 
		                    WHERE placeod_st BETWEEN 2 AND 5) mp 
		            JOIN mt_stk ms
		              ON ms.mt_cd = mp.mt_cd
		           GROUP BY mp.mt_cd)
		            ,
		            
		-- 자재별 재고현황
		 msp as (SELECT mp.mt_cd
				        ,SUM(ms.stk_qt) AS sum_stk_qt
				        ,SUM(mp.placeod_qt) AS safe_stk_qt
				        ,SUM(ms.stk_qt) as nn
		                ,SUM(mp.placeod_qt) AS qt_difference
				FROM mt_placeod mp 
				JOIN mt_stk ms
				  ON ms.mt_cd = mp.mt_cd
				WHERE placeod_reqdt BETWEEN TO_CHAR(add_months(SYSDATE, -1), 'yyyy-mm-dd') AND TO_CHAR(SYSDATE, 'yyyy-mm-dd')
				GROUP BY mp.mt_cd)
		        ,
		        
		-- 자재별 차주 생산계획현황 
		 mpp as (SELECT b.mt_cd
		                ,ab.pd_cd
		                ,ab.pqt
		                ,b.unit
		                ,b.consum
		        FROM bom b 
		        JOIN (SELECT pd_cd ,SUM(qt / 24) pqt
		             FROM pdt_plan_detail 
		             WHERE pdt_plan_cd = (SELECT MIN(pdt_plan_cd) 
		             					 FROM PDTPLAN 
		             					 WHERE wk_plan_stt_dt > (SELECT MAX(wk_plan_stt_dt) 
		             					 						FROM pdtplan 
		             					 						WHERE wk_plan_stt_dt <= SYSDATE))
		             GROUP BY pd_cd) ab
		        ON b.pd_cd = ab.pd_cd)
		 
		 SELECT DISTINCT m.mt_div
		        ,m.mt_cd
		        ,m.mt_name
		        ,m.unit
		        ,CASE WHEN mpp.unit = 'Bag' THEN mpp.pqt
		              WHEN mpp.unit = 'Box' THEN (SELECT SUM(mpp.pqt) FROM mpp WHERE mpp.unit = 'Box') * mpp.consum
		              WHEN mpp.unit = 'pcs' THEN mpp.pqt * mpp.consum
		         END  AS pqtt
		        ,msp.sum_stk_qt
		        ,NVL(p.pqd, 0) AS sum_placeod_qt
		        ,TRUNC(msp.safe_stk_qt * (m.safe_stk_rate / 100)) AS safe_stk_qt
		        ,msp.nn + NVL(p.pqd, 0) - TRUNC(msp.safe_stk_qt * m.safe_stk_rate / 100) - (CASE WHEN mpp.unit = 'Bag' THEN mpp.pqt
			                                                                                     WHEN mpp.unit = 'Box' THEN (SELECT SUM(mpp.pqt) FROM mpp WHERE mpp.unit = 'Box') * mpp.consum
			                                                                                     WHEN mpp.unit = 'pcs' THEN mpp.pqt * mpp.consum
			                                                                                END) AS qt_difference    
		FROM msp 
		LEFT OUTER JOIN p
		  ON msp.mt_cd = p.mt_cd
		JOIN mt m
		  ON m.mt_cd = msp.mt_cd
		JOIN mpp
		  ON mpp.mt_cd = msp.mt_cd
		ORDER BY qt_difference;
-- 차주 계획 가져오는 쿼리 ( where 절에 수정해서 넣기) - 지금은 'K240408' 로 우선 하기.
select min(pdt_plan_cd) from PDTPLAN where wk_plan_stt_dt > (select max(wk_plan_stt_dt) from PDTPLAN where wk_plan_stt_dt <= sysdate);

SELECT *
from PDTPLAN;

SELECT  m.mt_div
        ,m.mt_cd
        ,m.mt_name
        ,m.unit
        ,SUM(ms.stk_qt) AS sum_stk_qt
        ,NVL((SELECT SUM(mp.placeod_qt)
                FROM (SELECT mt_cd, placeod_qt  
                        FROM mt_placeod 
                        WHERE placeod_st BETWEEN 2 AND 5) mp 
                        RIGHT OUTER JOIN mt_stk ms
                        ON ms.mt_cd = mp.mt_cd
                WHERE mp.mt_cd = m.mt_cd), 0) AS sum_placeod_qt
        ,(SUM(mp.placeod_qt) * (m.safe_stk_rate / 100)) AS safe_stk_qt
        ,(SUM(ms.stk_qt) + NVL((SELECT SUM(mp.placeod_qt)
                                FROM (SELECT mt_cd, placeod_qt 
                                        FROM mt_placeod 
                                        WHERE placeod_st BETWEEN 2 AND 5) mp 
                                        RIGHT OUTER JOIN mt_stk ms
                                        ON ms.mt_cd = mp.mt_cd
                                WHERE mp.mt_cd = m.mt_cd), 0) - (SUM(mp.placeod_qt) * (m.safe_stk_rate / 100))) AS qt_difference
FROM mt_placeod mp JOIN mt m
ON mp.mt_cd = m.mt_cd
JOIN mt_stk ms
ON ms.mt_cd = mp.mt_cd
WHERE placeod_reqdt BETWEEN TO_CHAR(add_months(SYSDATE, -1), 'yyyy-mm-dd') AND SYSDATE
GROUP BY m.mt_cd, m.safe_stk_rate, m.mt_name, m.mt_div, m.unit;

SELECT mt_cd, placeod_qt 
FROM mt_placeod 
WHERE placeod_st BETWEEN 2 AND 5;




SELECT SUM(placeod_qt)
FROM (SELECT * FROM mt_placeod WHERE placeod_st BETWEEN 2 AND 5);

SELECT SUM(mp.placeod_qt)
FROM mt_placeod mp JOIN mt_stk ms
ON ms.mt_cd = mp.mt_cd
WHERE mp.placeod_st BETWEEN 2 AND 5 AND ms.mt_cd = 'MBX01';
GROUP BY mp.mt_cd;

SELECT ms.mt_cd, SUM(mp.placeod_qt)
FROM (SELECT * FROM mt_placeod WHERE placeod_st BETWEEN 2 AND 5) mp RIGHT OUTER JOIN mt_stk ms
ON ms.mt_cd = mp.mt_cd
GROUP BY ms.mt_cd;

SELECT * FROM mt_placeod WHERE placeod_st BETWEEN 2 AND 5;
select *
from mt_stk;
SELECT *
FROM mt_ck;


select pdt_plan_cd, count(pd_name)-1 as cnt, min(pd_name) as pd_name from 
        (select p.pdt_plan_cd, d.pd_name 
        	from pdt_plan_detail d 
        	right outer join PDTPLAN p on p.pdt_plan_cd=d.pdt_plan_cd 
        	GROUP by p.pdt_plan_cd, d.pd_name 
        	order by p.pdt_plan_cd) 
        		group by pdt_plan_cd;
SELECT * FROM pdt_plan_detail;
select  rownum,
        m.MT_CD,
        m.MT_DIV,
        m.MT_NAME,
        m.COST,
        m.UNIT,
        m.EXP_DT,
        m.LEADTM,
        m.SAFE_STK_RATE,
        m.CLI_CD,
        c.cli_name
from mt m join cli c
on m.cli_cd = c.cli_cd
WHERE m.mt_div = '원자재'
ORDER BY mt_cd;

select *
from cli;

select ADD_MONTHS(sysdate, 6)
from dual;

insert into cli
values('MCLI001', '코빈즈 커피', '417-81-51119', '033-255-7189', '강원도 춘천시 동면 노루목길 8-24 코빈즈 커피', '김철수 과장', 'cobeanscoffee@gmail.com');
insert into cli
values('MCLI002', '블레스빈', '573-88-01179', '031-705-8150', '경기도 성남시 분당구 장안로 27, SNH타워 4층 401호', '박민수 대리', 'blessbean@blessbean.com');
insert into cli
values('MCLI003', '카페 노갈레스', '606-86-53444', '1588-1730', '경기도 광주시 광남안로 313', '홍길동 부장', 'info@cafenogales.com');
insert into cli
values('MCLI004', '1597coffee', '220-81-62517', '1588-3819', '경기도 성남시 분당구 정자일로 95', '최영호 주임', 'helpcustomer@naver.com');
insert into cli
values('MCLI005', '엠아이 커피', '114-86-71787', '02-537-5013', '서울특별시 서초구 서초대로25길 32 (엠아이 빌딩)', '김라희 실장', 'cs@micoffee.co.kr');

insert into cli
values('MCLI006', 'PAI PACK', '261-81-25319', '1566-4198', '서울특별시 강남구 논현로28길 348 2층', '박정식 부장', 'paipack@cgx.kr');
insert into cli
values('MCLI007', 'BOX4U', '123-81-99654', '031-358-2738', '경기도 화성시 장안면 남양호로 81-15', '김이창 과장', 'webmaster@box4u.co.kr');

insert into mt
values('MET01', '원자재', '에티오피아 생두', 339000, 'bag', 6, 4, 30, 'MCLI001');
insert into mt
values('MET01', '원자재', '에티오피아 생두', 339000, 'bag', 6, 4, 30, 'MCLI001');
insert into mt
values('MCT01', '원자재', '코스타리카 생두', 422000, 'bag', 10, 4, 30, 'MCLI005');
MCV04	부자재	페루 원두 봉투	600	pcs	0	3	30	MCLI006
MCV05	부자재	코스타리카 원두 봉투	600	pcs	0	3	30	MCLI006
MBR01	원자재	브라질 생두	273000	bag	8	3	30	MCLI002
MCB01	원자재	콜롬비아 생두	372000	bag	8	3	30	MCLI003
MPR01	원자재	페루 생두 (고품질)	736000	bag	12	5	20	MCLI004
MCV01	부자재	에티오피아 원두 봉투	600	pcs	0	3	30	MCLI006
MCV02	부자재	브라질 원두 봉투	600	pcs	0	3	30	MCLI006
MCV03	부자재	콜롬비아 원두 봉투	600	pcs	0	3	30	MCLI006
MBX01	부자재	포장 박스	1400	box	0	4	30	MCLI007


SELECT *
FROM mt_placeod;
insert into mt_placeod
values(SEQ_MT_PLACEOD.nextval, '30', sysdate, null, '청길동 부장', null, 1, 'MBR01', 'MCLI002');

select *
from mt_placeod;

delete mt_placeod
where mt_placeod_cd = 21;

SELECT  m.mt_div,
        m.mt_cd,
        m.mt_name,
        c.cli_name,
        mp.placeod_reqdt,
        mp.placeod_qt,
        m.unit,
        mp.placeod_requester
FROM mt_placeod mp JOIN mt m
ON mp.mt_cd = m.mt_cd
JOIN cli c
ON mp.cli_cd = c.cli_cd
WHERE mp.placeod_st = 1
ORDER BY mp.placeod_reqdt;

SELECT  m.mt_cd,
        m.mt_name,
        c.cli_cd
FROM    mt m JOIN cli c
ON      m.cli_cd = c.cli_cd
WHERE   m.cli_cd = 'MCLI006';


ALTER TABLE mt_placeod MODIFY (placeod_reqdt DEFAULT sysdate);
ALTER TABLE mt_placeod MODIFY (placeod_st DEFAULT 1);

SELECT table_name
     , column_name
     , data_type
     , data_default
  FROM all_tab_columns
 WHERE table_name = 'mt';
 
 SELECT  m.mt_div,
		        m.mt_cd,
		        m.mt_name,
		        c.cli_name,
		        mp.placeod_reqdt,
		        mp.placeod_qt,
		        m.unit,
		        mp.placeod_requester
		FROM 	mt_placeod mp JOIN mt m
		ON mp.mt_cd = m.mt_cd
		JOIN cli c
		ON mp.cli_cd = c.cli_cd
		WHERE mp.placeod_st = 1
		ORDER BY mp.placeod_reqdt;
        
select *
from mt_placeod;   

select leadtm
from mt
where mt_cd = 'MET01';
select *
from mt;

UPDATE  mt_placeod
SET     placeod_st = 2,
        placeod_compdt = sysdate,
        placeod_chg = '박민수 대리'
WHERE   mt_placeod_cd = 62;

update mt_placeod
set placeod_st = 1,
    placeod_compdt = null,
    placeod_chg = null
    where mt_placeod_cd = 81;
    
        SELECT  
		        m.mt_cd,
		        m.mt_div,
		        m.mt_name,
		        m.cost,
		        m.unit,
                case when m.exp_dt = 0 then null
                end as exp_dt,
		        m.leadtm,
		        m.safe_stk_rate,
		        m.cli_cd,
		        c.cli_name
		FROM 	mt m join cli c
		ON 		m.cli_cd = c.cli_cd
		WHERE 	m.mt_div = '부자재'
		ORDER BY mt_cd;
        
        select *
        from p;
        select *
        from mt;
        
		SELECT  mp.mt_placeod_cd,
				m.mt_div,
		        m.mt_cd,
		        m.mt_name,
		        c.cli_name,
		        mp.placeod_reqdt,
		        mp.placeod_qt,
		        m.unit,
		        mp.placeod_st,
		        mp.placeod_requester,
		        m.leadtm
		FROM 	mt_placeod mp JOIN mt m
		ON mp.mt_cd = m.mt_cd
		JOIN cli c
		ON mp.cli_cd = c.cli_cd
		WHERE mp.placeod_st = 1
		ORDER BY mp.placeod_reqdt;
        
        
        SELECT  m.mt_cd,
                m.mt_name,
                c.cli_name,
                mp.placeod_compdt + m.leadtm AS placeod_arridt,
                mp.placeod_qt,
                m.unit,
                mp.placeod_chg
        FROM 	mt_placeod mp JOIN mt m
		ON mp.mt_cd = m.mt_cd
		JOIN cli c
		ON mp.cli_cd = c.cli_cd
        WHERE mp.placeod_st = 3
        order by placeod_arridt;
        
select *
from mt_ck;
select *
from mt;

SELECT  cli_cd,
        cli_name
FROM    cli
WHERE   cli_cd LIKE 'M%'
ORDER BY cli_cd;

UPDATE cli
SET cli_name = 'BOX4U (포장박스)'
WHERE cli_cd = 'MCLI007';

select *
from mt_placeod;
UPDATE  mt_placeod
SET     placeod_st = 4
WHERE   mt_placeod_cd = ;

select *
from mt;

select *
from mt_placeod;
select *
from mt_ck;

select *
from mt_str;


SELECT p.mt_placeod_cd,
		       p.cli_cd,
		       p.mt_cd,
		       p.placeod_qt,
		       p.placeod_reqdt,
		       p.placeod_compdt,
		       p.placeod_requester,
		       p.placeod_chg,
		       p.placeod_st,
		       m.mt_name,
		       c.cli_name
		  FROM mt_placeod p 
		  JOIN mt m ON p.mt_cd = m.mt_cd
		  JOIN cli c ON p.cli_cd = c.cli_cd
            WHERE p.PLACEOD_ST=4
	  ORDER BY p.mt_placeod_cd	   ;     
	    
        
SELECT *
FROM mt;
SELECT *
FROM mt_ck;
SELECT *
FROM mt_placeod;
SELECT *
FROM mt_stk;
SELECT *
FROM mt_str;
update mt_placeod
set placeod_st = 5
where mt_placeod_cd = 1;

create SEQUENCE seq_mt_str_no;

SELECT  m.mt_cd,
        m.mt_name,
        mp.placeod_qt,
        m.unit,
        mc.ck_dt,
        mc.ck_chg
FROM mt m JOIN mt_placeod mp
ON m.mt_cd = mp.mt_cd
JOIN mt_ck mc
ON mc.mt_placeod_cd = mp.mt_placeod_cd
WHERE mp.placeod_st = 5 AND mc.mc_res = '합격'
ORDER BY mc.str_comp_dt; 

SELECT  m.mt_cd,
        m.mt_name,
        mp.placeod_qt,
        m.unit,
        mp.placeod_compdt + m.leadtm AS placeod_arridt, -- 자재도착일
        mp.placeod_chg -- 발주담당자
FROM mt m JOIN mt_placeod mp
ON m.mt_cd = mp.mt_cd
WHERE mp.placeod_st = 3 AND m.mt_div = '부자재'
ORDER BY placeod_arridt;  -- 자재 도착일 기준으로 하기.

select *
from mt_ck;

SELECT  m.mt_cd,
		        m.mt_name,
		        mp.placeod_qt,
		        mp.mt_placeod_cd,
		        m.unit,
		        mc.ck_dt,
		        mc.ck_chg
		FROM mt m JOIN mt_placeod mp
		ON m.mt_cd = mp.mt_cd
		JOIN mt_ck mc
		ON mc.mt_placeod_cd = mp.mt_placeod_cd
		WHERE mp.placeod_st = 5 AND mc.mc_res = '불합격'
		ORDER BY mc.str_comp_dt;
        
update mt_ck
set ck_chg = '김영희 대리'
where mt_ck_no = 41;

select *
from mt_rtn;
select *
from mt_placeod;
select *
from mt;
select *
from mt_str;
select *
from mt_stk;
create sequence SEQ_MT_STK_NO;
create or replace PROCEDURE PRO_MT_STK_NO IS L_VAL NUMBER;
BEGIN

    EXECUTE IMMEDIATE 'SELECT SEQ_MT_STK_NO.NEXTVAL FROM DUAL' INTO L_VAL;
    
    EXECUTE IMMEDIATE 'ALTER SEQUENCE SEQ_MT_STK_NO INCREMENT BY -'|| L_VAL ||' MINVALUE 0';
    
    EXECUTE IMMEDIATE 'SELECT SEQ_MT_STK_NO.NEXTVAL FROM DUAL' INTO L_VAL;
    
    EXECUTE IMMEDIATE 'ALTER SEQUENCE SEQ_MT_STK_NO INCREMENT BY 1 MINVALUE 0';
 
END;
/

SELECT *
FROM OD;
SELECT *
FROM OD_DETAIL;
where od_no = 89;
SELECT *
FROM PD;

SELECT COUNT(od_no)-1 AS cnt, od_no
FROM od_detail
group by od_no;


SELECT o.od_dt
FROM od o JOIN od_detail od
ON o.od_no = od.od_no;
JOIN pd p
ON od.pd_cd = p.pd_cd;

SELECT *
        FROM (
        SELECT p.pd_name || ' 외 ' || (COUNT(od.od_no)-1) || '건' AS cnt, od.od_no
        FROM od_detail od
        JOIN pd p
        ON od.pd_cd = p.pd_cd
        group by od.od_no);

SELECT od_no, od_dt, od_chg, total_price, cli_cd, (SELECT (SELECT *
        FROM (
        SELECT p.pd_name
        FROM od_detail od JOIN pd p
        ON od.pd_cd = p.pd_cd
        )
        WHERE ROWNUM= 1) 
        || ' 외 ' || (COUNT(o.od_no)-1) || '건'
FROM od_detail od JOIN od o
ON o.od_no = od.od_no
GROUP BY o.od_no) as od_name
FROM OD
ORDER BY od_no desc; 
SELECT od_no, od_dt, od_chg, total_price, cli_cd
FROM OD
ORDER BY od_no desc; 

SELECT *
        FROM (
        SELECT p.pd_name || ' 외 ' || (COUNT(od.od_no)-1) || '건'
        FROM od_detail od JOIN pd p
        ON od.pd_cd = p.pd_cd
        group by 
        )
        

select o.OD_NO
        , o.OD_DT
        , o.OD_CHG
        , o.DC_RATE
        , o.TOTAL_PRICE
        , o.CLI_CD
        , c.cli_name
        , c.cli_chg
        , d.od_no
        , d.od_detailno
        , p.pd_name
        , d.due_dt
        , d.od_detail_st
        , d.pd_cd
from cli c 
        JOIN od o 
            ON c.cli_cd = o.cli_cd
        LEFT OUTER JOIN od_detail d
            ON o.od_no = d.od_no
        JOIN pd p
            ON d.pd_cd = p.pd_cd
ORDER BY d.od_detailno;

SELECT COUNT(o.od_no)
FROM od_detail od JOIN od o
ON o.od_no = od.od_no
WHERE o.od_no = 89;

SELECT exp_dt
FROM mt
WHERE mt_div = '원자재';

SELECT ADD_MONTHS(sysdate,-1) PREV_MONTH --이전달 
     , ADD_MONTHS(TO_DATE('2019-12-16','YYYY-MM-DD'), 1) NEXT_MONTH --다음달
  FROM DUAL;

 SELECT CASE WHEN exp_dt = 0 THEN null
            ELSE ADD_MONTHS(sysdate, exp_dt)
        END
    FROM mt
    WHERE mt_cd = 'MCT01';
SELECT *
FROM MT;

CREATE OR REPLACE PROCEDURE mt_storing(IO_strQt IN OUT NUMBER
    ,I_strChg IN VARCHAR2
    ,I_mtPlaceodCd IN VARCHAR2
    ,I_mtCd IN VARCHAR2
    ,I_exp_dt IN NUMBER)
IS
    v_currseq NUMBER;
    v_exp_dt DATE;
    v_mt_div NUMBER;
BEGIN
    INSERT INTO mt_str(MT_STR_NO, STR_QT, STR_COMPDT, STR_CHG, MT_PLACEOD_CD, MT_CD)
    VALUES(SEQ_MT_STR_NO.nextval, IO_strQt, SYSDATE, I_strChg, I_mtPlaceodCd, I_mtCd);

    SELECT SEQ_MT_STR_NO.currval INTO v_currseq
    FROM dual;
    
    SELECT  CASE WHEN I_exp_dt = 0 THEN null
                 ELSE ADD_MONTHS(sysdate, I_exp_dt)
            END INTO v_exp_dt
    FROM mt
    WHERE mt_cd = I_mtCd;
    
    IF      I_mtCd = 'MBX01' THEN
            v_mt_div := 100;
    ELSIF   I_mtCd LIKE 'MCV%' THEN
            v_mt_div := 50;
    ELSE    v_mt_div := 10;
    END IF;
    
    LOOP
    INSERT INTO mt_stk(MT_LOT, STK_QT, EXP_DT, MT_CD, MT_STR_NO)
    VALUES(I_mtCd || TO_CHAR(SYSDATE, 'yyMMdd') || LPAD(SEQ_MT_STK_NO.nextval, 4, 0) , v_mt_div, v_exp_dt, I_mtCd, v_currseq);
    IO_strQt := IO_strQt - v_mt_div;
    EXIT WHEN IO_strQt = 0;
    END LOOP;
    
END mt_storing;
/

select *
from mt_ck;
select *
from mt_placeod;
update mt_placeod
set placeod_st = 5
where mt_placeod_cd = 62;
drop SEQUENCE SEQ_MT_STK_NO INCREMENT BY 1 MINVALUE 0;
drop SEQUENCE SEQ_MT_STK_NO;
create SEQUENCE SEQ_MT_STK_NO;
select * from mt_stk;
delete mt_stk;
select * from mt_str;
delete mt_str;
select SEQ_MT_STK_NO.nextval from dual;
DECLARE
	IO_strQt number :;
BEGIN
	mt_storing(IO_strQt,'최민수 사원','61','MBX01',0); -- PROCEDURE CALL

	DBMS_OUTPUT.PUT_LINE( IO_strQt ); -- LOG
END;
