(set-logic QF_S)
(set-info :status sat)

(declare-const Username String)
(declare-const Domainname String)
(declare-const Email String)

; username at most 64 chars and can't be empty
(assert (<= (str.len Username) 64))
(assert (> (str.len Username) 0))
; domain at most 256 chars and can't be empty
(assert (<= (str.len Domainname) 256))
(assert (> (str.len Domainname) 0))

; Email = Username ++ "@" ++ Domainname
(assert (= Email (str.++ Username "@" Domainname)))

; Email is matched by the following (very simplistic) pattern:
; (non-empty alphanumeric string) @ (one or more alphanumeric strings separated by periods)
(assert (str.in.re Email (re.++
	;; Username part
	(re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9")))
	(str.to.re "@")
	;; Domainname part
	(re.++
		(re.+ (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to.re ".")))
		(re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9")))))))

; Domainname is an IPv4 address
; Each Octet is 25[0-5] | 2[0-4][0-9] | [01]?[0-9][0-9]?
(assert (str.in.re Domainname
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
	)
	)))

; Can an email address matched by this regex and satisfying the length constraints
; contain an IPv4 address as the domain name?
(check-sat)
