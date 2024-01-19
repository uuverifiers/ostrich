(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^100$|^0$|^[1-9]{0,1}[0-9]{0,1}$|^[1-9]{0,1}[0-9]{0,1}\.[0-9]{1,3}$
(assert (not (str.in_re X (re.union (str.to_re "100") (str.to_re "0") (re.++ (re.opt (re.range "1" "9")) (re.opt (re.range "0" "9"))) (re.++ (re.opt (re.range "1" "9")) (re.opt (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re "\u{0a}"))))))
; ^([0-2]{0,1})([0-3]{1})(\.[0-9]{1,2})?$|^([0-1]{0,1})([0-9]{1})(\.[0-9]{1,2})?$|^-?(24)(\.[0]{1,2})?$|^([0-9]{1})(\.[0-9]{1,2})?$
(assert (not (str.in_re X (re.union (re.++ (re.opt (re.range "0" "2")) ((_ re.loop 1 1) (re.range "0" "3")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9"))))) (re.++ (re.opt (re.range "0" "1")) ((_ re.loop 1 1) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9"))))) (re.++ (re.opt (str.to_re "-")) (str.to_re "24") (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (str.to_re "0"))))) (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))) (str.to_re "\u{0a}"))))))
; TOOLBAR\s+dist\x2Eatlas\x2Dia\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "TOOLBAR") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "dist.atlas-ia.com\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
