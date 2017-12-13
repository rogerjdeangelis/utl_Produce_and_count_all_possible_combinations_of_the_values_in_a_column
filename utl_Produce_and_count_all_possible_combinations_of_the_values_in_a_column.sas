Produce and count all possible combinations of the values in a column

Can anyone help me to solve below problem? I want to count number of students
that take all combinations of courses by gender. SAS Proc, data step or sql please.

see
https://goo.gl/cqKfQX
https://communities.sas.com/t5/SAS-Data-Management/Produce-and-count-all-possible-combinations-of-the-values-in-a/m-p/420568

INPUT
=====

 WORK.HAVE total obs=12                       RULES  (simple cartesian join by student_id)

  Explain how to get the count of males
  and females for Math x Computer
  combination
                                                        RULES
         STUDENT_                        |
  OBS       ID       COURSE      GENDER  |    * Lets examine Math x Computer
                                         |
    1      1001      Math          F     |    Math        Computer     F   ** 1 female
    2      1001      Computer      F     |    Physics     Computer     F
    3      1001      Physics       F     |    Physics     Math         F
                                         |
                                         |
                                         |
    4      1002      Math          M     |    * No possible Math * Computer
    5      1002      Physics       M     |
                                         |
                                         |    * all combinations
    6      1003      Math          M     |    Computer    Chemstry     M
    7      1003      Chemstry      M     |    Math        Chemstry     M
    8      1003      Computer      M     |    Math        Computer     M  ** 1 male
                                         |    Physics     Chemstry     M
                                         |    Physics     Computer     M
                                         |    Physics     Math         M
                                         |
    9      1003      Physics       M     |    * No possible Math * Computer
   10      1004      Chemstry      M     |
   11      1004      Computer      M     |    RESULT
   12      1004      Physics       M     |    Courses     Count_Male  Count_Female
                                              Math x Computer      1            1

PROCESS
=======
   proc sql;
     create
       table wantpre as
     * all two way combinations by student_id;
     select
        catx(' ',l.course, r.course) as courses length=32
       ,l.gender
     from
        have as l, have as r
     where
        l.course     > r.course and
        l.student_id = r.student_id
     union all
     * all three way combinations by student_id;
     select
       catx(' ',l.course, c.course ,r.course) as courses length=32
       ,l.gender
     from
        have as l,  have as c,  have as r
     where
        l.course < c.course and
        c.course < r.course and
        l.student_id = c.student_id  and
        c.student_id = r.student_id
   ;quit;

   proc corresp data=wantpre dim=1 observed;
   tables courses, gender;
   run;quit;

OUTPUT

 WORK.WANT total obs=11

   LABEL                        F     M    SUM

   Chemstry Computer Math       0     1      1
   Chemstry Computer Physics    0     2      2
   Chemstry Math Physics        0     1      1
   Computer Chemstry            0     2      2
   Computer Math Physics        1     1      2

   Math Chemstry                0     1      1
   Math Computer                1     1      2
   Physics Chemstry             0     2      2
   Physics Computer             1     2      3
   Physics Math                 1     2      3

   Sum                          4    15     19

*                _              _       _
 _ __ ___   __ _| | _____    __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \  / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/ | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|  \__,_|\__,_|\__\__,_|

;

data have;
  input Student_ID$ Course$ Gender$;
cards4;
1001 Math F
1001 Computer F
1001 Physics F
1002 Math M
1002 Physics M
1003 Math M
1003 Chemstry M
1003 Computer M
1003 Physics M
1004 Chemstry M
1004 Computer M
1004 Physics M
;;;;
run;quit;

*          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __
/ __|/ _ \| | | | | __| |/ _ \| '_ \
\__ \ (_) | | |_| | |_| | (_) | | | |
|___/\___/|_|\__,_|\__|_|\___/|_| |_|

;
proc sql;
  create
    table wantpre as
  select
     catx(' ',l.course, r.course) as courses length=32
    ,l.gender
  from
     have as l, have as r
  where
     l.course     > r.course and
     l.student_id = r.student_id
  union all
  select
    catx(' ',l.course, c.course ,r.course) as courses length=32
    ,l.gender
  from
     have as l,  have as c,  have as r
  where
     l.course < c.course and
     c.course < r.course and
     l.student_id = c.student_id  and
     c.student_id = r.student_id
;quit;

ods exclude all;
ods output observed=want;
proc corresp data=wantpre dim=1 observed;
tables courses, gender;
run;quit;
ods select all;



Up to 40 obs WORK.WANT total obs=11

Obs    LABEL                        F     M    SUM

  1    Chemstry Computer Math       0     1      1
  2    Chemstry Computer Physics    0     2      2
  3    Chemstry Math Physics        0     1      1
  4    Computer Chemstry            0     2      2
  5    Computer Math Physics        1     1      2

  6    Math Chemstry                0     1      1
  7    Math Computer                1     1      2
  8    Physics Chemstry             0     2      2
  9    Physics Computer             1     2      3
 10    Physics Math                 1     2      3

 11    Sum                          4    15     19



