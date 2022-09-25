(set-logic QF_S)
(set-info :status sat)

(declare-const IPAddr String)

; IPAddr matched by (incorrect!) production validator
; (([0-2]*[0-9]+[0-9]+)\.([0-2]*[0-9]+[0-9]+)\.([0-2]*[0-9]+[0-9]+)\.([0-2]*[0-9]+[0-9]+))
(assert (str.in.re IPAddr (re.++
	(re.++ (re.* (re.range "0" "2")) (re.+ (re.range "0" "9")) (re.+ (re.range "0" "9")))
	(str.to.re ".")
	(re.++ (re.* (re.range "0" "2")) (re.+ (re.range "0" "9")) (re.+ (re.range "0" "9")))
	(str.to.re ".")
	(re.++ (re.* (re.range "0" "2")) (re.+ (re.range "0" "9")) (re.+ (re.range "0" "9")))
	(str.to.re ".")
	(re.++ (re.* (re.range "0" "2")) (re.+ (re.range "0" "9")) (re.+ (re.range "0" "9")))
	)))

; IPAddr NOT matched by reference validator

(assert (not (str.in.re IPAddr
	(re.++
	(re.union
		; 25[0-5]
		(re.++ (str.to.re "25") (re.range "0" "5"))
		; 2[0-4][0-9]
		(re.++ (str.to.re "2") (re.range "0" "4") (re.range "0" "9"))
		; [01]?[0-9][0-9]?
		(re.++ (re.opt (re.union (str.to.re "0") (str.to.re "1"))) (re.range "0" "9") (re.opt (re.range "0" "9")))
	)
	(str.to.re ".")
	(re.union
		; 25[0-5]
		(re.++ (str.to.re "25") (re.range "0" "5"))
		; 2[0-4][0-9]
		(re.++ (str.to.re "2") (re.range "0" "4") (re.range "0" "9"))
		; [01]?[0-9][0-9]?
		(re.++ (re.opt (re.union (str.to.re "0") (str.to.re "1"))) (re.range "0" "9") (re.opt (re.range "0" "9")))
	)
	(str.to.re ".")
	(re.union
		; 25[0-5]
		(re.++ (str.to.re "25") (re.range "0" "5"))
		; 2[0-4][0-9]
		(re.++ (str.to.re "2") (re.range "0" "4") (re.range "0" "9"))
		; [01]?[0-9][0-9]?
		(re.++ (re.opt (re.union (str.to.re "0") (str.to.re "1"))) (re.range "0" "9") (re.opt (re.range "0" "9")))
	)
	(str.to.re ".")
	(re.union
		; 25[0-5]
		(re.++ (str.to.re "25") (re.range "0" "5"))
		; 2[0-4][0-9]
		(re.++ (str.to.re "2") (re.range "0" "4") (re.range "0" "9"))
		; [01]?[0-9][0-9]?
		(re.++ (re.opt (re.union (str.to.re "0") (str.to.re "1"))) (re.range "0" "9") (re.opt (re.range "0" "9")))
	))
)))

(check-sat)
