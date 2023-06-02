(clear)

(defglobal
	?*ACCESS* = 1
	?*END_LOOP* = 0
)

(deftemplate course
	(slot name)
	(slot level)
	(slot lab)
)

(deftemplate teachers
	(slot name)
	(slot days)
	(slot course)
	(slot lab)
)

(deftemplate schedual
	(slot name)
	(slot level)
	(slot teacher)
	(slot lab_teacher)
	(slot time)
	(slot day)
)

(deftemplate all-days
	(slot time)
	(slot day)
)

(deftemplate asserted-courses
	(slot name)
	(slot teacher)
	(slot lab_teacher)
)

(deffacts course
	(course (name LA) (level 1) (lab 0))
	(course (name DM) (level 1) (lab 0))
	(course (name CS) (level 1) (lab 1))
	(course (name PH1) (level 1) (lab 1))
	(course (name IAP) (level 1) (lab 1))
	(course (name PR1) (level 2) (lab 1))
	(course (name CAL1) (level 2) (lab 0))
	(course (name NA) (level 2) (lab 0))
)

(deffacts schedual
	(schedual (name LA) (level 1) (teacher SH) (time 1) (day 1))
	(schedual (name LA) (level 1) (teacher SH) (time 2) (day 1))
	(schedual (name DM) (level 1) (teacher YW) (time 3) (day 1))
	(schedual (name DM) (level 1) (teacher YW) (time 4) (day 1))
	(schedual (name CS) (level 1) (teacher WKh) (time 3) (day 2))
	(schedual (name CS) (level 1) (lab_teacher KN) (time 4) (day 2))
	(schedual (name PH1) (level 1) (teacher SAD) (time 1) (day 3))
	(schedual (name PH1) (level 1) (lab_teacher AS) (time 2) (day 3))
)

(deffacts all-days
   (all-days (time 1) (day 1))
   (all-days (time 2) (day 1))
   (all-days (time 3) (day 1))
   (all-days (time 4) (day 1))
   (all-days (time 1) (day 2))
   (all-days (time 2) (day 2))
   (all-days (time 3) (day 2))
   (all-days (time 4) (day 2))
   (all-days (time 1) (day 3))
   (all-days (time 2) (day 3))
   (all-days (time 3) (day 3))
   (all-days (time 4) (day 3))
   (all-days (time 1) (day 4))
   (all-days (time 2) (day 4))
   (all-days (time 3) (day 4))
   (all-days (time 4) (day 4))
   (all-days (time 1) (day 5))
   (all-days (time 2) (day 5))
   (all-days (time 3) (day 5))
   (all-days (time 4) (day 5))
)

(deffacts asserted-courses
	(asserted-courses (name PR1) (teacher 0) (lab_teacher TM))
	(asserted-courses (name PR1) (teacher FK) (lab_teacher 0))
	(asserted-courses (name IAP) (teacher 0) (lab_teacher TM))
	(asserted-courses (name IAP) (teacher FK) (lab_teacher 0))
)

(defrule R1
	(asserted-courses (name ?name) (teacher ?teacher) (lab_teacher ?lab_teacher))
	(course (name ?name) (level ?level) (lab ?lab))
=>
	(bind ?*END_LOOP* (+ ?*END_LOOP* 1))
	(do-for-all-facts ((?all all-days)) (> ?*END_LOOP* 0)
		(bind ?*ACCESS* (+ ?*ACCESS* 1))
		(do-for-all-facts ((?s schedual))
			(if (and (eq ?s:day ?all:day) (eq ?s:time ?all:time))
				then
				(if (or (eq ?s:teacher ?teacher) (eq ?s:level ?level) (eq ?s:name ?name))
					then
					(bind ?*ACCESS* (- ?*ACCESS* ?*ACCESS*))
				)
			)
		)
		(if (> ?*ACCESS* 0)
			then
			(assert
				(schedual
					(name ?name)
					(level ?level)
					(teacher ?teacher)
					(lab_teacher ?lab_teacher)
					(day ?all:day)
					(time ?all:time)
				)
			)
			(bind ?*END_LOOP* (- ?*END_LOOP* ?*END_LOOP*))
		)
	)
)

(reset)

(run)