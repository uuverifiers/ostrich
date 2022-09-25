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

; Domainname is not a FQDN (does not contain '.')
(assert (not (str.in.re Domainname (re.++ (re.* re.all) (str.to.re ".") (re.* re.all)))))

(check-sat)
