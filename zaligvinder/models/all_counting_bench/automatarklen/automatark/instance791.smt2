(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\$(\d{1,3}(\,\d{3})*|(\d+))(\.\d{2})?$
(assert (str.in_re X (re.++ (str.to_re "$") (re.union (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.* (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9"))))) (re.+ (re.range "0" "9"))) (re.opt (re.++ (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; update\.cgi\s+wwwProbnymomspyo\u{2f}zowy
(assert (str.in_re X (re.++ (str.to_re "update.cgi") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "wwwProbnymomspyo/zowy\u{0a}"))))
; ^(([1-9]{1}\d{0,2},(\d{3},)*\d{3})|([1-9]{1}\d{0,}))$
(assert (not (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 0 2) (re.range "0" "9")) (str.to_re ",") (re.* (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ","))) ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (re.range "1" "9")) (re.* (re.range "0" "9")))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
