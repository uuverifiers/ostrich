(set-logic QF_S)
(set-info :status sat)

(declare-const IPAddr String)
(declare-const o1 String)
(declare-const o2 String)
(declare-const o3 String)
(declare-const o4 String)

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

; IPAddr is the concatenation of four non-empty parts, one of which
; has length 1 and all of which have length at most 3
(assert (= IPAddr (str.++ o1 "." o2 "." o3 "." o4)))
(assert (and (>= (str.len o1) 1) (>= (str.len o2) 1) (>= (str.len o3) 1) (>= (str.len o4) 1)))
(assert (or (= (str.len o1) 1) (= (str.len o2) 1) (= (str.len o3) 1) (= (str.len o4) 1)))
(assert (and (<= (str.len o1) 3) (<= (str.len o2) 3) (<= (str.len o3) 3) (<= (str.len o4) 3)))

(check-sat)
