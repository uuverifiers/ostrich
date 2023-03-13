(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \?<.+?>
(assert (str.in_re X (re.++ (str.to_re "?<") (re.+ re.allchar) (str.to_re ">\u{0a}"))))
; ^(([a-h,A-H,j-n,J-N,p-z,P-Z,0-9]{9})([a-h,A-H,j-n,J-N,p,P,r-t,R-T,v-z,V-Z,0-9])([a-h,A-H,j-n,J-N,p-z,P-Z,0-9])(\d{6}))$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 9 9) (re.union (re.range "a" "h") (str.to_re ",") (re.range "A" "H") (re.range "j" "n") (re.range "J" "N") (re.range "p" "z") (re.range "P" "Z") (re.range "0" "9"))) (re.union (re.range "a" "h") (str.to_re ",") (re.range "A" "H") (re.range "j" "n") (re.range "J" "N") (str.to_re "p") (str.to_re "P") (re.range "r" "t") (re.range "R" "T") (re.range "v" "z") (re.range "V" "Z") (re.range "0" "9")) (re.union (re.range "a" "h") (str.to_re ",") (re.range "A" "H") (re.range "j" "n") (re.range "J" "N") (re.range "p" "z") (re.range "P" "Z") (re.range "0" "9")) ((_ re.loop 6 6) (re.range "0" "9")))))
; /filename=[^\n]*\u{2e}wsz/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".wsz/i\u{0a}")))))
; (CREATE|ALTER) +(PROCEDURE|PROC|FUNCTION|VIEW) *(\[(.*)\]|(.*))
(assert (str.in_re X (re.++ (re.union (str.to_re "CREATE") (str.to_re "ALTER")) (re.+ (str.to_re " ")) (re.union (str.to_re "PROCEDURE") (str.to_re "PROC") (str.to_re "FUNCTION") (str.to_re "VIEW")) (re.* (str.to_re " ")) (re.union (re.++ (str.to_re "[") (re.* re.allchar) (str.to_re "]")) (re.* re.allchar)) (str.to_re "\u{0a}"))))
(check-sat)
